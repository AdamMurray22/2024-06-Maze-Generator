import 'package:maze_generator/Generation%20Logic/maze_coordinate.dart';
import 'package:test/test.dart';

void main() {
  group('Coordinate tests', () {

    test('== not equal coordinates', () {
      MazeCoordinate coordinate1 = MazeCoordinate(6, 6);
      MazeCoordinate coordinate2 = MazeCoordinate(0, 0);
      expect(coordinate1 == coordinate2,false);
    });

    test('== equal coordinates', () {
      MazeCoordinate coordinate1 = MazeCoordinate(8, 4);
      MazeCoordinate coordinate2 = MazeCoordinate(8, 4);
      expect(coordinate1 == coordinate2,true);
    });
  });
}
