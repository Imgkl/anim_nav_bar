import 'package:flutter/Material.dart';

class AnimNavBar extends StatefulWidget {
  ///  context - BuildContext  ,isRequired : Yes
  ///  height - double ,isRequired : Yes
  ///  globalKey - List<GlobalKey>, isRequired : Yes
  ///  icons - List<IconData>, isRequired : Yes
  ///  onChanged - Function(int) ,isRequired :  Yes
  ///  duration - Duration  ,isRequired : No
  ///  backgroundColor -  Color ,isRequired : No
  ///  unselectedIconColor -  Color ,isRequired : No
  ///  selectedIconColor -  Color ,isRequired : No
  ///  highLightColor -  Color ,isRequired : No
  ///  embossed - bool ,isRequired :  No
  final BuildContext context;
  final double height;
  final List<GlobalKey> globalKey;
  final List<IconData> icons;
  final Function(int) onChanged;
  final Duration duration;
  final Color backgroundColor;
  final Color unselectedIconColor;
  final Color selectedIconColor;
  final Color highLightColor;
  final bool embossed;

  const AnimNavBar({
    Key key,

    /// The height cannot be null
    @required this.height,

    /// The list of icons cannot be null
    @required this.icons,

    /// The onChanged function cannot be null
    @required this.onChanged,

    /// The list of globalKey cannot be null
    @required this.globalKey,

    /// The buildContext cannot be null
    @required this.context,

    /// The duration is a optional parameter and it is initialised with 900 milliseconds
    this.duration = const Duration(milliseconds: 300),

    /// The backgroundColor is a optional parameter and it is initialised with Color(0xff2c362f)
    this.backgroundColor = const Color(0xff2c362f),

    /// The unselectedIconColor is a optional parameter and it is initialised with Colors.grey
    this.unselectedIconColor = Colors.grey,

    /// The selectedIconColor is a optional parameter and it is initialised with Colors.white
    this.selectedIconColor = Colors.white,

    /// The highLightColor is a optional parameter and it is initialised with Colors.white
    this.highLightColor = Colors.white,

    /// The embossed is a optional parameter and it is initialised with false
    this.embossed = false,
  })  :

        /// GlobalKey cannot be null
        assert(globalKey != null && globalKey.length > 0),

        /// The list of icons cannot be null
        assert(icons != null && icons.length > 0),

        /// The onChanged cannot be null
        assert(onChanged != null),

        /// The List of icons length should be equal to the list of globalKey's length
        assert(icons.length != 0 &&
            globalKey.length != 0 &&
            icons.length == globalKey.length),

        /// The context cannot be null
        assert(context != null),

        /// The height cannot be null
        assert(height != null);
  @override
  _AnimNavBarState createState() => _AnimNavBarState();
}

class _AnimNavBarState extends State<AnimNavBar> with TickerProviderStateMixin {
  /// The current index is initialized with 0
  int currentIndex = 0;

  /// The margin is 16 on all horizontal
  double margin = 16;

  /// RenderBox for finding the actual position of the icons on the screen
  RenderBox renderBox;

  /// Actual position of the icons on the screen is initialized with 0
  double startXPosition = 0.0;

  /// On Tap, the renderBox of the new icon gets calculated and it's position is returned
  void onTabTap(int index) {
    /// Finding the render object using the global key
    renderBox = widget.globalKey[index].currentContext.findRenderObject();
    setState(() {
      /// Setting the startXPosition with the renderBox of the selected icon
      startXPosition = renderBox.localToGlobal(Offset.zero).dx;
    });
  }

  @override
  void initState() {
    /// When the widget gets mounted, this onTabTap gets run at the first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onTabTap(currentIndex);
    });
    super.initState();
  }

  /// The left position is calculated based on the items length of icons
  getLeftPosition(int iconsLength) {
    switch (iconsLength) {
      case 2:
        return startXPosition - 54;
        break;
      case 3:
        return startXPosition - 44;
        break;
      case 4:
        return startXPosition - 34;
        break;
      case 5:
        return startXPosition - 30;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /// The margin is initialised with 16
      margin: EdgeInsets.symmetric(horizontal: margin),
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            /// If the embossed is true, we show, the boxShadow is shown to imitate elevation
            widget.embossed
                ? BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: Offset(-5, 5))
                : BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                  )
          ]),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                /// Dynamically generate number of icons based on the list of icons length
                ...List.generate(
                    widget.icons.length,
                    (index) => Expanded(
                          flex: 1,
                          child: Container(
                              alignment: Alignment.center,
                              child: IconButton(
                                /// The key is what helps to calculate the render position of the icons on the screen
                                key: widget.globalKey[index],

                                /// The icons are rendered from the lsit of icons
                                icon: Icon(widget.icons[index]),
                                onPressed: () {
                                  setState(() {
                                    currentIndex = index;
                                  });

                                  /// The onTabTap method is called, to calculate the new position
                                  /// Of the selected icon so the highlighter
                                  /// Can be shown on top of that
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    onTabTap(index);
                                  });

                                  /// onChanged function gets called on every item tap
                                  widget.onChanged(index);
                                },

                                /// The selected icons shows a different colour than the unselected icon
                                color: index == currentIndex
                                    ? widget.selectedIconColor
                                    : widget.unselectedIconColor,
                              )),
                        ))
              ],
            ),
          ),

          /// If the startXPosition is 0.0, which it will be before the initState is called,
          /// So during that time, this widget will not be rendered
          if (startXPosition != 0.0)

            /// AnimatedPositioned is used to show the smooth transition between the highlighter's old and new position
            AnimatedPositioned(
              /// The duration is set to 300 milliseconds, but can be overridden, but the duration parameter
              duration: widget.duration,

              /// The spacing on the left is calculated based on the widget.icons.length and it is shown here
              left: getLeftPosition(widget.icons.length),
              child: IgnorePointer(
                /// We are ignoring the pointer here, that is invisible to hit testing.
                ignoring: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Container(
                    /// The alignment is center to make it visually pleasing
                    alignment: Alignment.center,

                    /// The width is calculated based on the width of the device
                    /// divided by the length of the icons list divided by 2
                    width: MediaQuery.of(context).size.width /
                        widget.icons.length /
                        2,

                    /// The height is fixed to 5
                    height: 5,

                    /// Basic decoration is done to make the edges of the highlighter round
                    /// And also the colour property is optional
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: widget.highLightColor),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
