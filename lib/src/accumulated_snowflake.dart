// File: lib/snow_fall_animation.dart
/// A Flutter plugin for creating beautiful snow fall animations with customizable
/// effects and emoji support.
///
/// This plugin provides widgets and configurations for adding winter-themed
/// animations to Flutter applications. It supports both regular snowflakes and
/// custom emojis, with features like accumulation, wind effects, and more.
///
/// Example usage:
/// ```dart
/// AccumulatingSnowfall(
///   config: SnowfallConfig(
///     numberOfSnowflakes: 200,
///     speed: 1.0,
///     customEmojis: ['❄️', '❅', '❆'],
///   ),
/// )
/// ```
library snow_fall_animation;

// File: lib/src/snowflake.dart
/// Represents a snowflake that has accumulated at the bottom of the screen.
///
/// This class manages the properties of snowflakes that have finished falling
/// and settled at the bottom of the animation area.
class AccumulatedSnowflake {
  /// Creates a new accumulated snowflake instance.
  ///
  /// The [x] and [y] parameters define the position,
  /// [size] determines the snowflake size,
  /// [emojiIndex] specifies which emoji to use from the configuration,
  /// [rotation] sets the snowflake's rotation angle,
  /// and [alpha] controls the opacity.
  const AccumulatedSnowflake({
    required this.x,
    required this.y,
    required this.size,
    required this.emojiIndex,
    required this.rotation,
    required this.alpha,
  });

  /// The horizontal position of the accumulated snowflake.
  final double x;

  /// The vertical position of the accumulated snowflake.
  final double y;

  /// The size of the accumulated snowflake.
  final double size;

  /// The index of the emoji to use from the configured emoji list.
  ///
  /// This index corresponds to the position in the [SnowfallConfig.customEmojis]
  /// list. It determines which emoji will be displayed for this snowflake.
  final int emojiIndex;

  /// The rotation angle of the accumulated snowflake in radians.
  final double rotation;

  /// The opacity value of the accumulated snowflake.
  ///
  /// Ranges from 0.0 (completely transparent) to 1.0 (fully opaque).
  /// This value is used for fade effects during cleanup animations.
  final double alpha;
}