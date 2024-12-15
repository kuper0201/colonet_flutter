import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_gm/main.dart';

class TileComponent extends SpriteComponent with HasGameReference<Game> {
  TileComponent.init(Vector2 pos) {
    position = pos;
    size = Vector2(32, 32);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final image = await Flame.images.load('tile.png');
    sprite = Sprite(image);
  }
}