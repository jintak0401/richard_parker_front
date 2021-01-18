import 'package:flutter/material.dart';

class AuthFadeStack extends StatefulWidget {
  final int authScreenIndex;
  final List<Widget> authScreens;

  const AuthFadeStack({
    Key key,
    this.authScreenIndex,
    this.authScreens,
  }) : super(key: key);

  @override
  _AuthFadeStackState createState() => _AuthFadeStackState();
}

class _AuthFadeStackState extends State<AuthFadeStack>
    with SingleTickerProviderStateMixin {
  int _index;
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
    _animationController.forward();
    _index = widget.authScreenIndex;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AuthFadeStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.authScreenIndex != _index) {
      _animationController.reverse().then((value) {
        setState(() {
          _index = widget.authScreenIndex;
        });
        _animationController.forward();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: IndexedStack(
        index: _index,
        children: widget.authScreens,
      ),
    );
  }
}
