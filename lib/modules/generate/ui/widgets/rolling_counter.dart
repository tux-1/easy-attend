import 'package:flutter/material.dart';

class RollingCounter extends StatefulWidget {
  final num value;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final int decimalPlaces;
  final bool animateOnFirstBuild;

  const RollingCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutQuint,
    this.decimalPlaces = 0,
    this.animateOnFirstBuild = false,
  });

  @override
  State<RollingCounter> createState() => _RollingCounterState();
}

class _RollingCounterState extends State<RollingCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late num _oldValue;
  late num _newValue;
  bool _isFirstBuild = true;

  @override
  void initState() {
    super.initState();
    _oldValue = widget.value;
    _newValue = widget.value;

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (widget.animateOnFirstBuild) {
      _controller.forward();
    } else {
      _isFirstBuild = false;
    }
  }

  @override
  void didUpdateWidget(RollingCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _oldValue = oldWidget.value;
      _newValue = widget.value;
      _isFirstBuild = false;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(num value) {
    return value.toStringAsFixed(widget.decimalPlaces);
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle =
        Theme.of(context).textTheme.bodyLarge ?? const TextStyle();
    final textStyle = widget.style ?? defaultStyle;

    // If it's the first build and we're not animating, just show the value
    if (_isFirstBuild && !widget.animateOnFirstBuild) {
      return Text(_formatValue(_newValue), style: textStyle);
    }

    // Get the formatted strings for both values
    final oldValueText = _formatValue(_oldValue);
    final newValueText = _formatValue(_newValue);

    // Determine which text is wider to use for sizing
    final widerText =
        oldValueText.length >= newValueText.length
            ? oldValueText
            : newValueText;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return IntrinsicWidth(
          child: ClipRect(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Invisible text to maintain proper width and height
                Opacity(
                  opacity: 0,
                  child: Text(widerText, style: textStyle.copyWith(height: 1)),
                ),

                // Old value - moves up and fades out
                Positioned(
                  top:
                      -_animation.value *
                      textStyle.copyWith(height: 1).fontSize!,
                  child: Opacity(
                    opacity: 1.0 - _animation.value,
                    child: Text(
                      oldValueText,
                      style: textStyle.copyWith(height: 1),
                    ),
                  ),
                ),

                // New value - moves up from below and fades in
                Positioned(
                  top: textStyle.fontSize! * (1.0 - _animation.value),
                  child: Opacity(
                    opacity: _animation.value,
                    child: Text(
                      newValueText,
                      style: textStyle.copyWith(height: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
