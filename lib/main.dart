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
  final Map<String, TileComponent> visibleTiles = {}; // 보이는 타일 캐싱

  @override
  void onMount() {
    super.onMount();
  }

  void _updateVisibleTiles() {
    // 카메라 위치와 뷰포트 크기 가져오기
    final int tileSize = 32;
    final cameraX = camera.viewfinder.position.x;
    final cameraY = camera.viewfinder.position.y;

    final viewportWidth = size.x;
    final viewportHeight = size.y;
    final mapWidth = 10000;
    final mapHeight = 10000;
    final tilesize = 32;

    // 보이는 타일 인덱스 계산
    int playerX = (_player.position.x / tileSize).floor();
    int playerY = (_player.position.y / tileSize).floor();

    for(int i = -5; i < 5; i++) {
      for(int j = -5; j < 5; j++) {
          double x1 = (playerX + i) * tileSize.toDouble();
          double y1 = (playerY + j) * tileSize.toDouble();
          final tilePosition = Vector2(x1, y1);

          final tile = TileComponent.init(tilePosition);

          add(tile); // Flame 게임에 타일 추가
      }
    }
    // int startTileX = (cameraX / tileSize).floor();
    // int startTileY = (cameraY / tileSize).floor();
    // int endTileX = ((cameraX + viewportWidth) / tileSize).ceil();
    // int endTileY = ((cameraY + viewportHeight) / tileSize).ceil();

    // // 기존 보이는 타일 초기화
    // visibleTiles.clear();

    // // 보이는 타일만 추가
    // for (int x = startTileX; x <= endTileX; x++) {
    //   for (int y = startTileY; y <= endTileY; y++) {
    //     if (x < -mapWidth || x >= mapWidth || y < -mapHeight || y >= mapHeight) continue;

    //     // 타일의 고유 키 (캐싱용)
    //     final tileKey = '$x-$y';

    //     // 타일 생성 및 추가
    //     if (!visibleTiles.containsKey(tileKey)) {
    //       double x1 = x * tileSize.toDouble();
    //       double y1 = y * tileSize.toDouble();
    //       final tilePosition = Vector2(x1, y1);

    //       final tile = TileComponent.init(tilePosition);

    //       add(tile); // Flame 게임에 타일 추가
    //       visibleTiles[tileKey] = tile;
    //     }
    //   }
    // }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateVisibleTiles();
  }
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAll(['player.png', 'tile.png']);
    _player = Player();

    world.add(_player);
    camera.viewfinder.anchor = Anchor.center;
    camera.follow(_player);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera.setBounds(Rectangle.fromLTRB(size.x / 2, size.y / 2, 100 * 32 - size.x / 2, 100 * 32 - size.y / 2));
  }
}