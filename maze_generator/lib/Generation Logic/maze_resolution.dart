import 'package:maze_generator/Generation%20Logic/maze_coordinate.dart';

/// Allows easy definition of the dimensions of a maze.
/// This also allows for any logic regarding those dimensions to be encapsulated
/// here.
class MazeResolution extends Iterable<MazeCoordinate>
{
  late final int rows;
  late final int columns;

  /// Min 5 rows and columns.
  MazeResolution(this.rows, this.columns)
  {
    if (rows <= 4 || columns <= 4)
    {
      throw ArgumentError();
    }
  }

  int getTotalTiles()
  {
    return rows * columns;
  }

  int getNumberOfPossibleStartingTiles()
  {
    return ((columns - 2) * 2) + ((rows - 2) * 2);
  }

  /// A starting position is randomly picked as an integer between 0 and the
  /// number of possible starting positions calculated above, this method
  /// translates that value into a coordinate.
  MazeCoordinate getCoordinateFromStartingValue(int value)
  {
    if (value < columns - 2)
    {
      return MazeCoordinate(value + 1, 0);
    }
    value -= columns - 2;
    if (value < (rows - 2) * 2)
    {
      if (value % 2 == 0)
      {
        return MazeCoordinate(0, (value / 2).floor() + 1);
      }
      return MazeCoordinate(columns - 1, (value / 2).floor() + 1);
    }
    value -= (rows - 2) * 2;
    return MazeCoordinate(value + 1, rows - 1);
  }

  bool isEdgeTile(MazeCoordinate coordinate)
  {
    return coordinate.column == 0 || coordinate.column == columns - 1 ||
        coordinate.row == 0 || coordinate.row == rows - 1;
  }

  bool isCornerTile(MazeCoordinate coordinate)
  {
    if (coordinate.row == 0 || coordinate.row == rows - 1)
    {
      return coordinate.column == 0 || coordinate.column == columns - 1;
    }
    return false;
  }

  bool isWithInGrid(MazeCoordinate coordinate)
  {
    return !(coordinate.row < 0 || coordinate.row > rows - 1
        || coordinate.column < 0 || coordinate.column > columns - 1);
  }

  /// Simplifies the process of iterating through all the coordinates in grid.
  /// Allows for all the tiles to be checked at the end of the maze generation
  /// to ensure that every tile has been set as either a path or wall.
  @override
  Iterator<MazeCoordinate> get iterator
  {
    List<MazeCoordinate> coordinates = [];
    for (int y = 0; y < rows; y++)
    {
      for (int x = 0; x < columns; x++)
      {
        coordinates.add(MazeCoordinate(x, y));
      }
    }
    return coordinates.iterator;
  }
}