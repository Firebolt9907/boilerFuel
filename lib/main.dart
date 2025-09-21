import 'package:boiler_fuel/api_key.dart';

import 'package:boiler_fuel/constants.dart';
import 'package:boiler_fuel/dbCalls.dart';
import 'package:boiler_fuel/firebase_options.dart';
import 'package:boiler_fuel/local_storage.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // random code to make the app look good on android
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  // init firebase
  Gemini.init(apiKey: ApiKeys.geminiApiKey);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(kDebugMode ? MyApp() : WelcomeScreen());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LocalDB.getUser().then((value) {
      print("Fetched user from local DB: ${value?.name}");
      setState(() {
        user = value;
      });
    });
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Food> data = [];
  String value = "";
  FirebaseDB db = FirebaseDB();
  late DietaryRestrictions dietaryRestrictions;

  @override
  void initState() {
    super.initState();
    // dietaryRestrictions = DietaryRestrictions(
    //   allergies: <FoodAllergy>[FoodAllergy.TreeNuts, FoodAllergy.Peanuts],
    //   preferences: <FoodPreference>[FoodPreference.Halal],
    //   ingredientPreferences: [],
    // );
    // getFoodData(true);
    // testPlanner(176, 70.86614173, 50, Gender.male);
    // MealPlanner.generateMeal(
    //   targetCalories: 757,
    //   targetProtein: 47.5,
    //   targetCarbs: 94.5,
    //   targetFat: 21,
    //   availableFoods: data,
    //   diningHall: "Wiley",
    // ).then((meal) {
    //   print("Generated Meal:");
    //   print(meal.toString());
    // });
  }

  void getFoodData([bool initial = false]) {
    db.getFoodIDsMeal("Ford", DateTime.now(), MealTime.lunch).then((data) {
      setState(() {
        this.data = data ?? [];
        List<List<Food>> temp = dietaryRestrictions.filterFoodList(this.data);
        List<Food> allowedFood = temp[0];
        List<Food> restrictedFood = temp[1];
        print("\nAllowed Food:");
        for (var item in allowedFood) {
          print({
            "name": item.name,
            "calories": item.calories,
            "protein": item.protein,
            "carbs": item.carbs,
            "fats": item.fat,
            "allergens": item.labels,
          });
        }
        print("\nRestricted Food:");
        for (var item in restrictedFood) {
          print({
            "name": item.name,
            "calories": item.calories,
            "protein": item.protein,
            "carbs": item.carbs,
            "fats": item.fat,
            "allergens": item.labels,
            "rejectedReason": item.rejectedReason,
          });
        }
      });
    });
  }

  void testPlanner(double weightLbs, double heightIn, int age, Gender sex) {
    var plan = CalorieMacroCalculator.calculateMacros(
      weightLbs: weightLbs,
      heightInches: heightIn,
      age: age,
      gender: sex,
      goal: Goal.lose,
    );
    print(plan.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => WelcomeScreen()),
                ); // Replace Container() with the other page
              },
              child: const Text('Open Other Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => HomeScreen()),
                ); // Replace Container() with the other page
              },
              child: const Text('Home Page'),
            ),
            Text(value, style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getFoodData,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
