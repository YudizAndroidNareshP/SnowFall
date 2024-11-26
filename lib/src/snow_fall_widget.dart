import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';
import 'package:snow_fall_animation/src/snow_fall_painter.dart';

class AccumulatedSnowflake {
  final double x;
  final double y;
  final double size;
  final int emojiIndex;
  final double rotation;
  final double alpha;

  AccumulatedSnowflake({
    required this.x,
    required this.y,
    required this.size,
    required this.emojiIndex,
    required this.rotation,
    required this.alpha,
  });
}

class SnowFallAnimation extends StatefulWidget {
  final SnowfallConfig config;

  const SnowFallAnimation({
    super.key,
    this.config = const SnowfallConfig(),
  });

  @override
  State<SnowFallAnimation> createState() => _SnowFallAnimationState();
}

class _SnowFallAnimationState extends State<SnowFallAnimation>
    with TickerProviderStateMixin {
  late List<Snowflake> fallingSnow = [];
  late List<AccumulatedSnowflake> oldAccumulatedSnow = [];
  late List<AccumulatedSnowflake> newAccumulatedSnow = [];
  late AnimationController _fallController;
  late AnimationController _cleanupController;
  Timer? _accumulationTimer;
  Size size = Size.zero;
  final Random _random = Random();
  bool isCleaningUp = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.config.holdSnowAtBottom) {
      _startAccumulationCycle();
    }
  }

  void _initializeControllers() {
    _fallController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _cleanupController = AnimationController(
      vsync: this,
      duration: widget.config.cleanupDuration,
    )..addStatusListener(_handleCleanupStatus);
  }

  void _startAccumulationCycle() {
    _accumulationTimer?.cancel();
    _accumulationTimer =
        Timer.periodic(widget.config.accumulationDuration, (_) {
      _startCleanup();
    });
  }

  void _handleCleanupStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        oldAccumulatedSnow = [];
        isCleaningUp = false;
      });
    }
  }

  void _startCleanup() {
    setState(() {
      isCleaningUp = true;
      oldAccumulatedSnow = List.from(newAccumulatedSnow);
      newAccumulatedSnow = [];
    });
    _cleanupController.forward(from: 0);
  }

  @override
  void dispose() {
    _fallController.dispose();
    _cleanupController.dispose();
    _accumulationTimer?.cancel();
    super.dispose();
  }

  void _updateSnowflakes() {
    for (var snowflake in fallingSnow) {
      // Update vertical position
      snowflake.y += snowflake.velocity * widget.config.speed;

      // Update horizontal position with wind and swing
      if (widget.config.enableSnowDrift) {
        snowflake.swingValue += 0.02 * widget.config.rotationSpeed;
        snowflake.x += sin(snowflake.swingValue) *
            snowflake.swing *
            widget.config.swingRange;
      }

      // Add wind force
      snowflake.x += widget.config.windForce * 0.1;

      // Update rotation
      snowflake.rotation +=
          0.01 * snowflake.velocity * widget.config.rotationSpeed;

      // Check for accumulation or reset
      if (widget.config.holdSnowAtBottom &&
          snowflake.y > size.height - _getSnowHeightAt(snowflake.x)) {
        if (!isCleaningUp ||
            newAccumulatedSnow.length < widget.config.numberOfSnowflakes) {
          _accumulateSnow(snowflake);
        }
        // Use the safe reset method that includes emoji list
        snowflake.reset(_random, size, widget.config.customEmojis);
      } else if (snowflake.y > size.height) {
        // Use the safe reset method that includes emoji list
        snowflake.reset(_random, size, widget.config.customEmojis);
      }

      // Keep within bounds
      if (snowflake.x > size.width) {
        snowflake.x = 0;
      } else if (snowflake.x < 0) {
        snowflake.x = size.width;
      }
    }
  }

  double _getSnowHeightAt(double x) {
    if (!widget.config.holdSnowAtBottom) return 0;

    double newHeight = widget.config.maxSnowHeight *
        (newAccumulatedSnow.length / widget.config.numberOfSnowflakes);

    if (isCleaningUp) {
      double oldHeight = widget.config.maxSnowHeight *
          (oldAccumulatedSnow.length / widget.config.numberOfSnowflakes) *
          (1 - _cleanupController.value);
      return max(newHeight, oldHeight);
    }

    return newHeight;
  }

  void _accumulateSnow(Snowflake snowflake) {
    newAccumulatedSnow.add(AccumulatedSnowflake(
      x: snowflake.x,
      y: size.height - _getSnowHeightAt(snowflake.x),
      size: snowflake.size,
      emojiIndex: snowflake.emojiIndex,
      rotation: snowflake.rotation,
      alpha: snowflake.alpha,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        size = Size(constraints.maxWidth, constraints.maxHeight);

        if (fallingSnow.isEmpty) {
          fallingSnow = List.generate(
            widget.config.numberOfSnowflakes,
            (_) => Snowflake.generate(size, _random, widget.config),
          );
        }

        return AnimatedBuilder(
          animation: Listenable.merge([_fallController, _cleanupController]),
          builder: (context, child) {
            _updateSnowflakes();
            return CustomPaint(
              painter: SnowPainter(
                fallingSnow: fallingSnow,
                oldAccumulatedSnow: oldAccumulatedSnow,
                newAccumulatedSnow: newAccumulatedSnow,
                config: widget.config,
                cleanupProgress: _cleanupController.value,
                isCleaningUp: isCleaningUp,
              ),
              size: Size.infinite,
            );
          },
        );
      },
    );
  }
}
