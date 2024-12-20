import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gm/Player.dart';
import 'package:flutter_gm/GrassTileComponent.dart';
import 'package:flutter_gm/WaterTileComponent.dart';

void main() {
  runApp(GameWidget(game: ColonetGame()));
}

class ColonetGame extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late final Player _player;
  final Map<String, SpriteComponent> visibleTiles = {}; // 보이는 타일 캐싱
  final int tileSize = 32; // 타일 크기 상수

  List<List<int>> map = [];

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAll(['player.png', 'grass.png', 'water.png']);
    _player = Player();

    world.add(_player);
    camera.viewfinder.anchor = Anchor.center;
    camera.viewport = FixedResolutionViewport(resolution: Vector2(1920, 1080));
    camera.follow(_player);

    for(int i = 0; i < 1000; i++) {
      map.add([]);
      for(int j = 0; j < 1000; j++) {
        if(i == 0 || i == 999 || j == 0 || j == 999) {
          map[i].add(1);
          continue;
        }
        final randInt = Random().nextInt(100);
        if(randInt <= 90) {
          map[i].add(0);
        } else {
          map[i].add(1);
        }
      }
    }

    _updateVisibleTiles(); // 초기 타일 생성
  }

  void _updateVisibleTiles() {
    final int playerX = (_player.position.x / tileSize).floor();
    final int playerY = (_player.position.y / tileSize).floor();

    final Set<String> newVisibleKeys = {}; // 새로 보이는 타일들의 키 저장
    for (int i = -30; i <= 30; i++) {
      for (int j = -17; j <= 17; j++) {
        final int tileX = playerX + i;
        final int tileY = playerY + j;

        final String key = '$tileX-$tileY'; // 타일의 유니크 키
        newVisibleKeys.add(key);

        if (!visibleTiles.containsKey(key)) {
          final Vector2 tilePosition = Vector2(tileX * tileSize.toDouble(), tileY * tileSize.toDouble());
          final randInt = Random().nextInt(100);
          if(tileX + 300 < 0 || tileX + 300 >= 1000 || tileY + 300 < 0 || tileY + 300 >= 1000) {
            continue;
          }
          
          if(map[tileX + 300][tileY + 300] == 0) {
            final tile = GrassTileComponent.init(tilePosition);
            world.add(tile);
            visibleTiles[key] = tile; // 타일을 캐싱에 추가
          } else {
            final tile = WaterTileComponent.init(tilePosition);
            world.add(tile);
            visibleTiles[key] = tile; // 타일을 캐싱에 추가
          }
          
        }
      }
    }
    
    final keysToRemove = visibleTiles.keys.where((key) => !newVisibleKeys.contains(key)).toList();
    for(final key in keysToRemove) {
      world.remove(visibleTiles[key]!);
      visibleTiles.remove(key);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateVisibleTiles();
  }
}
