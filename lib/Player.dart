import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/src/services/hardware_keyboard.dart';
import 'package:flutter/src/services/keyboard_key.g.dart';
import 'package:flutter_gm/WaterTileComponent.dart';
import 'package:flutter_gm/main.dart';

class Player extends SpriteComponent with KeyboardHandler, HasGameReference<ColonetGame>, CollisionCallbacks {
  late final Image _sprite;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 200;
  Vector2 pos = Vector2.zero();
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
    pos = velocity * dt;
    position += pos;
    super.update(dt);

    if (horDir < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horDir > 0 && scale.x < 0) {
      flipHorizontally();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is WaterTileComponent) {
      position -= pos; // 이전 위치로 되돌림
    }
  }
  
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(32, 32);
    _sprite = game.images.fromCache('player.png');
    priority = 100;
    sprite = Sprite(_sprite);
    anchor = Anchor.center;
    add(CircleHitbox());
  } 
}