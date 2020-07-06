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
  _GhostFadeTween _colorTween;

  _SwitchStringTween _switchStringTween;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_switchStringTween.evaluate(animation)})',
      style: TextStyle(color: _colorTween.evaluate(animation)),
    );
  }

  Color _color;

  @override
  void forEachTween(visitor) {
    _colorTween = visitor(
      _colorTween,
      widget.targetColor,
      (color) => _GhostFadeTween(begin: color),
    );
    _switchStringTween = visitor(
      _switchStringTween,
      widget.text,
      (value) => _SwitchStringTween(begin: value),
    );
  }
}

class _GhostFadeTween extends Tween<Color> {
  Color begin;
  Color end;
  final Color middle = Colors.white;

  _GhostFadeTween({this.begin, this.end}) : super(begin: begin, end: end);

  Color lerp(double t) {
    if (t < 0.5) {
      return Color.lerp(begin, middle, t * 2);
    } else {
      return Color.lerp(middle, end, (t - 0.5) * 2);
    }
  }
}

class _SwitchStringTween extends Tween<String> {
  _SwitchStringTween({String begin, String end})
      : super(begin: begin, end: end);

  String lerp(double t) {
    if (t < 0.5) return begin;
    return end;
  }
}
