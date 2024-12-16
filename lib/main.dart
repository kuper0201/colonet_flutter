// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/experimental.dart';
// import 'package:flame/flame.dart';
// import 'package:flame/game.dart';
// import 'package:flame/sprite.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_gm/Player.dart';
// import 'package:flutter_gm/TileComponent.dart';

// void main() {
//   runApp(GameWidget(game: Game()));
// }

// class Game extends FlameGame with HasKeyboardHandlerComponents {
//   late final Player _player;
//   final Map<String, TileComponent> visibleTiles = {}; // 보이는 타일 캐싱
//   late final SpriteBatch _spriteBatch;

//   @override
//   void onMount() {
//     super.onMount();
//   }

//   void _updateVisibleTiles() {
//     // 카메라 위치와 뷰포트 크기 가져오기
//     final int tileSize = 32;
//     final cameraX = camera.viewfinder.position.x;
//     final cameraY = camera.viewfinder.position.y;

//     final viewportWidth = size.x;
//     final viewportHeight = size.y;
//     final mapWidth = 10000;
//     final mapHeight = 10000;
//     final tilesize = 32;

//     // 보이는 타일 인덱스 계산
//     int playerX = (camera.viewfinder.position.x / tileSize).floor();
//     int playerY = (camera.viewfinder.position.y / tileSize).floor();

//     for(int i = -5; i < 5; i++) {
//       for(int j = -5; j < 5; j++) {
//           double x1 = (playerX + i) * tileSize.toDouble();
//           double y1 = (playerY + j) * tileSize.toDouble();
//           final tilePosition = Vector2(x1, y1);

//           final tile = TileComponent.init(tilePosition);

//           add(tile); // Flame 게임에 타일 추가
//       }
//     }
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//     _updateVisibleTiles();
//   }
  
//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
//     await images.loadAll(['player.png', 'tile.png']);
//     _player = Player();

//     world.add(_player);
//     camera.viewfinder.anchor = Anchor.center;
//     camera.follow(_player);
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//   }

//   @override
//   void onGameResize(Vector2 size) {
//     super.onGameResize(size);
//     // camera.setBounds(Rectangle.fromLTRB(size.x / 2, size.y / 2, 100 * 32 - size.x / 2, 100 * 32 - size.y / 2));
//   }
// }

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
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
  final int tileSize = 32; // 타일 크기 상수

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await images.loadAll(['player.png', 'tile.png']);
    _player = Player();

    world.add(_player);
    camera.viewfinder.anchor = Anchor.center;
    camera.follow(_player);

    _updateVisibleTiles(); // 초기 타일 생성
  }

  void _updateVisibleTiles() {
    final int range = 5; // 플레이어 주변의 타일 범위 (5x5)
    final int playerX = (_player.position.x / tileSize).floor();
    final int playerY = (_player.position.y / tileSize).floor();

    print("$playerX, $playerY");

    final Set<String> newVisibleKeys = {}; // 새로 보이는 타일들의 키 저장

    for (int i = -range; i <= range; i++) {
      for (int j = -range; j <= range; j++) {
        final int tileX = playerX + i;
        final int tileY = playerY + j;

        final String key = '$tileX-$tileY'; // 타일의 유니크 키
        newVisibleKeys.add(key);

        if (!visibleTiles.containsKey(key)) {
          final Vector2 tilePosition = Vector2(tileX * tileSize.toDouble(), tileY * tileSize.toDouble());
          final tile = TileComponent.init(tilePosition);
          world.add(tile);
          print("add");
          visibleTiles[key] = tile; // 타일을 캐싱에 추가
        }
      }
    }

    // 화면에서 벗어난 타일 제거
    // final keysToRemove = visibleTiles.keys.where((key) => !newVisibleKeys.contains(key)).toList();
    // for (final key in keysToRemove) {
    //   world.remove(visibleTiles[key]!); // Flame 게임에서 타일 제거
    //   visibleTiles.remove(key); // 캐싱에서 제거
    // }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateVisibleTiles();
  }
}
