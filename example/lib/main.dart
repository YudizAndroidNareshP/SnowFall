// File: lib/example/main.dart
import 'package:flutter/material.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snow Fall Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: const SnowFallDemo(),
    );
  }
}

class SnowFallDemo extends StatefulWidget {
  const SnowFallDemo({super.key});

  @override
  State<SnowFallDemo> createState() => _SnowFallDemoState();
}

class _SnowFallDemoState extends State<SnowFallDemo> {
  late SnowfallConfig _config;
  String _currentPreset = 'Default Snow';

  @override
  void initState() {
    super.initState();
    _config = presets['Default Snow']!;
  }

  final Map<String, SnowfallConfig> presets = {
    'Default Snow': const SnowfallConfig(
      customEmojis: ['❄️', '❅', '❆'],
    ),
    'Christmas Magic': const SnowfallConfig(
      numberOfSnowflakes: 200,
      speed: 1.0,
      customEmojis: ['❄️', '🎅', '🎄', '🎁', '⭐'],
      windForce: 0.5,
    ),
    'Winter Wonderland': const SnowfallConfig(
      numberOfSnowflakes: 250,
      speed: 1.2,
      customEmojis: ['❄️', '⛄', '🦌', '✨', '⭐'],
      windForce: 1.0,
    ),
    'Santa\'s Workshop': const SnowfallConfig(
      numberOfSnowflakes: 150,
      speed: 0.8,
      customEmojis: ['🎁', '🧦', '🍪', '🔔', '✨'],
      windForce: 0.3,
    ),
    'Cozy Christmas': const SnowfallConfig(
      numberOfSnowflakes: 120,
      speed: 0.5,
      customEmojis: ['❄️', '🕯️', '🧦', '🍪', '🥛'],
      windForce: 0.2,
    ),
  };

  final Map<String, List<String>> emojiGroups = {
    'Snow': ['❄️', '❅', '❆', '✻', '✼'],
    'Santa': ['🎅', '🤶', '🦌', '🛷', '🎁'],
    'Decorations': ['🎄', '⭐', '🔔', '🧦', '🕯️'],
    'Winter': ['⛄', '🧣', '🧤', '🎿', '🦭'],
    'Treats': ['🍪', '🥛', '🍷'],
  };

  void _showCustomizeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.grey[900]!.withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: CustomizationPanel(
            controller: scrollController,
            config: _config,
            emojiGroups: emojiGroups,
            onConfigChanged: (newConfig) {
              setState(() {
                _config = newConfig;
                _currentPreset = 'Custom';
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[900]!,
                  Colors.blue[700]!,
                ],
              ),
            ),
          ),

          // Snow animation
          SnowFallAnimation(config: _config),

          // Top bar with preset selector
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Card(
                margin: const EdgeInsets.all(8),
                color: Colors.black45,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton<String>(
                    value: _currentPreset,
                    dropdownColor: Colors.black87,
                    items: [...presets.keys, 'Custom'].map((String preset) {
                      return DropdownMenuItem<String>(
                        value: preset,
                        child: Text(preset),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null && newValue != 'Custom') {
                        setState(() {
                          _currentPreset = newValue;
                          _config = presets[newValue]!;
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCustomizeBottomSheet,
        child: const Icon(Icons.tune),
        tooltip: 'Customize',
      ),
    );
  }
}

class CustomizationPanel extends StatefulWidget {
  final ScrollController controller;
  final SnowfallConfig config;
  final Map<String, List<String>> emojiGroups;
  final Function(SnowfallConfig) onConfigChanged;

  const CustomizationPanel({
    Key? key,
    required this.controller,
    required this.config,
    required this.emojiGroups,
    required this.onConfigChanged,
  }) : super(key: key);

  @override
  State<CustomizationPanel> createState() => _CustomizationPanelState();
}

class _CustomizationPanelState extends State<CustomizationPanel> {
  late SnowfallConfig _currentConfig;

  @override
  void initState() {
    super.initState();
    _currentConfig = widget.config;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.controller,
      padding: const EdgeInsets.all(16),
      children: [
        // Handle bar
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        const Text(
          'Customize Snow Fall',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Number of snowflakes
        Text('Snowflakes: ${_currentConfig.numberOfSnowflakes}'),
        Slider(
          value: _currentConfig.numberOfSnowflakes.toDouble(),
          min: 50,
          max: 500,
          divisions: 45,
          label: _currentConfig.numberOfSnowflakes.toString(),
          onChanged: (value) {
            setState(() {
              _currentConfig = SnowfallConfig(
                numberOfSnowflakes: value.toInt(),
                speed: _currentConfig.speed,
                windForce: _currentConfig.windForce,
                customEmojis: _currentConfig.customEmojis,
                holdSnowAtBottom: _currentConfig.holdSnowAtBottom,
              );
              widget.onConfigChanged(_currentConfig);
            });
          },
        ),

        // Speed control
        Text('Speed: ${_currentConfig.speed.toStringAsFixed(1)}'),
        Slider(
          value: _currentConfig.speed,
          min: 0.1,
          max: 3.0,
          divisions: 29,
          label: _currentConfig.speed.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _currentConfig = SnowfallConfig(
                numberOfSnowflakes: _currentConfig.numberOfSnowflakes,
                speed: value,
                windForce: _currentConfig.windForce,
                customEmojis: _currentConfig.customEmojis,
                holdSnowAtBottom: _currentConfig.holdSnowAtBottom,
              );
              widget.onConfigChanged(_currentConfig);
            });
          },
        ),

        // Wind force
        Text('Wind: ${_currentConfig.windForce.toStringAsFixed(1)}'),
        Slider(
          value: _currentConfig.windForce,
          min: -2.0,
          max: 2.0,
          divisions: 40,
          label: _currentConfig.windForce.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _currentConfig = SnowfallConfig(
                numberOfSnowflakes: _currentConfig.numberOfSnowflakes,
                speed: _currentConfig.speed,
                windForce: value,
                customEmojis: _currentConfig.customEmojis,
                holdSnowAtBottom: _currentConfig.holdSnowAtBottom,
              );
              widget.onConfigChanged(_currentConfig);
            });
          },
        ),

        // Snow accumulation toggle
        SwitchListTile(
          title: const Text('Accumulate Snow'),
          value: _currentConfig.holdSnowAtBottom,
          onChanged: (bool value) {
            setState(() {
              _currentConfig = SnowfallConfig(
                numberOfSnowflakes: _currentConfig.numberOfSnowflakes,
                speed: _currentConfig.speed,
                windForce: _currentConfig.windForce,
                customEmojis: _currentConfig.customEmojis,
                holdSnowAtBottom: value,
              );
              widget.onConfigChanged(_currentConfig);
            });
          },
        ),

        // Emoji groups
        const Text('Select Emojis:', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        ...widget.emojiGroups.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key, style: const TextStyle(color: Colors.grey)),
              Wrap(
                spacing: 8,
                children: entry.value.map((emoji) {
                  final isSelected =
                      _currentConfig.customEmojis.contains(emoji);
                  return FilterChip(
                    label: Text(emoji),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        List<String> newEmojis =
                            List.from(_currentConfig.customEmojis);
                        if (selected) {
                          newEmojis.add(emoji);
                        } else {
                          newEmojis.remove(emoji);
                        }
                        if (newEmojis.isNotEmpty) {
                          _currentConfig = SnowfallConfig(
                            numberOfSnowflakes:
                                _currentConfig.numberOfSnowflakes,
                            speed: _currentConfig.speed,
                            windForce: _currentConfig.windForce,
                            customEmojis: newEmojis,
                            holdSnowAtBottom: _currentConfig.holdSnowAtBottom,
                          );
                          widget.onConfigChanged(_currentConfig);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ],
    );
  }
}
