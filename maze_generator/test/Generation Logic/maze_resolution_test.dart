import 'package:maze_generator/Generation%20Logic/maze_coordinate.dart';
import 'package:maze_generator/Generation%20Logic/maze_resolution.dart';
import 'package:test/test.dart';

void main() {
  group('MazeResolution tests', () {

    test('Constructor throws ArgumentError', () {
      expect(() => MazeResolution(8, 2),
          throwsA(isA<ArgumentError>()));
    });

    test('Constructor valid arguments', () {
      expect(MazeResolution(8, 8),MazeResolution(8, 8));
    });

    test('.getTotalTiles square', () {
      MazeResolution mazeResolution = MazeResolution(8, 8);
      expect(mazeResolution.getTotalTiles(),64);
    });

    test('.getTotalTiles not square', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.getTotalTiles(),96);
    });

    test('.getNumberOfPossibleStartingTiles not square', () {
      MazeResolution mazeResolution = MazeResolution(8, 8);
      expect(mazeResolution.getNumberOfPossibleStartingTiles(),24);
    });

    test('.getNumberOfPossibleStartingTiles not square', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.getNumberOfPossibleStartingTiles(),32);
    });

    test('.getCoordinateFromStartingValue square', () {
      MazeResolution mazeResolution = MazeResolution(8, 8);
      expect(mazeResolution.getCoordinateFromStartingValue(4),MazeCoordinate(5, 0));
    });

    test('.getCoordinateFromStartingValue not square', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.getCoordinateFromStartingValue(25),MazeCoordinate(7, 10));
    });

    test('.isEdgeTile not edge tile', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isEdgeTile(MazeCoordinate(4, 10)),false);
    });

    test('.isEdgeTile edge tile max', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isEdgeTile(MazeCoordinate(7, 11)),true);
    });

    test('.isEdgeTile edge tile min', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isEdgeTile(MazeCoordinate(0, 10)),true);
    });

    test('.isCornerTile top left', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isCornerTile(MazeCoordinate(0, 0)),true);
    });

    test('.isCornerTile top right', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isCornerTile(MazeCoordinate(7, 0)),true);
    });

    test('.isCornerTile bottom left', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isCornerTile(MazeCoordinate(0, 11)),true);
    });

    test('.isCornerTile bottom right', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isCornerTile(MazeCoordinate(7, 11)),true);
    });

    test('.isCornerTile edge tile', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isCornerTile(MazeCoordinate(11, 4)),false);
    });

    test('.isCornerTile inside tile', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isCornerTile(MazeCoordinate(5, 4)),false);
    });

    test('.isCornerTile outside grid', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isCornerTile(MazeCoordinate(12, 8)),false);
    });

    test('.isWithInGrid outside grid', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isWithInGrid(MazeCoordinate(12, 8)),false);
    });

    test('.isWithInGrid inside grid', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isWithInGrid(MazeCoordinate(6, 4)),true);
    });

    test('.isWithInGrid edge', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isWithInGrid(MazeCoordinate(5, 11)),true);
    });

    test('.isWithInGrid corner', () {
      MazeResolution mazeResolution = MazeResolution(12, 8);
      expect(mazeResolution.isWithInGrid(MazeCoordinate(0, 0)),true);
    });
  });
}
