import 'package:anim_nav_bar/anim_nav_bar.dart';
import 'package:flutter/material.dart';

class AnimatedNavExample extends StatelessWidget {
  ///For each icon, you need to create a labeledGlobalKey and pass it to the global key parameter as list,
  ///Make sure, the global key is in same order as your icons
  final LabeledGlobalKey arrowForwardIos =
      LabeledGlobalKey("arrow_forward_ios");
  final LabeledGlobalKey arrowBackIos = LabeledGlobalKey("arrow_back_ios");
  final LabeledGlobalKey arrowForwardOutline =
      LabeledGlobalKey("arrow_forward_ios_outline");
  final LabeledGlobalKey arrowBackOutline =
      LabeledGlobalKey("arrow_back_ios_outline");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimNavBar(
          /// should be in same order as your icons
          globalKey: [
            arrowForwardIos,
            arrowBackIos,
            arrowBackOutline,
            arrowForwardOutline
          ],
          context: context,
          height: 50,
          /// should be in same order as your global key
          icons: [
            Icons.arrow_forward_ios,
            Icons.arrow_back_ios,
            Icons.arrow_back_ios_outlined,
            Icons.arrow_forward_ios_outlined,
          ],
          onChanged: (int) {
            print(int);
          },
        ),
      ),
    );
  }
}
