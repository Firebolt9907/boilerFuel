import 'package:boiler_fuel/custom/cupertinoSheet.dart' as customCupertinoSheet;
import 'package:boiler_fuel/styling.dart';
import 'package:boiler_fuel/widgets/default_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.context,
    required this.title,
    this.trailingIcon,
    this.trailingPage,
    this.showBackButton = true,
  });
  final BuildContext context;
  final String title;
  final IconData? trailingIcon;
  final Widget? trailingPage;
  final bool showBackButton;

  @override
  Widget build(BuildContext context2) {
    return Container(
      decoration: BoxDecoration(
        color: DynamicStyling.getWhite(context),
        border: Border(
          bottom: BorderSide(
            color: DynamicStyling.getLightGrey(context),
            width: 2,
          ),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          if (showBackButton)
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: CupertinoNavigationBarBackButton(
                    color: DynamicStyling.getBlack(context),
                    previousPageTitle: "Back",
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop(context);
                      } else {
                        customCupertinoSheet.CupertinoSheetRoute.popSheet(
                          context,
                        );
                      }
                    },
                  ),
                ),
              ),
            )
          else
            SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 24.0, bottom: 18, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 120,
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          color: DynamicStyling.getBlack(context),
                        ),
                      ),
                    ),
                  ],
                ),
                trailingIcon != null && trailingPage != null
                    ? DefaultContainer(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          customCupertinoSheet.showCupertinoSheet<void>(
                            context: context,
                            useNestedNavigation: true,
                            pageBuilder: (BuildContext context) =>
                                trailingPage!,
                          );
                          // Navigator.push(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => DiningHallSearchScreen(
                          //       user: widget.user,
                          //       diningHall: widget.diningHall,
                          //     ),
                          //   ),
                          // );
                        },
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: DynamicStyling.getLightGrey(context),
                            width: 2,
                          ),
                        ),

                        child: Icon(
                          trailingIcon,
                          color: DynamicStyling.getBlack(context),
                          size: 20,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
