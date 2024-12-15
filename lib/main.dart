import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gm/Player.dart';
import 'package:flutter_gm/TileComponent.dart';

void main() {
  runApp(GameWidget(game: Game()));
}

class Game extends FlameGame with HasKeyboardHandlerComponents {
  late final Player _player;

  @override
  void onMount() {
    super.onMount();
  }
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _player = Player();

    for(int i = 0; i < 100; i++) {
      for(int j = 0; j < 100; j++) {
        world.add(TileComponent.init(Vector2(i * 32, j * 32)));
      }
    }

    world.add(_player);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera.setBounds(Rectangle.fromLTRB(size.x / 2, size.y / 2, 100 * 32 - size.x / 2, 100 * 32 - size.y / 2));
    
  }
}