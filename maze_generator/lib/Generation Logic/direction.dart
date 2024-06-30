import 'package:maze_generator/Generation%20Logic/maze_coordinate.dart';
import 'package:maze_generator/Generation%20Logic/maze_resolution.dart';
import 'package:tuple/tuple.dart';

/// This solves a problem when creating a barrier around the starting tile in which
/// the end tile cannot appear. This barrier is created by turning the edge of the grid
/// in this area into wall before the correct path is generated.
/// The problem was that a number of edge tiles in each direction from the start
/// had to be turned into wall tiles, and this line of tiles might go around corners.
/// So in order to incrementally set each edge tile as wall, I defined the direction
/// the line was travelling and the base tile(where it was starting from on the line)
/// when line the line wrapped around corners the base tile would move to that corner
/// and the direction would also adjust to the new direction the line would be
/// travelling in.
/// This direction combined with the base tile significantly simplified the code
/// need to wrap these lines around the corner on the edge of the grid.
enum Direction
{
  up(-1),
  down(1),
  left(-1),
  right(1);

  const Direction(this.multiplier);

  final int multiplier;

  Tuple2<MazeCoordinate,Direction> getNewBaseCoordinateAndDirection(MazeCoordinate coordinate, MazeResolution mazeResolution)
  {
    Direction newDirection;
    int newBaseColumn;
    int newBaseRow;
    if (this == Direction.up || this == Direction.down)
    {
      if (coordinate.column == 0)
      {
        newDirection = Direction.right;
        newBaseColumn = 0;
      }
      else if (coordinate.column == mazeResolution.columns - 1)
      {
        newDirection = Direction.left;
        newBaseColumn = mazeResolution.columns - 1;
      }
      else
      {
        throw ArgumentError("Invalid coordinate and direction.");
      }
      if (this == Direction.down)
      {
        newBaseRow = mazeResolution.rows - 1;
      }
      else
      {
        newBaseRow = 0;
      }
    }
    else
    {
      if (coordinate.row == 0)
      {
        newDirection = Direction.down;
        newBaseRow = 0;
      }
      else if (coordinate.row == mazeResolution.rows - 1)
      {
        newDirection = Direction.up;
        newBaseRow = mazeResolution.rows - 1;
      }
      else
      {
        throw ArgumentError("Invalid coordinate and direction.");
      }
      if (this == Direction.right)
      {
        newBaseColumn = mazeResolution.columns - 1;
      }
      else
      {
        newBaseColumn = 0;
      }
    }
    return Tuple2<MazeCoordinate,Direction>(MazeCoordinate(newBaseColumn,newBaseRow),newDirection);
  }
}