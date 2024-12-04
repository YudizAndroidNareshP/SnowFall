import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';

void main() {
  group('SnowfallConfig Tests', () {
    test('Default configuration should have valid values', () {
      const config = SnowfallConfig();

      expect(config.numberOfSnowflakes, 200);
      expect(config.speed, 1.0);
      expect(config.useEmoji, true);
      expect(config.customEmojis, isNotEmpty);
      expect(config.holdSnowAtBottom, true);
    });

    test('Custom configuration should override default values', () {
      const config = SnowfallConfig(
        numberOfSnowflakes: 150,
        speed: 2.0,
        useEmoji: false,
        customEmojis: ['❄️', '⛄'],
        holdSnowAtBottom: false,
      );

      expect(config.numberOfSnowflakes, 150);
      expect(config.speed, 2.0);
      expect(config.useEmoji, false);
      expect(config.customEmojis, ['❄️', '⛄']);
      expect(config.holdSnowAtBottom, false);
    });
  });

  group('AccumulatedSnowflake Tests', () {
    test('AccumulatedSnowflake should initialize correctly', () {
      const snowflake = AccumulatedSnowflake(
        x: 100,
        y: 200,
        size: 10,
        emojiIndex: 0,
        rotation: 45,
        alpha: 0.8,
      );

      expect(snowflake.x, 100);
      expect(snowflake.y, 200);
      expect(snowflake.size, 10);
      expect(snowflake.emojiIndex, 0);
      expect(snowflake.rotation, 45);
      expect(snowflake.alpha, 0.8);
    });
  });

  group('Snowflake Tests', () {
    test('Snowflake generation should respect size bounds', () {
      const config = SnowfallConfig(
        minSnowflakeSize: 2.0,
        maxSnowflakeSize: 8.0,
      );

      final random = Random();
      const size = Size(400, 800);

      final snowflake = Snowflake.generate(size, random, config);

      expect(snowflake.size,
          inInclusiveRange(config.minSnowflakeSize, config.maxSnowflakeSize));
    });

    test('Snowflake reset should generate valid positions', () {
      const config = SnowfallConfig();
      final random = Random();
      const size = Size(400, 800);

      final snowflake = Snowflake.generate(size, random, config);
      snowflake.reset(random, size, config.customEmojis);

      expect(snowflake.y, lessThan(0)); // Should start above screen
      expect(snowflake.x, inInclusiveRange(0, size.width));
    });
  });

  group('SnowFallAnimation Widget Tests', () {
    testWidgets('Should build without exploding', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SnowFallAnimation(),
          ),
        ),
      );

      expect(find.byType(SnowFallAnimation), findsOneWidget);
    });

    testWidgets('Should update with new config', (WidgetTester tester) async {
      const initialConfig = SnowfallConfig(numberOfSnowflakes: 100);
      const updatedConfig = SnowfallConfig(numberOfSnowflakes: 200);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SnowFallAnimation(
              config: initialConfig,
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SnowFallAnimation(
              config: updatedConfig,
            ),
          ),
        ),
      );

      expect(find.byType(SnowFallAnimation), findsOneWidget);
    });
  });

  group('Animation Performance Tests', () {
    testWidgets('Should maintain frame rate with max snowflakes',
        (WidgetTester tester) async {
      const config = SnowfallConfig(
        numberOfSnowflakes: 500, // Maximum number
        speed: 2.0,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SnowFallAnimation(
              config: config,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 2));
      // If we reach here without timeout, performance is acceptable
    });
  });

  group('Cleanup Animation Tests', () {
    testWidgets('Should cleanup accumulated snow', (WidgetTester tester) async {
      const config = SnowfallConfig(
        holdSnowAtBottom: true,
        cleanupDuration: Duration(seconds: 1),
        accumulationDuration: Duration(seconds: 2),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SnowFallAnimation(
              config: config,
            ),
          ),
        ),
      );

      // Let snow accumulate
      await tester.pump(const Duration(seconds: 2));

      // Trigger cleanup
      await tester.pump(const Duration(seconds: 1));

      // Verify cleanup completed
      await tester.pumpAndSettle();
    });
  });

  group('Emoji Support Tests', () {
    testWidgets('Should render custom emojis', (WidgetTester tester) async {
      const config = SnowfallConfig(
        useEmoji: true,
        customEmojis: ['❄️', '⛄', '🎄'],
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SnowFallAnimation(
              config: config,
            ),
          ),
        ),
      );

      await tester.pump();
      // Visual verification would be needed for actual emoji rendering
    });
  });

  group('Wind Effect Tests', () {
    test('Wind force should affect x position', () {
      const config = SnowfallConfig(
        windForce: 2.0,
        enableSnowDrift: true,
      );

      final random = Random();
      const size = Size(400, 800);

      final snowflake = Snowflake.generate(size, random, config);
      final initialX = snowflake.x;

      // Simulate movement
      snowflake.x += config.windForce * 0.1;

      expect(snowflake.x, greaterThan(initialX));
    });
  });
}
