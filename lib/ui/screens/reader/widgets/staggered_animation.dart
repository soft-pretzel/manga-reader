import 'package:flutter/material.dart';

class StaggeredAnimation extends StatelessWidget {
  StaggeredAnimation({
    super.key,
    required this.animation,
    required this.animationController,
    required this.scaleBegin,
    required this.scaleEnd,
    required this.transformationController,
    required this.xBegin,
    required this.xEnd,
    required this.yBegin,
    required this.yEnd,
    required this.child,
  }) : x = Tween<double>(begin: xBegin ?? 0, end: xEnd ?? 0).animate(animation),
       y = Tween<double>(begin: yBegin ?? 0, end: yEnd ?? 0).animate(animation),
       scale = Tween<double>(
         begin: scaleBegin ?? 1,
         end: scaleEnd,
       ).animate(animation);

  final Animation<double> animation;
  final AnimationController animationController;
  final Widget child;
  final Animation<double> scale;
  final double? scaleBegin;
  final double? scaleEnd;
  final TransformationController transformationController;
  final Animation<double> x;
  final double? xBegin;
  final double? xEnd;
  final Animation<double> y;
  final double? yBegin;
  final double? yEnd;

  Widget _buildAnimation(BuildContext context, _) {
    transformationController.value = Matrix4.identity()
      ..translateByDouble(x.value, y.value, 1, 1)
      ..scaleByDouble(scale.value, scale.value, 1, 1);
    return InteractiveViewer(
      transformationController: transformationController,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: animationController,
    );
  }
}
