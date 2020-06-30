import 'package:flutter/material.dart';

class Headline extends ImplicitlyAnimatedWidget {
  final String text;
  final int index;

  Color get targetColor => index == 0 ? Colors.black : Colors.blue;

  Headline({@required this.text, @required this.index, Key key})
      : super(key: key, duration: Duration(milliseconds: 300));

  @override
  HeadlineState createState() => HeadlineState();
}

class HeadlineState extends AnimatedWidgetBaseState<Headline> {
  ColorTween _colorTween = ColorTween(
    begin: Colors.black,
    end: Colors.blue,
  );

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.text} (${widget.index})',
      style: TextStyle(color: _colorTween.evaluate(animation)),
    );
  }

  Color _color;

  @override
  void forEachTween(visitor) {
    _colorTween = visitor(
      _colorTween,
      widget.targetColor,
      (color) => ColorTween(begin: color),
    );
  }
}
