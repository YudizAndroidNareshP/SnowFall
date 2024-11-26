import 'package:flutter/material.dart';

class SnowfallConfig {
  final int numberOfSnowflakes;
  final Color snowColor;
  final double speed;
  final bool useEmoji;
  final List<String> customEmojis;
  final bool holdSnowAtBottom;
  final Duration cleanupDuration;
  final Duration accumulationDuration;
  final double minSnowflakeSize;
  final double maxSnowflakeSize;
  final double swingRange;
  final double rotationSpeed;
  final double maxSnowHeight;
  final bool enableSnowDrift;
  final double windForce;
  final bool enableRandomSize;
  final bool enableRandomOpacity;
  final double minOpacity;
  final double maxOpacity;

  const SnowfallConfig({
    this.numberOfSnowflakes = 200,
    this.snowColor = Colors.white,
    this.speed = 1.0,
    this.useEmoji = true,
    this.customEmojis = const ['❄️', '❅', '❆', '✻', '✼'],
    this.holdSnowAtBottom = true,
    this.cleanupDuration = const Duration(seconds: 3),
    this.accumulationDuration = const Duration(seconds: 10),
    this.minSnowflakeSize = 2.0,
    this.maxSnowflakeSize = 8.0,
    this.swingRange = 1.0,
    this.rotationSpeed = 1.0,
    this.maxSnowHeight = 50.0,
    this.enableSnowDrift = true,
    this.windForce = 0.0,
    this.enableRandomSize = true,
    this.enableRandomOpacity = true,
    this.minOpacity = 0.5,
    this.maxOpacity = 1.0,
  });
}
