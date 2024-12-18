import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter_gm/main.dart';

class TileComponent extends SpriteComponent with HasGameReference<ColonetGame> {
  TileComponent.init(Vector2 pos) {
    position = pos;
    size = Vector2(32, 32);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final image = game.images.fromCache('water.png');
    sprite = Sprite(image);
  }

  @override void render(Canvas canvas) {
    super.render(canvas);
  }
}