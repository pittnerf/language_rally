import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Animated feedback widget that displays a random icon based on success/failure
/// with a scale animation from 10% to 100% back to 0% over 2 seconds
class FeedbackAnimation extends StatefulWidget {
  final bool isSuccess;
  final VoidCallback? onComplete;

  const FeedbackAnimation({
    super.key,
    required this.isSuccess,
    this.onComplete,
  });

  @override
  State<FeedbackAnimation> createState() => _FeedbackAnimationState();
}

class _FeedbackAnimationState extends State<FeedbackAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late String _selectedIcon;

  static final List<String> _successIcons = [
    'assets/images/success_1.svg', // Trophy
    'assets/images/success_2.svg', // Star with Thumbs Up
    'assets/images/success_3.svg', // Rocket
  ];

  static final List<String> _encourageIcons = [
    'assets/images/encourage_1.svg', // Fist with Heart
    'assets/images/encourage_2.svg', // Forward Arrow
    'assets/images/encourage_3.svg', // Smiling Sun
  ];

  @override
  void initState() {
    super.initState();

    // Select random icon based on success/failure
    final random = math.Random();
    _selectedIcon = widget.isSuccess
        ? _successIcons[random.nextInt(_successIcons.length)]
        : _encourageIcons[random.nextInt(_encourageIcons.length)];

    // Create animation controller for 2 seconds
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Create scale animation: 0.1 -> 1.0 -> 0.0
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInBack)),
        weight: 50,
      ),
    ]).animate(_controller);

    // Start animation
    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SvgPicture.asset(
            _selectedIcon,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}

