import 'dart:math';
import 'package:flutter/material.dart';
import 'package:snow_fall_animation/src/snow_configuration.dart';

class Snowflake {
  double x;
  double y;
  double velocity;
  double size;
  double alpha;
  double swing;
  double swingValue;
  double rotation;
  int emojiIndex;

  Snowflake({
    required this.x,
    required this.y,
    required this.velocity,
    required this.size,
    required this.alpha,
    required this.swing,
    required this.swingValue,
    required this.rotation,
    required this.emojiIndex,
  });

  void reset(Random random, Size size, List<String> emojis) {
    y = random.nextDouble() * -50 - 50;
    x = random.nextDouble() * size.width;
    // Ensure emoji index is within bounds
    emojiIndex = random.nextInt(emojis.length);
  }

  static Snowflake generate(Size size, Random random, SnowfallConfig config) {
    // Ensure emoji index is within bounds
    int safeEmojiIndex = random.nextInt(config.customEmojis.length);

    return Snowflake(
      x: random.nextDouble() * size.width,
      y: random.nextDouble() * -size.height,
      velocity: 1 + random.nextDouble() * 2,
      size: config.enableRandomSize
          ? config.minSnowflakeSize +
          random.nextDouble() *
              (config.maxSnowflakeSize - config.minSnowflakeSize)
          : config.minSnowflakeSize,
      alpha: config.enableRandomOpacity
          ? config.minOpacity +
          random.nextDouble() * (config.maxOpacity - config.minOpacity)
          : config.maxOpacity,
      swing: 0.2 + random.nextDouble() * config.swingRange,
      swingValue: random.nextDouble() * pi * 2,
      rotation: random.nextDouble() * pi * 2,
      emojiIndex: safeEmojiIndex,
    );
  }
}