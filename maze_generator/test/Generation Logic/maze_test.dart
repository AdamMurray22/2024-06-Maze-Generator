import 'package:maze_generator/Generation%20Logic/maze.dart';
import 'package:maze_generator/Generation%20Logic/maze_resolution.dart';
import 'package:maze_generator/Generation%20Logic/maze_tile.dart';
import 'package:test/test.dart';

void main() {
  group('Maze tests', () {

    Maze maze = Maze.seed(MazeResolution(20,20), 1.2, 100);

    test('.getTile wall', () {
      expect(maze.getTile(70),MazeTile.wall);
    });

    test('.getTile path', () {
      expect(maze.getTile(64),MazeTile.path);
    });

    test('.getTile wall', () {
      expect(maze.getTile(80),MazeTile.wall);
    });

    test('.getTile path', () {
      expect(maze.getTile(90),MazeTile.path);
    });

    test('.getTile start/end path 1', () {
      expect(maze.getTile(100),MazeTile.path);
    });

    test('.getTile start/end path 2', () {
      expect(maze.getTile(299),MazeTile.path);
    });
  });
}
