import 'package:maze_generator/Generation%20Logic/direction.dart';
import 'package:maze_generator/Generation%20Logic/maze_coordinate.dart';
import 'package:maze_generator/Generation%20Logic/maze_resolution.dart';
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

void main() {
  group('Direction tests', () {
    final MazeResolution mazeResolution = MazeResolution(10, 10);

    test('.getNewBaseCoordinateAndDirection base in top left corner direction down', () {
      const Direction direction = Direction.down;
      MazeCoordinate coordinate = MazeCoordinate(0, 0);
      expect(direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          Tuple2<MazeCoordinate,Direction>(MazeCoordinate(0,mazeResolution.rows - 1), Direction.right));
    });

    test('.getNewBaseCoordinateAndDirection base in top left corner direction up', () {
      const Direction direction = Direction.up;
      MazeCoordinate coordinate = MazeCoordinate(0, 0);
      expect(direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          Tuple2<MazeCoordinate,Direction>(MazeCoordinate(0,0), Direction.right));
    });

    test('.getNewBaseCoordinateAndDirection base in top left corner direction right', () {
      const Direction direction = Direction.right;
      MazeCoordinate coordinate = MazeCoordinate(0, 0);
      expect(direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          Tuple2<MazeCoordinate,Direction>(MazeCoordinate(mazeResolution.columns - 1,0), Direction.down));
    });

    test('.getNewBaseCoordinateAndDirection base in top left corner direction left', () {
      const Direction direction = Direction.left;
      MazeCoordinate coordinate = MazeCoordinate(0, 0);
      expect(direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          Tuple2<MazeCoordinate,Direction>(MazeCoordinate(0,0), Direction.down));
    });

    test('.getNewBaseCoordinateAndDirection base in bottom right corner direction down', () {
      const Direction direction = Direction.down;
      MazeCoordinate coordinate = MazeCoordinate(mazeResolution.columns - 1, mazeResolution.rows - 1);
      expect(direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          Tuple2<MazeCoordinate,Direction>(MazeCoordinate(mazeResolution.columns - 1,mazeResolution.rows - 1), Direction.left));
    });

    test('.getNewBaseCoordinateAndDirection base in bottom right corner direction up', () {
      const Direction direction = Direction.up;
      MazeCoordinate coordinate = MazeCoordinate(mazeResolution.columns - 1, mazeResolution.rows - 1);
      expect(direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          Tuple2<MazeCoordinate,Direction>(MazeCoordinate(mazeResolution.columns - 1,0), Direction.left));
    });

    test('.getNewBaseCoordinateAndDirection base in bottom right corner direction right', () {
      const Direction direction = Direction.right;
      MazeCoordinate coordinate = MazeCoordinate(mazeResolution.columns - 1, mazeResolution.rows - 1);
      expect(direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          Tuple2<MazeCoordinate,Direction>(MazeCoordinate(mazeResolution.columns - 1,mazeResolution.rows - 1), Direction.up));
    });

    test('.getNewBaseCoordinateAndDirection base in bottom right corner direction left', () {
      const Direction direction = Direction.left;
      MazeCoordinate coordinate = MazeCoordinate(mazeResolution.columns - 1, mazeResolution.rows - 1);
      expect(direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          Tuple2<MazeCoordinate,Direction>(MazeCoordinate(0,mazeResolution.columns - 1), Direction.up));
    });

    test('.getNewBaseCoordinateAndDirection base in top middle direction down', () {
      const Direction direction = Direction.down;
      MazeCoordinate coordinate = MazeCoordinate(((mazeResolution.columns - 1)/2).ceil(), 0);
      expect(() => direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          throwsA(isA<ArgumentError>()));
    });

    test('.getNewBaseCoordinateAndDirection base in top middle direction up', () {
      const Direction direction = Direction.up;
      MazeCoordinate coordinate = MazeCoordinate(((mazeResolution.columns - 1)/2).ceil(), 0);
      expect(() => direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          throwsA(isA<ArgumentError>()));
    });

    test('.getNewBaseCoordinateAndDirection base in top middle direction right', () {
      const Direction direction = Direction.right;
      MazeCoordinate coordinate = MazeCoordinate(((mazeResolution.columns - 1)/2).ceil(), 0);
      expect(direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          Tuple2<MazeCoordinate,Direction>(MazeCoordinate(mazeResolution.columns - 1,0), Direction.down));
    });

    test('.getNewBaseCoordinateAndDirection base in top middle direction left', () {
      const Direction direction = Direction.left;
      MazeCoordinate coordinate = MazeCoordinate(((mazeResolution.columns - 1)/2).ceil(), 0);
      expect(direction.getNewBaseCoordinateAndDirection(coordinate, mazeResolution),
          Tuple2<MazeCoordinate,Direction>(MazeCoordinate(0,0), Direction.down));
    });
  });
}
