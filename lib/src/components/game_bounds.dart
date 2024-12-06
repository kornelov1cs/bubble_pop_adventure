import 'package:flame_forge2d/flame_forge2d.dart';

class GameBounds extends BodyComponent {
  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: Vector2.zero(),
    );

    final body = world.createBody(bodyDef);
    final rect = game.camera.visibleWorldRect;

    // Create boundaries
    final topWall = EdgeShape()
      ..set(Vector2(rect.left, rect.top), Vector2(rect.right, rect.top));
    final bottomWall = EdgeShape()
      ..set(Vector2(rect.left, rect.bottom), Vector2(rect.right, rect.bottom));
    final leftWall = EdgeShape()
      ..set(Vector2(rect.left, rect.top), Vector2(rect.left, rect.bottom));
    final rightWall = EdgeShape()
      ..set(Vector2(rect.right, rect.top), Vector2(rect.right, rect.bottom));

    body.createFixture(FixtureDef(topWall));
    body.createFixture(FixtureDef(bottomWall));
    body.createFixture(FixtureDef(leftWall));
    body.createFixture(FixtureDef(rightWall));

    return body;
  }
}
