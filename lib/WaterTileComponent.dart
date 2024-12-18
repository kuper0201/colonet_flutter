import 'dart:async';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter_gm/Player.dart';
import 'package:flutter_gm/main.dart';

class WaterTileComponent extends SpriteComponent with HasGameReference<ColonetGame>, CollisionCallbacks {
  WaterTileComponent.init(Vector2 pos) {
    position = pos;
    size = Vector2(32, 32);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final image = game.images.fromCache('water.png');
    sprite = Sprite(image);
    add(RectangleHitbox());
  }

  @override void render(Canvas canvas) {
    super.render(canvas);
  }
}