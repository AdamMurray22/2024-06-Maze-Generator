import 'maze_coordinate.dart';
import 'maze_resolution.dart';
import 'maze_tile.dart';

/// MazeGrid encapsulates the grid itself simplifying accessing the grid from the
/// perspective of other classes.
/// The grid can be imagined as a 2D array where (0,0) is the top left of the grid.
class MazeGrid
{
  late List<List<MazeTile>> _grid;
  final MazeResolution _mazeResolution;

  MazeGrid(this._mazeResolution)
  {
    _grid = List<List<MazeTile>>.generate(_mazeResolution.rows,
            (i) => List<MazeTile>.generate(_mazeResolution.columns,
                (index) => MazeTile.undecided, growable: false), growable: false);
  }

  /// The index taken starting at the top left of the grid going right and then
  /// line by line.
  MazeTile getTileFromIndex(int index)
  {
    return _grid[(index / _mazeResolution.columns).floor()][index % _mazeResolution.columns];
  }

  /// Gets a tile from its coordinate.
  MazeTile getTile(MazeCoordinate coordinate)
  {
    return _grid[coordinate.row][coordinate.column];
  }

  /// To overwrite a tile.
  setTile(MazeCoordinate coordinate, MazeTile tile)
  {
    _grid[coordinate.row][coordinate.column] = tile;
  }

  /// To simplify setting tiles where you don't want to overwrite tiles that have
  /// already been set.
  setTileIfUndecided(MazeCoordinate coordinate, MazeTile tile)
  {
    if (_grid[coordinate.row][coordinate.column] == MazeTile.undecided)
    {
      _grid[coordinate.row][coordinate.column] = tile;
    }
  }
}