import 'package:boiler_fuel/styling.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final List<Widget>? leadingActions;

  final void Function(BuildContext context)? onBackButtonPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackButtonPressed,
    this.leadingActions,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(23),
              bottomRight: Radius.circular(23),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0D1B2A),
                Color(0xFF1B263B),
                Color(0xFF415A77),
                Color(0xFF778DA9),
                Color(0xFF415A77),
              ],
              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: DynamicStyling.getBlack(context).withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),

        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: DynamicStyling.getWhite(context),
          ),
          toolbarHeight: 100,
          title: FittedBox(
            fit: BoxFit.fitWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: DynamicStyling.getWhite(context),
                    fontSize: 30,
                    fontFamily: '.SF Pro Display',
                    fontWeight: FontWeight.bold,
                    height: 0,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          leading: showBackButton
              ? Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: DynamicStyling.getWhite(context).withOpacity(0.1),
                    border: Border.all(
                      color: DynamicStyling.getWhite(context).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: IconButton(
                      splashColor: Colors.transparent,
                      splashRadius: 25,
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        onBackButtonPressed!(context);
                      },
                      color: DynamicStyling.getWhite(context),
                    ),
                  ),
                )
              : (leadingActions != null && leadingActions!.isNotEmpty
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: leadingActions!,
                      )
                    : null),
          // actions: [],
          actions: [
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions ?? [],
            ),
          ],
        ),
      ],
    );
  }
}
