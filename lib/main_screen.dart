import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'api.dart';
import 'crops.dart';
import 'login_screen.dart';
import 'like_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('农场游戏'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await apiService.logout();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else if (value == 'cheat') {
                await apiService.cheat();
                // Refresh the game state
                (context as Element).reassemble();
              } else if (value == 'like') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LikeScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('登出'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'cheat',
                  child: ListTile(
                    leading: Icon(Icons.bug_report),
                    title: Text('作弊'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'like',
                  child: ListTile(
                    leading: Icon(Icons.thumb_up),
                    title: Text('点赞'),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: GameWidget(
        game: FarmGame(),
      ),
    );
  }
}

class FarmGame extends FlameGame with HasTappables {
  bool _showShop = false;
  bool _showPlant = false;
  late TextComponent _moneyText;
  late TextComponent _experienceText;
  late Sprite _backgroundSprite;

  @override
  Color backgroundColor() => const Color(0xFF000000); // Black background

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _backgroundSprite = await loadSprite('bg.png');

    final double margin = 20.0;
    final double plotSize = size.x / 2 - margin * 1.5;
    final double startX = margin;
    final double startY = size.y / 2 - plotSize - margin / 2;

    _moneyText = TextComponent(
      text: '💰 ${apiService.getMoney()}',
      position: Vector2(size.x - 150, 10),
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
    add(_moneyText);

    _experienceText = TextComponent(
      text: '⭐ ${apiService.getExperience()}',
      position: Vector2(size.x - 150, 40),
      textRenderer: TextPaint(
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
    add(_experienceText);

    add(PlotComponent(
      position: Vector2(startX, startY),
      plotNumber: 1,
      cropState: apiService.getCropState(1),
      size: Vector2(plotSize, plotSize),
    ));
    add(PlotComponent(
      position: Vector2(startX + plotSize + margin, startY),
      plotNumber: 2,
      cropState: apiService.getCropState(2),
      size: Vector2(plotSize, plotSize),
    ));
    add(PlotComponent(
      position: Vector2(startX, startY + plotSize + margin),
      plotNumber: 3,
      cropState: apiService.getCropState(3),
      size: Vector2(plotSize, plotSize),
    ));
    add(PlotComponent(
      position: Vector2(startX + plotSize + margin, startY + plotSize + margin),
      plotNumber: 4,
      cropState: apiService.getCropState(4),
      size: Vector2(plotSize, plotSize),
    ));

    add(ButtonComponent(
      position: Vector2(10, 10),
      size: Vector2(100, 50),
      text: '商店',
      onPressed: () {
        _showShop = !_showShop;
        overlays.add('shop');
      },
    ));

    add(ButtonComponent(
      position: Vector2(120, 10),
      size: Vector2(100, 50),
      text: '状态',
      onPressed: () {
        // Navigate to Warehouse
      },
    ));

    add(ButtonComponent(
      position: Vector2(10, size.y - 60),
      size: Vector2(100, 50),
      text: '种植',
      onPressed: () {
        _showPlant = !_showPlant;
        overlays.add('plant');
      },
    ));

    add(ButtonComponent(
      position: Vector2(120, size.y - 60),
      size: Vector2(100, 50),
      text: '收获',
      onPressed: () async {
        await apiService.harvestCrops();
        _moneyText.text = '💰 ${apiService.getMoney()}';
        _experienceText.text = '⭐ ${apiService.getExperience()}';

        for (final component in children) {
          if (component is PlotComponent) {
            component.cropState = apiService.getCropState(component.plotNumber);
          }
        }
      },
    ));
  }

  @override
  void render(Canvas canvas) {

    // Draw the repeating background
    final bgSize = _backgroundSprite.srcSize;
    for (double x = 0; x < size.x; x += bgSize.x) {
      for (double y = 0; y < size.y; y += bgSize.y) {
        _backgroundSprite.render(
          canvas,
          position: Vector2(x, y),
          size: bgSize,
        );
      }
    }
    super.render(canvas);

    if (_showShop) {
      renderShop(canvas);
    }
    if (_showPlant) {
      renderPlant(canvas);
    }

    _moneyText.position = Vector2(size.x - 150, 10);
    _experienceText.position = Vector2(size.x - 150, 40);
  }

  void renderShop(Canvas canvas) {
    final seeds = apiService.getSeeds();
    late Color color;
    if (kIsWeb) {
      color = const Color(0xFF000000);
    } else {
      color = const Color(0xFF000000).withOpacity(0.8);
    }
    final paint = Paint()..color = color; // Solid black color
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: '商店',
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.x / 2 - textPainter.width / 2, 20));

    final moneyPainter = TextPainter(
      text: TextSpan(
        text: '💰 ${apiService.getMoney()}',
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    );
    moneyPainter.layout();
    moneyPainter.paint(canvas, Offset(10, 20));

    final closePainter = TextPainter(
      text: const TextSpan(
        text: '❌',
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
      textDirection: TextDirection.ltr,
    );
    closePainter.layout();
    closePainter.paint(canvas, Offset(size.x - 40, 20));

    for (int i = 0; i < crops.length; i++) {
      final crop = crops[i];
      final x = (i % 3) * 100 + 50;
      final y = (i ~/ 3) * 100 + 100;

      final emojiPainter = TextPainter(
        text: TextSpan(
          text: crop.fruitEmoji,
          style: const TextStyle(fontSize: 30, fontFamily: 'EmojiOne', shadows: [
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ]),
        ),
        textDirection: TextDirection.ltr,
      );
      emojiPainter.layout();
      emojiPainter.paint(canvas, Offset(x.toDouble(), y.toDouble()));

      final seedsPainter = TextPainter(
        text: TextSpan(
          text: '种子: ${seeds[crop.level] ?? 0}',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      );
      seedsPainter.layout();
      seedsPainter.paint(canvas, Offset(x.toDouble(), y.toDouble() + 40));

      final pricePainter = TextPainter(
        text: TextSpan(
          text: '价格: ${crop.seedPrice}',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      );
      pricePainter.layout();
      pricePainter.paint(canvas, Offset(x.toDouble(), y.toDouble() + 60));
    }
  }

  void renderPlant(Canvas canvas) {
    final seeds = apiService.getSeeds();
    late Color color;
    if (kIsWeb) {
      color = const Color(0xFF000000);
    } else {
      color = const Color(0xFF000000).withOpacity(0.8);
    }
    final paint = Paint()..color = color; // Solid black color
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), paint);

    final textPainter = TextPainter(
      text: const TextSpan(
        text: '种植',
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(size.x / 2 - textPainter.width / 2, 20));

    final closePainter = TextPainter(
      text: const TextSpan(
        text: '❌',
        style: TextStyle(color: Colors.white, fontSize: 30),
      ),
      textDirection: TextDirection.ltr,
    );
    closePainter.layout();
    closePainter.paint(canvas, Offset(size.x - 40, 20));

    for (int i = 0; i < crops.length; i++) {
      final crop = crops[i];
      final x = (i % 3) * 100 + 50;
      final y = (i ~/ 3) * 100 + 100;

      final emojiPainter = TextPainter(
        text: TextSpan(
          text: crop.fruitEmoji,
          style: const TextStyle(fontSize: 30, fontFamily: 'EmojiOne', shadows: [
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ]),
        ),
        textDirection: TextDirection.ltr,
      );
      emojiPainter.layout();
      emojiPainter.paint(canvas, Offset(x.toDouble(), y.toDouble()));

      final seedsPainter = TextPainter(
        text: TextSpan(
          text: '种子: ${seeds[crop.level] ?? 0}',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
      );
      seedsPainter.layout();
      seedsPainter.paint(canvas, Offset(x.toDouble(), y.toDouble() + 40));
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo event) {
    final tapPosition = event.eventPosition.game;

    if (_showShop) {
      if (tapPosition.x > size.x - 40 && tapPosition.y < 60) {
        _showShop = false;
        overlays.remove('shop');
        return;
      }

      for (int i = 0; i < crops.length; i++) {
        final x = (i % 3) * 100 + 50;
        final y = (i ~/ 3) * 100 + 100;
        if (tapPosition.x > x && tapPosition.x < x + 100 && tapPosition.y > y && tapPosition.y < y + 100) {
          apiService.buySeed(crops[i].level, crops[i].seedPrice);
          _moneyText.text = '💰 ${apiService.getMoney()}';
          return;
        }
      }
    }

    if (_showPlant) {
      if (tapPosition.x > size.x - 40 && tapPosition.y < 60) {
        _showPlant = false;
        overlays.remove('plant');
        return;
      }

      for (int i = 0; i < crops.length; i++) {
        final x = (i % 3) * 100 + 50;
        final y = (i ~/ 3) * 100 + 100;
        if (tapPosition.x > x && tapPosition.x < x + 100 && tapPosition.y > y && tapPosition.y < y + 100) {
          final seeds = apiService.getSeeds();
          if ((seeds[crops[i].level] ?? 0) > 0) {
            for (final component in children) {
              if (component is PlotComponent && component.cropState == null) {
                apiService.plantCrop(component.plotNumber, crops[i].level, DateTime.now());
                component.cropState = apiService.getCropState(component.plotNumber);
                seeds[crops[i].level] = seeds[crops[i].level]! - 1;
                apiService.setSeeds(seeds);
                break;
              }
            }
          }
          return;
        }
      }
    }

    super.onTapDown(pointerId, event);
  }
}

class PlotComponent extends PositionComponent {
  final int plotNumber;
  Map<String, dynamic>? cropState;

  PlotComponent({
    required Vector2 position,
    required this.plotNumber,
    this.cropState,
    required Vector2 size,
  }) {
    this.position = position;
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color(0xFF8B4513); // Dark brown color
    final rrect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10));
    canvas.drawRRect(rrect, paint);

    if (cropState != null) {
      final cropId = cropState!['cropId'];
      final plantTime = DateTime.parse(cropState!['plantTime']);
      final crop = crops.firstWhere((crop) => crop.level == cropId);
      final elapsedTime = DateTime.now().difference(plantTime);

      String emoji;
      if (elapsedTime.inHours >= crop.stepHours[2]
      + crop.stepHours[1] + crop.stepHours[0]) { 
        emoji = crop.fruitEmoji;
      }
      else if (elapsedTime.inHours >= crop.stepHours[2] + crop.stepHours[1]) {
        emoji = crop.stepEmojis[2];
      }
      else if (elapsedTime.inMinutes >= crop.stepHours[2]) {
        emoji = crop.stepEmojis[1];
      }
       else {
        emoji = crop.stepEmojis[0];
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: emoji,
          style: const TextStyle(fontSize: 30, fontFamily: 'EmojiOne', shadows: [
            Shadow(
              offset: Offset(2.0, 2.0),
              blurRadius: 3.0,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ]),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          size.x / 2 - textPainter.width / 2,
          size.y / 2 - textPainter.height / 2,
        ),
      );

      var allHours = crop.stepHours[2] + crop.stepHours[1] + crop.stepHours[0];
      var leftHours = allHours - elapsedTime.inHours;

      if (leftHours > 0) {
        final timeText = '$leftHours 小时';

        final timePainter = TextPainter(
          text: TextSpan(
            text: timeText,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          textDirection: TextDirection.ltr,
        );
        timePainter.layout();
        timePainter.paint(
          canvas,
          Offset(
            size.x - timePainter.width - 5,
            size.y - timePainter.height - 5,
          ),
        );
      }
    }
  }
}

class ButtonComponent extends PositionComponent with Tappable {
  final String text;
  final VoidCallback onPressed;

  ButtonComponent({
    required Vector2 position,
    required Vector2 size,
    required this.text,
    required this.onPressed,
  }) {
    this.position = position;
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color(0xFF0000FF); // Blue color
    final rrect = RRect.fromRectAndRadius(size.toRect(), const Radius.circular(10));
    canvas.drawRRect(rrect, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.x / 2 - textPainter.width / 2,
        size.y / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool onTapDown(TapDownInfo event) {
    onPressed();
    return true;
  }
}
