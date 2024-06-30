import 'package:maze_generator/Generation%20Logic/maze_coordinate.dart';
import 'package:maze_generator/Generation%20Logic/maze_grid.dart';
import 'package:maze_generator/Generation%20Logic/maze_resolution.dart';
import 'package:maze_generator/Generation%20Logic/maze_tile.dart';
import 'package:test/test.dart';

void main() {
  group('MazeGrid tests', () {

    test('.getTile undecided', () {
      MazeResolution mazeResolution = MazeResolution(10, 10);
      MazeGrid grid = MazeGrid(mazeResolution);
      MazeCoordinate coordinate = MazeCoordinate(5, 6);
      expect(grid.getTile(coordinate),MazeTile.undecided);
    });

    test('.getTile after set', () {
      MazeResolution mazeResolution = MazeResolution(10, 10);
      MazeGrid grid = MazeGrid(mazeResolution);
      MazeCoordinate coordinate = MazeCoordinate(5, 6);
      grid.setTile(coordinate, MazeTile.wall);
      expect(grid.getTile(coordinate),MazeTile.wall);
    });

    test('.getTileFromIndex undecided', () {
      MazeResolution mazeResolution = MazeResolution(10, 10);
      MazeGrid grid = MazeGrid(mazeResolution);
      expect(grid.getTileFromIndex(45),MazeTile.undecided);
    });

    test('.getTileFromIndex after set', () {
      MazeResolution mazeResolution = MazeResolution(10, 10);
      MazeGrid grid = MazeGrid(mazeResolution);
      MazeCoordinate coordinate = MazeCoordinate(5, 4);
      grid.setTile(coordinate, MazeTile.wall);
      expect(grid.getTileFromIndex(45),MazeTile.wall);
    });

    test('.getTile undecided', () {
      MazeResolution mazeResolution = MazeResolution(10, 10);
      MazeGrid grid = MazeGrid(mazeResolution);
      MazeCoordinate coordinate = MazeCoordinate(5, 6);
      expect(grid.getTile(coordinate),MazeTile.undecided);
    });

    test('.setTile set Wall', () {
      MazeResolution mazeResolution = MazeResolution(10, 10);
      MazeGrid grid = MazeGrid(mazeResolution);
      MazeCoordinate coordinate = MazeCoordinate(5, 6);
      grid.setTile(coordinate, MazeTile.wall);
      expect(grid.getTile(coordinate),MazeTile.wall);
    });

    test('.setTile set Path', () {
      MazeResolution mazeResolution = MazeResolution(10, 10);
      MazeGrid grid = MazeGrid(mazeResolution);
      MazeCoordinate coordinate = MazeCoordinate(5, 6);
      grid.setTile(coordinate, MazeTile.path);
      expect(grid.getTile(coordinate),MazeTile.path);
    });

    test('.setTileIfUndecided set undecided to Path', () {
      MazeResolution mazeResolution = MazeResolution(10, 10);
      MazeGrid grid = MazeGrid(mazeResolution);
      MazeCoordinate coordinate = MazeCoordinate(5, 6);
      grid.setTileIfUndecided(coordinate, MazeTile.path);
      expect(grid.getTile(coordinate),MazeTile.path);
    });

    test('.setTileIfUndecided set Path to Wall', () {
      MazeResolution mazeResolution = MazeResolution(10, 10);
      MazeGrid grid = MazeGrid(mazeResolution);
      MazeCoordinate coordinate = MazeCoordinate(5, 6);
      grid.setTile(coordinate, MazeTile.path);
      grid.setTileIfUndecided(coordinate, MazeTile.wall);
      expect(grid.getTile(coordinate),MazeTile.path);
    });
  });
}
