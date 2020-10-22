import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SemiWheelScreen extends StatefulWidget {
  @override
  _SemiWheelScreenState createState() => _SemiWheelScreenState();
}

class _SemiWheelScreenState extends State<SemiWheelScreen> {
  void _showBottomSheet() {
    // showGeneralDialog(
    //     context: context,
    //     barrierDismissible: true,
    //     barrierLabel: "Comments",
    //     useRootNavigator: true,
    //     transitionDuration: Duration(seconds: 1),
    //     pageBuilder: (context, primaryAnimation, secondaryAnimation) {
    //       return FullscreenDialogueContainer(primaryAnimation:primaryAnimation);
    //     });

    Navigator.of(context).push(
      PageRouteBuilder(
          fullscreenDialog: true,
          barrierColor: Colors.black.withOpacity(.5),
          barrierLabel: "Comments",
          barrierDismissible: true,
          opaque: false,
          transitionsBuilder:
              (context, primaryAnimation, secondaryAnimation, child) {
            return child;
          },
          pageBuilder: (context, primaryAnimation, secondaryAnimation) {
            return FullscreenDialogueContainer(
                primaryAnimation: primaryAnimation);
          },
          transitionDuration: Duration(seconds: 1),
          reverseTransitionDuration: Duration(seconds: 1),
          maintainState: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: CupertinoButton.filled(
            child: Text("Show Comments"), onPressed: _showBottomSheet),
      ),
    );
  }
}

class FullscreenDialogueContainer extends StatefulWidget {
  final Animation<double> primaryAnimation;

  const FullscreenDialogueContainer({Key key, this.primaryAnimation})
      : super(key: key);

  @override
  _FullscreenDialogueContainerState createState() =>
      _FullscreenDialogueContainerState();
}

class _FullscreenDialogueContainerState
    extends State<FullscreenDialogueContainer> {
  double topPadding = 10;
  final radius = Radius.circular(12);

  bool something = false;

  // Offset from offscreen below to fully on screen.
  final Animatable<Offset> _kBottomUpTween = Tween<Offset>(
    begin: const Offset(0.0, 1.0),
    end: Offset.zero,
  );

  Animation<Offset> slideTransitionPosition;
  Alignment _dragAlignment = Alignment.topCenter;

  @override
  Widget build(BuildContext context) {
    final topSafeAreaPadding = MediaQuery.of(context).padding.top;
    topPadding = this.topPadding + topSafeAreaPadding;

    final Animation<double> _animation = CurvedAnimation(
      parent: widget.primaryAnimation,
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.easeInToLinear,
    );
    slideTransitionPosition =  _animation.drive(_kBottomUpTween);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SlideTransition(
          position: slideTransitionPosition,
          child: child,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: GestureDetector(
          // onPanDown: (details) {},
          // onPanUpdate: (details) {
          //   setState(() {
          //    _dragAlignment += Alignment(
          //                 details.delta.dx / (context.size.width / 2),
          //                 details.delta.dy / (context.size.height / 2),
          //               );
          //   });
          // },
          // onPanEnd: (details) {},
          onPanUpdate: (details){
            print(details);
            setState(() {
              _dragAlignment = Alignment(0,10);
            });
          },
          child: Align(
            alignment: _dragAlignment,
            child: ClipRRect(
              borderRadius: BorderRadius.all(radius),
              child: Scaffold(
                appBar: AppBar(),
                body: Container(width: 100, height: 100, color: Colors.red,),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
