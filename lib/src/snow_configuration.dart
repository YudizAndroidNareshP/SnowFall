import 'package:flutter/material.dart';

/// Configuration class for customizing the snow fall animation.
///
/// This class holds all customizable properties for the snow animation,
/// allowing fine-grained control over the appearance and behavior of the
/// snow effect.
///
/// Example:
/// ```dart
/// SnowfallConfig(
///   numberOfSnowflakes: 200,
///   speed: 1.0,
///   useEmoji: true,
///   customEmojis: ['❄️', '❅', '❆'],
///   holdSnowAtBottom: true,
/// )
/// ```
class SnowfallConfig {
  /// Creates a configuration for snow fall animation.
  ///
  /// All parameters are optional and will use default values if not specified.
  const SnowfallConfig({
    this.numberOfSnowflakes = 200,
    this.speed = 1.0,
    this.useEmoji = true,
    this.customEmojis = const ['❄️', '❅', '❆'],
    this.snowColor = Colors.white,
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

  /// The number of snowflakes to display.
  ///
  /// This controls the density of the snow fall effect.
  /// Recommended range is 50-500 for optimal performance.
  final int numberOfSnowflakes;

  /// The base speed of the snow fall animation.
  ///
  /// Values greater than 1.0 increase speed, less than 1.0 decrease it.
  /// Default is 1.0.
  final double speed;

  /// Whether to use emoji characters for snowflakes.
  ///
  /// When true, uses emojis from [customEmojis].
  /// When false, uses basic shapes.
  final bool useEmoji;

  /// List of emoji characters to use as snowflakes.
  ///
  /// Only used when [useEmoji] is true.
  /// Default includes basic snow-themed emojis.
  final List<String> customEmojis;

  /// The color of snowflakes when not using emojis.
  ///
  /// Only used when [useEmoji] is false.
  final Color snowColor;

  /// Whether snow should accumulate at the bottom.
  ///
  /// When true, snowflakes will pile up at the bottom of the container.
  /// When false, they will disappear upon reaching the bottom.
  final bool holdSnowAtBottom;

  /// Duration for the cleanup animation of accumulated snow.
  ///
  /// Only applicable when [holdSnowAtBottom] is true.
  final Duration cleanupDuration;

  /// Time between snow accumulation cleanup cycles.
  ///
  /// Only applicable when [holdSnowAtBottom] is true.
  final Duration accumulationDuration;

  /// Minimum size of individual snowflakes.
  ///
  /// Must be less than [maxSnowflakeSize].
  final double minSnowflakeSize;

  /// Maximum size of individual snowflakes.
  ///
  /// Must be greater than [minSnowflakeSize].
  final double maxSnowflakeSize;

  /// Range of horizontal swinging motion.
  ///
  /// Higher values create more pronounced swinging.
  final double swingRange;

  /// Speed of snowflake rotation.
  ///
  /// Only applicable when using emojis.
  final double rotationSpeed;

  /// Maximum height of accumulated snow.
  ///
  /// Only applicable when [holdSnowAtBottom] is true.
  final double maxSnowHeight;

  /// Whether to enable horizontal drifting motion.
  final bool enableSnowDrift;

  /// Strength and direction of wind effect.
  ///
  /// Positive values blow right, negative values blow left.
  /// Range: -2.0 to 2.0
  final double windForce;

  /// Whether to randomize snowflake sizes.
  ///
  /// When true, sizes will vary between [minSnowflakeSize] and [maxSnowflakeSize].
  final bool enableRandomSize;

  /// Whether to randomize snowflake opacity.
  final bool enableRandomOpacity;

  /// Minimum opacity value for snowflakes.
  ///
  /// Only used when [enableRandomOpacity] is true.
  final double minOpacity;

  /// Maximum opacity value for snowflakes.
  ///
  /// Only used when [enableRandomOpacity] is true.
  final double maxOpacity;
}
