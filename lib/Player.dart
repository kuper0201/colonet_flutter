import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter_gm/main.dart';

class Player extends SpriteComponent with KeyboardHandler, HasGameReference<Game> {
  late final Image _sprite;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  int horDir = 0;
  int verDir = 0;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horDir = 0;
    horDir += (keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft)) ? -1 : 0;
    horDir += (keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight)) ? 1 : 0;

    verDir = 0;
    verDir += (keysPressed.contains(LogicalKeyboardKey.keyW) || keysPressed.contains(LogicalKeyboardKey.arrowUp)) ? -1 : 0;
    verDir += (keysPressed.contains(LogicalKeyboardKey.keyS) || keysPressed.contains(LogicalKeyboardKey.arrowDown)) ? 1 : 0;

    return true;
  }

  @override
  void update(double dt) {
    velocity.x = horDir * moveSpeed;
    velocity.y = verDir * moveSpeed;
    position += velocity * dt;
    super.update(dt);

    if (horDir < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horDir > 0 && scale.x < 0) {
      flipHorizontally();
    }
  }
  
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    _sprite = await game.images.fromCache('player.png');
    priority = 100;
    sprite = Sprite(_sprite);
    anchor = Anchor.center;
  } 
}