import 'dart:math';
import 'package:flutter/material.dart';

class MoodJar extends StatefulWidget {
  final Function? onJarTap;

  const MoodJar({
    super.key,
    this.onJarTap,
  });

  @override
  State<MoodJar> createState() => MoodJarState();
}

class MoodJarState extends State<MoodJar> with TickerProviderStateMixin {
  // Updated emotion mapping with mood levels
  static const Map<String, Map<String, dynamic>> moodData = {
    "awful": {
      "color": Color(0xFFB668D2), // Purple
      "emoji": "😫",
      "keywords": ["worry", "hate"]
    },
    "bad": {
      "color": Color(0xFF6B88E8), // Blue
      "emoji": "😢",
      "keywords": ["sadness", "anger"]
    },
    "neutral": {
      "color": Color(0xFF5ECCE6), // Cyan
      "emoji": "😐",
      "keywords": ["relief", "surprise", "neutral", "boredom"]
    },
    "good": {
      "color": Color(0xFF5ED48C), // Green
      "emoji": "😊",
      "keywords": ["fun", "happiness"]
    },
    "great": {
      "color": Color(0xFFF87D7D), // Red/Pink
      "emoji": "😄",
      "keywords": ["enthusiasm", "love"]
    }
  };

  final List<Emoji> _emojis = [];
  final Random _random = Random();
  late AnimationController _lidController;
  late Animation<double> _lidAnimation;
  late AnimationController _lidSlideController;
  late Animation<Offset> _lidSlideAnimation;
  bool _isAnimating = false;

  // Physics parameters
  final double emojiSize = 36.0;
  final double collisionSize = 36.0;
  final double jarWidth = 200.0;
  final double jarHeight = 300.0;
  final double restitution = 0.3;
  final double gravity = 800.0;
  final double friction = 0.98;
  final double airResistance = 0.995;
  final double rollingResistance = 0.99;
  final double minSettleVelocity = 3.0;

  final Map<Emoji, AnimationController> _emojiControllers = {};

  @override
  void initState() {
    super.initState();

    _lidController = AnimationController(
      duration: const Duration(milliseconds: 200), // Faster lid animation
      vsync: this,
    );

    _lidSlideController = AnimationController(
      duration: const Duration(milliseconds: 200), // Faster lid slide
      vsync: this,
    );

    _lidSlideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.4), // Adjusted for smoother transition
    ).animate(CurvedAnimation(
      parent: _lidSlideController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ));

    _lidAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _lidController,
        curve: Curves.easeInOut,
      ),
    );

    // Add some initial emojis
    _addInitialEmojis();
  }

  void _addInitialEmojis() {
    // Add a few initial emojis
    Future.delayed(const Duration(milliseconds: 500), () {
      final moods = moodData.keys.toList();
      for (int i = 0; i < 4; i++) {
        final mood = moods[_random.nextInt(moods.length)];
        addSpecificEmoji(mood);
      }
    });
  }

  @override
  void dispose() {
    _lidController.dispose();
    _lidSlideController.dispose();
    for (var controller in _emojiControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String detectMood(String text) {
    text = text.toLowerCase();
    for (var mood in moodData.keys) {
      for (var keyword in moodData[mood]!["keywords"]) {
        if (text.contains(keyword)) {
          return mood;
        }
      }
    }
    return "neutral";
  }

  void addMoodFromText(String text) {
    if (_isAnimating) return;

    final mood = detectMood(text);
    addSpecificEmoji(mood);
  }

  // Method to add a specific mood (for testing)
  void addSpecificEmoji(String mood) async {
    if (_isAnimating) return;
    _isAnimating = true;

    try {
      await _lidSlideController.forward();

      // Calculate position relative to the jar, not the screen
      final jarCenterX = jarWidth / 2;
      final randomOffset = (_random.nextDouble() - 0.5) * (jarWidth * 0.5);

      final startPosition = Offset(
        jarCenterX + randomOffset,
        40.0,
      );

      final emojiSymbol = moodData[mood]?["emoji"] as String? ?? "😐";
      final emojiColor = moodData[mood]?["color"] as Color? ?? Colors.grey;

      final newEmoji = Emoji(emojiSymbol, emojiColor, startPosition, mood);

      setState(() {
        _emojis.add(newEmoji);
      });

      _animateEmojiWithPhysics(newEmoji).then((_) {
        if (mounted) _lidSlideController.reverse();
      });
    } catch (e) {
      _lidSlideController.reverse();
    } finally {
      _isAnimating = false;
    }
  }

  bool checkCollision(Offset pos1, Offset pos2) {
    final distance = (pos1 - pos2).distance;
    return distance < collisionSize;
  }

  Future<void> _animateEmojiWithPhysics(Emoji emoji) async {
    final animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(seconds: 5), // Shorter duration for faster settling
    );

    _emojiControllers[emoji] = animationController;

    double velocityY = 0.0;
    double velocityX =
        _random.nextDouble() * 20 - 10; // Reduced initial velocity
    bool hasSettled = false;

    // Define jar boundaries relative to the jar itself, not the screen
    final jarTop = 0.0;
    final jarLeft = 0.0;
    final jarRight = jarWidth - emojiSize;
    final jarBottom = jarHeight - emojiSize;

    animationController.addListener(() {
      if (!mounted || hasSettled) return;

      final dt = 1 / 60;

      velocityY += gravity * dt;
      velocityY *= airResistance;
      velocityX *= airResistance;

      double newX = emoji.position.dx + velocityX * dt;
      double newY = emoji.position.dy + velocityY * dt;

      for (final otherEmoji in _emojis) {
        if (otherEmoji != emoji && otherEmoji.isActive) {
          final dx = newX - otherEmoji.position.dx;
          final dy = newY - otherEmoji.position.dy;
          final distance = sqrt(dx * dx + dy * dy);

          if (distance < collisionSize - 1) {
            final angle = atan2(dy, dx);

            newX = otherEmoji.position.dx + cos(angle) * collisionSize;
            newY = otherEmoji.position.dy + sin(angle) * collisionSize;

            final normalX = cos(angle);
            final normalY = sin(angle);

            final relativeVelocity = velocityX * normalX + velocityY * normalY;
            final bounceVelocity = -relativeVelocity * restitution;

            velocityX += bounceVelocity * normalX;
            velocityY += bounceVelocity * normalY;

            velocityX += _random.nextDouble() * 5 - 2.5;

            velocityX *= 0.95;
            velocityY *= 0.95;
          }
        }
      }

      // Ensure emojis stay within jar boundaries
      if (newX <= jarLeft) {
        newX = jarLeft;
        velocityX = -velocityX * restitution;
      }
      if (newX >= jarRight) {
        newX = jarRight;
        velocityX = -velocityX * restitution;
      }

      if (newY >= jarBottom) {
        newY = jarBottom;
        if (velocityY > 0) {
          velocityY = -velocityY * restitution;
          velocityX *= rollingResistance;
        }
        velocityX *= friction;
      }

      bool hasCollided = false;

      if (newY >= jarBottom) {
        hasCollided = true;
      }

      for (final otherEmoji in _emojis) {
        if (otherEmoji != emoji && otherEmoji.isActive) {
          final dx = newX - otherEmoji.position.dx;
          final dy = newY - otherEmoji.position.dy;
          final distance = sqrt(dx * dx + dy * dy);

          if (distance < collisionSize - 1) {
            hasCollided = true;
            break;
          }
        }
      }

      if (hasCollided) {
        emoji.onCollision?.call();
      }

      if (mounted) {
        setState(() {
          emoji.position = Offset(newX, newY);
          emoji.velocityX = velocityX;
          emoji.velocityY = velocityY;
        });
      }

      final speed = sqrt(velocityX * velocityX + velocityY * velocityY);
      if (newY >= jarBottom - 1 && speed < minSettleVelocity) {
        hasSettled = true;
        emoji.isSettled = true;
      }
    });

    try {
      await animationController.forward();
    } finally {
      if (_emojiControllers[emoji] == animationController) {
        _emojiControllers.remove(emoji);
        animationController.dispose();
      }
    }
  }

  final Gradient jarLidGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE0E0E0), // Light Silver
      Color(0xFFBDBDBD), // Medium Gray
      Color(0xFF9E9E9E), // Darker Gray
      Color(0xFFE0E0E0), // Light Silver
      Color(0xFF757575), // Deep reflection
    ],
    stops: [0.0, 0.3, 0.5, 0.7, 1.0], // Adjust for a metallic look
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onJarTap != null) {
          widget.onJarTap!();
        }
      },
      child: SizedBox(
        height: 350,
        width: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Jar body
            Positioned(
              left: (280 - jarWidth) / 2,
              bottom: 0,
              child: _buildJar(),
            ),

            // Emojis in jar - position them relative to the jar
            ..._emojis.map((emoji) => Positioned(
                  top: emoji.position.dy +
                      50, // Adjusted jarTop offset to remove gap
                  left: emoji.position.dx +
                      (280 - jarWidth) / 2, // Add jarLeft offset
                  child: SizedBox(
                    width: emojiSize,
                    height: emojiSize,
                    child: Center(
                      child: Text(
                        emoji.symbol,
                        style: const TextStyle(
                          fontSize: 32,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                )),

            // Jar lid
            Positioned(
              top: 11, // Increased gap between jar and lid
              left: (280 - jarWidth) / 2,
              child: SlideTransition(
                position: _lidSlideAnimation,
                child: _buildLid(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJar() {
    return Container(
      width: jarWidth,
      height: jarHeight,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(5, 5),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 3,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
    );
  }

  Widget _buildLid() {
    return Container(
      width: jarWidth,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: jarLidGradient, // moved the creation of the gradient outside and made it a final variable for performance
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade900,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}

class Emoji {
  String symbol;
  Color color;
  Offset position;
  String mood;
  double velocityX = 0;
  double velocityY = 0;
  bool isSettled = false;
  bool isActive = true;
  Function? onCollision;

  Emoji(this.symbol, this.color, this.position, this.mood);
}
