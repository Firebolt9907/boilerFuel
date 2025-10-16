import 'dart:async';

import 'package:boiler_fuel/api/local_database.dart';
import 'package:boiler_fuel/api_key.dart';

import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/api/firebase_database.dart';
import 'package:boiler_fuel/firebase_options.dart';
import 'package:boiler_fuel/api/shared_preferences.dart';
import 'package:boiler_fuel/planner.dart';
import 'package:boiler_fuel/screens/home_screen.dart';
import 'package:boiler_fuel/screens/welcome_screen.dart';

import 'package:boiler_fuel/styling.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

final Styling styling = Styling();
AppDb localDb = AppDb();

final StreamController<Map<MealTime, Map<String, Meal>>> aiMealStream =
    StreamController<Map<MealTime, Map<String, Meal>>>.broadcast();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // random code to make the app look good on android
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  // init firebase
  Gemini.init(apiKey: ApiKeys.geminiApiKey);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  User? user = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    LocalDatabase().getUser().then((value) async {
      print("Fetched user from local DB: ${value?.name}");
      setState(() {
        user = value;
      });
      // await FBDatabase().createDiningHalls();
      // print("Ensured dining halls exist in Firebase");
      if (user != null) {
        DateTime latestMealPlanDate =
            (await LocalDatabase().getLastMeal()) ??
            DateTime.now().subtract(Duration(days: 1));
        //check if latestMealPlanDate is past 3 days in future
        DateTime now = DateTime.now();
        now = DateTime(now.year, now.month, now.day);
        latestMealPlanDate = DateTime(
          latestMealPlanDate.year,
          latestMealPlanDate.month,
          latestMealPlanDate.day,
        );
        LocalDatabase().listenToAIDayMeals(aiMealStream);
        // if (latestMealPlanDate.isAfter(now.add(Duration(days: 2)))) {
        // print("Meal plan is up to date");
        return;
        // }
        // await Future.delayed(Duration(seconds: 60));

        if (user!.useMealPlanning) {
          print(
            "generating meal plan for next day, latestMealPlanDate: $latestMealPlanDate",
          );
          MealPlanner.generateDayMealPlan(
            user: user!,
            date: latestMealPlanDate.add(Duration(days: 1)),
          );
        } else {
          print("User rejected permission to use AI");
        }
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        // bool isSignedIn = await Auth().isUserLoggedIn();
        LocalDatabase().getUser().then((value) async {
          print("Fetched user from local DB: ${value?.name}");
          setState(() {
            user = value;
          });
          if (user != null) {
            DateTime latestMealPlanDate =
                (await LocalDatabase().getLastMeal()) ??
                DateTime.now().subtract(Duration(days: 1));
            //check if latestMealPlanDate is past 3 days in future
            DateTime now = DateTime.now();
            now = DateTime(now.year, now.month, now.day);
            latestMealPlanDate = DateTime(
              latestMealPlanDate.year,
              latestMealPlanDate.month,
              latestMealPlanDate.day,
            );
            if (latestMealPlanDate.isAfter(now.add(Duration(days: 2)))) {
              print("Meal plan is up to date");
              return;
            }
            // await Future.delayed(Duration(seconds: 60));

            if (user!.useMealPlanning) {
              print(
                "generating meal plan for next day, latestMealPlanDate: $latestMealPlanDate",
              );
              MealPlanner.generateDayMealPlan(
                user: user!,
                date: latestMealPlanDate.add(Duration(days: 1)),
              );
            } else {
              print("User rejected permission to use AI");
            }
          }
        });
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");

        break;
      case AppLifecycleState.paused:
        print("app in paused");

        break;
      case AppLifecycleState.detached:
        print("app in detached");

        break;
      case AppLifecycleState.hidden:
        print("app in hidden");

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: user == null ? WelcomeScreen() : HomeScreen(user: user!),
    );
  }
}
