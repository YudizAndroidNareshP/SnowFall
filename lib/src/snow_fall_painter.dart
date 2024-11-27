import 'package:flutter/material.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';
import 'package:snow_fall_animation/src/accumulated_snowflake.dart';

class SnowPainter extends CustomPainter {
  final List<Snowflake> fallingSnow;
  final List<AccumulatedSnowflake> oldAccumulatedSnow;
  final List<AccumulatedSnowflake> newAccumulatedSnow;
  final SnowfallConfig config;
  final double cleanupProgress;
  final bool isCleaningUp;

  SnowPainter({
    required this.fallingSnow,
    required this.oldAccumulatedSnow,
    required this.newAccumulatedSnow,
    required this.config,
    required this.cleanupProgress,
    required this.isCleaningUp,
  });

  String _getEmoji(int index) {
    // Safely get emoji with bounds checking
    return config.customEmojis[index % config.customEmojis.length];
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw accumulated snow
    if (config.holdSnowAtBottom) {
      // Draw old accumulated snow (fading out)
      if (isCleaningUp) {
        for (var snow in oldAccumulatedSnow) {
          if (config.useEmoji) {
            _drawEmoji(
              canvas,
              snow.x,
              snow.y,
              snow.size,
              _getEmoji(snow.emojiIndex),
              snow.alpha * (1 - cleanupProgress),
              snow.rotation,
            );
          } else {
            final paint = Paint()
              ..color = config.snowColor
                  .withOpacity(snow.alpha * (1 - cleanupProgress))
              ..style = PaintingStyle.fill;

            canvas.drawCircle(
              Offset(snow.x, snow.y),
              snow.size,
              paint,
            );
          }
        }
      }

      // Draw new accumulated snow
      for (var snow in newAccumulatedSnow) {
        if (config.useEmoji) {
          _drawEmoji(
            canvas,
            snow.x,
            snow.y,
            snow.size,
            _getEmoji(snow.emojiIndex),
            snow.alpha,
            snow.rotation,
          );
        } else {
          final paint = Paint()
            ..color = config.snowColor.withOpacity(snow.alpha)
            ..style = PaintingStyle.fill;

          canvas.drawCircle(
            Offset(snow.x, snow.y),
            snow.size,
            paint,
          );
        }
      }
    }

    // Draw falling snow
    for (var snowflake in fallingSnow) {
      if (config.useEmoji) {
        _drawEmoji(
          canvas,
          snowflake.x,
          snowflake.y,
          snowflake.size,
          _getEmoji(snowflake.emojiIndex),
          snowflake.alpha,
          snowflake.rotation,
        );
      } else {
        final paint = Paint()
          ..color = config.snowColor.withOpacity(snowflake.alpha)
          ..style = PaintingStyle.fill;

        canvas.drawCircle(
          Offset(snowflake.x, snowflake.y),
          snowflake.size,
          paint,
        );
      }
    }
  }

  void _drawEmoji(
    Canvas canvas,
    double x,
    double y,
    double size,
    String emoji,
    double opacity,
    double rotation,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: emoji,
        style: TextStyle(
          fontSize: size * 2,
          color: config.snowColor.withOpacity(opacity),
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation);
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(SnowPainter oldDelegate) => true;
}
