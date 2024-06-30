import 'dart:math';

import 'package:maze_generator/Generation%20Logic/maze_grid.dart';
import 'package:tuple/tuple.dart';

import 'direction.dart';
import 'maze_resolution.dart';
import 'maze_tile.dart';
import 'maze_coordinate.dart';

/// Encapsulates the maze generation logic to easily interact with the UI.
class Maze
{
  late final Random _random;
  final MazeResolution _mazeResolution;
  late MazeGrid _grid;
  final double _nonCompletionZone;

  Maze(this._mazeResolution, this._nonCompletionZone)
  {
    _random = Random();
    _grid = MazeGrid(_mazeResolution);
    _generateMaze();
  }

  /// Allows the random seed to be set for testing purposes.
  Maze.seed(this._mazeResolution, this._nonCompletionZone, int seed)
  {
    _random = Random(seed);
    _grid = MazeGrid(_mazeResolution);
    _generateMaze();
  }

  MazeTile getTile(int index)
  {
    return _grid.getTileFromIndex(index);
  }

  // Generating the maze follows a 4 step process.
  // First generate the correct path through the maze, more information on this below.
  // Then will in the remainder of the outer wall.
  // Next fill in the maze with lots of incorrect paths, more info below.
  // Finally fill in any gaps created.
  _generateMaze()
  {
    // These split coordinates are not tiles that are guaranteed to be able to split,
    // but instead, all tiles that are not in this collection are guaranteed to
    // not be able to split. May also contain duplicate tiles.
    List<MazeCoordinate> possibleSplitCoordinates = _createCorrectPath();
    _fillOuterWall();
    _createAlternatePaths(possibleSplitCoordinates);
    _fillEmptySpace();
  }

  // To create a good correct path for the maze we need it to move randomly
  // through the maze and be sufficiently long.
  List<MazeCoordinate> _createCorrectPath()
  {
    List<MazeCoordinate> path = [];
    int startingValue = _random.nextInt(_mazeResolution.getNumberOfPossibleStartingTiles()); // Randomises the starting location.
    MazeCoordinate startingCoordinate = _mazeResolution.getCoordinateFromStartingValue(startingValue);
    path.add(startingCoordinate);
    path.add(_addWallAndPathNextToStartingTile(startingCoordinate));
    _addOuterWallNoCompletionZone(startingCoordinate);

    bool correctPathCompleted = false;
    do
    {
      MazeCoordinate? nextPathTile = _generateNextPathTile(path.last);
      // At this stage a null value means that the path got trapped
      // inside the maze before it reached the outside.
      if (nextPathTile != null)
      {
        path.add(nextPathTile);
      }
      else
      {
        path = _splitForNewCorrectPath(path);
      }

      if (_mazeResolution.isEdgeTile(path.last))
      {
        correctPathCompleted = true;
      }
    } while (!correctPathCompleted);

    return path;
  }

  MazeCoordinate _addWallAndPathNextToStartingTile(MazeCoordinate coordinate)
  {
    _grid.setTile(coordinate, MazeTile.path);
    if (coordinate.column == 0 || coordinate.column == _mazeResolution.columns - 1)
    {
      _grid.setTile(MazeCoordinate(coordinate.column, coordinate.row + 1), MazeTile.wall);
      _grid.setTile(MazeCoordinate(coordinate.column, coordinate.row - 1), MazeTile.wall);
      if (coordinate.column == 0)
      {
        MazeCoordinate path = MazeCoordinate(coordinate.column + 1, coordinate.row);
        _grid.setTile(path, MazeTile.path);
        return path;
      }
      else
      {
        MazeCoordinate path = MazeCoordinate(coordinate.column - 1, coordinate.row);
        _grid.setTile(path, MazeTile.path);
        return path;
      }
    }
    else
    {
      _grid.setTile(MazeCoordinate(coordinate.column + 1, coordinate.row), MazeTile.wall);
      _grid.setTile(MazeCoordinate(coordinate.column - 1, coordinate.row), MazeTile.wall);
      if (coordinate.row == 0)
      {
        MazeCoordinate path = MazeCoordinate(coordinate.column, coordinate.row + 1);
        _grid.setTile(path, MazeTile.path);
        return path;
      }
      else
      {
        MazeCoordinate path = MazeCoordinate(coordinate.column, coordinate.row - 1);
        _grid.setTile(path, MazeTile.path);
        return path;
      }
    }
  }

  // If the path does not have a guarantee of length in some sort then what often
  // happens is the random movement of the path will cause it to hit the outer
  // edge of the grid, and so mark the exit of the maze, very close to the start of the maze.
  // This is because the start of said random movement is 1 tile away from the edge,
  // and 3 tiles from a valid exit point, which is far closer than the other walls
  // of the grid.
  //
  // To solve this problem a "no completion zone" is defined around the start of the
  // maze. This is a wall that is built on the edge of the grid in which the end point
  // cannot be, thus forcing the end of the maze to be sufficiently far enough away to
  // create a good maze.
  _addOuterWallNoCompletionZone(MazeCoordinate startingCoordinate)
  {
    int minOuterDistanceFromStart =
      (((_mazeResolution.rows + _mazeResolution.columns) / 2) * _nonCompletionZone).ceil();
    if (startingCoordinate.row == 0 || startingCoordinate.row == _mazeResolution.rows - 1)
    {
      _setTilesToOuterWall(startingCoordinate, minOuterDistanceFromStart, Direction.right);
      _setTilesToOuterWall(startingCoordinate, minOuterDistanceFromStart, Direction.left);
    }
    else
    {
      _setTilesToOuterWall(startingCoordinate, minOuterDistanceFromStart, Direction.down);
      _setTilesToOuterWall(startingCoordinate, minOuterDistanceFromStart, Direction.up);
    }
  }

  _setTilesToOuterWall(MazeCoordinate baseCoordinate, int tilesToSet, Direction direction)
  {
    bool hitCorner = false;
    int count = 1;
    MazeCoordinate coordinate;
    while (!hitCorner && tilesToSet > 0)
    {
      if (direction == Direction.up || direction == Direction.down) {
        coordinate = MazeCoordinate(baseCoordinate.column,
            baseCoordinate.row + (count * direction.multiplier));
      }
      else
      {
        coordinate = MazeCoordinate(baseCoordinate.column + (count * direction.multiplier),
            baseCoordinate.row);
      }
      _grid.setTile(coordinate, MazeTile.wall);
      if (_mazeResolution.isCornerTile(coordinate))
      {
        hitCorner = true;
      }
      tilesToSet--;
      count++;
    }

    if (tilesToSet > 0)
    {
      Tuple2<MazeCoordinate,Direction> newCoordinateDirection =
        direction.getNewBaseCoordinateAndDirection(baseCoordinate, _mazeResolution);
      Direction newDirection = newCoordinateDirection.item2;
      _setTilesToOuterWall(newCoordinateDirection.item1, tilesToSet, newDirection);
    }
  }

  // Randomly picks the next coordinate to be turned into path that is
  // adjacent to the last placed path tile creates a continuous path.
  // Will not overwrite walls or paths here as the a good maze will have only 1 correct
  // path, so to decrease the odds the user accidentally stumbles onto the right path,
  // and all path tiles at this stage will be part of the correct path or part of
  // a dead end close to the correct path. Overwriting a wall would either connect
  // the path to previously placed paths, or hit the edge of the grid prematurely.
  MazeCoordinate? _generateNextPathTile(MazeCoordinate coordinate)
  {
    List<MazeCoordinate> adjacentTilesClear = [];
    _checkTileClear(adjacentTilesClear, MazeCoordinate(coordinate.column - 1, coordinate.row));
    _checkTileClear(adjacentTilesClear, MazeCoordinate(coordinate.column, coordinate.row + 1));
    _checkTileClear(adjacentTilesClear, MazeCoordinate(coordinate.column + 1, coordinate.row));
    _checkTileClear(adjacentTilesClear, MazeCoordinate(coordinate.column, coordinate.row - 1));
    if (adjacentTilesClear.isEmpty)
    {
      return null;
    }
    int nextPathTileIndex = _random.nextInt(adjacentTilesClear.length);
    MazeCoordinate nextPathTile = adjacentTilesClear[nextPathTileIndex];
    _grid.setTile(nextPathTile, MazeTile.path);
    _addWallsAroundPath(coordinate, nextPathTile);
    return nextPathTile;
  }

  _checkTileClear(List<MazeCoordinate> tilesClear, MazeCoordinate coordinate)
  {
    if (_grid.getTile(coordinate) == MazeTile.undecided)
    {
      tilesClear.add(coordinate);
    }
  }

  // Adds walls around the unused adjacent and diagonal tiles around the old path
  // except for the tiles adjacent to the new path.
  _addWallsAroundPath(MazeCoordinate oldPath, MazeCoordinate newPath)
  {
    for (int y = -1; y <= 1; y++)
    {
      for (int x = -1; x <= 1; x++)
      {
        if (!_isAdjacentToTile(newPath, MazeCoordinate(oldPath.column + x, oldPath.row + y)))
        {
          _grid.setTileIfUndecided(MazeCoordinate(oldPath.column + x, oldPath.row + y), MazeTile.wall);
        }
      }
    }
  }

  bool _isAdjacentToTile(MazeCoordinate tile, MazeCoordinate newTile)
  {
    if (tile.row == newTile.row)
    {
      return tile.column == newTile.column + 1 || tile.column == newTile.column - 1;
    }
    else if (tile.column == newTile.column)
    {
      return tile.row == newTile.row + 1 || tile.row == newTile.row - 1;
    }
    return false;
  }

  // When generating the correct path, it will often hit a dead-end where its
  // gone back on its self and run into previously placed walls,
  // like cornering yourself in snake.
  // So to combat this we back track through the most recently placed paths until
  // we hit a path from which we can split(overwrite an adjacent wall) and continue the correct path.
  //
  // We pick the path to split from using iterative backtracking instead of selecting
  // a split location randomly as this means that the split will take place at the
  // furthest place along the path from the start and thus will keep the correct path long.
  List<MazeCoordinate> _splitForNewCorrectPath(List<MazeCoordinate> path)
  {
    MazeCoordinate oldPath = path.last;
    path.removeLast();
    MazeCoordinate split = path.last;
    _addWallsAroundPath(oldPath, split);
    MazeCoordinate pathBeforeSplit = path[path.length - 2];
    List<MazeCoordinate> adjacentTiles = [
      MazeCoordinate(split.column, split.row + 1),
      MazeCoordinate(split.column, split.row - 1),
      MazeCoordinate(split.column + 1, split.row),
      MazeCoordinate(split.column - 1, split.row),
    ];
    adjacentTiles.remove(oldPath);
    adjacentTiles.remove(pathBeforeSplit);
    adjacentTiles.removeWhere((element) => !_hasEmptyAdjacentTile(element));
    if (adjacentTiles.isEmpty)
    {
      return _splitForNewCorrectPath(path);
    }
    MazeCoordinate pickedTile = _splitNewPath(adjacentTiles);
    path.add(pickedTile);
    return path;
  }

  MazeCoordinate _splitNewPath(List<MazeCoordinate> adjacentTiles)
  {
    int pickedTileIndex = _random.nextInt(adjacentTiles.length);
    MazeCoordinate pickedCoordinate = adjacentTiles[pickedTileIndex];
    _grid.setTile(pickedCoordinate, MazeTile.path);
    return pickedCoordinate;
  }

  // A path is only a valid split location if its adjacent tiles have
  // adjacent tiles themselves that are undecided.
  bool _hasEmptyAdjacentTile(MazeCoordinate coordinate)
  {
    Set<MazeCoordinate> adjacentTiles = {
      MazeCoordinate(coordinate.column, coordinate.row + 1),
      MazeCoordinate(coordinate.column, coordinate.row - 1),
      MazeCoordinate(coordinate.column + 1, coordinate.row),
      MazeCoordinate(coordinate.column - 1, coordinate.row),
    };
    return adjacentTiles.where((element) {
      return _mazeResolution.isWithInGrid(element) &&
            _grid.getTile(element) == MazeTile.undecided;
    }).isNotEmpty;
  }

  // After the correct path is established, all remaining edge tile must be wall tiles.
  _fillOuterWall()
  {
    int numberOfOuterNonCornerTiles = _mazeResolution.getNumberOfPossibleStartingTiles();
    for (int x = 0; x < numberOfOuterNonCornerTiles; x++)
    {
      MazeCoordinate coordinate = _mazeResolution.getCoordinateFromStartingValue(x);
      _grid.setTileIfUndecided(coordinate, MazeTile.wall);
    }
    _grid.setTileIfUndecided(MazeCoordinate(0, 0), MazeTile.wall);
    _grid.setTileIfUndecided(MazeCoordinate(0, _mazeResolution.rows - 1), MazeTile.wall);
    _grid.setTileIfUndecided(MazeCoordinate(_mazeResolution.columns - 1, 0), MazeTile.wall);
    _grid.setTileIfUndecided(MazeCoordinate(_mazeResolution.columns - 1, _mazeResolution.rows - 1), MazeTile.wall);
  }

  // Alternate paths are split randomly from any valid tile already placed on
  // the maze, that is valid for a split, and then they run until they hit a
  // dead-end through blocking themselves in.
  // Once an alternate path is blocked in then another is randomly picked from any
  // path. This is repeated until non valid paths remain for a split, aka the maze
  // is full.
  _createAlternatePaths(List<MazeCoordinate> possibleSplitCoordinates)
  {
    MazeCoordinate? currentPathCoordinate = _splitForNewAlternatePath(possibleSplitCoordinates);
    while (possibleSplitCoordinates.isNotEmpty)
    {
      MazeCoordinate? nextPathCoordinate = _generateNextPathTile(currentPathCoordinate!);
      // Null value means the path hit a dead-end.
      if (nextPathCoordinate != null)
      {
        possibleSplitCoordinates.add(currentPathCoordinate);
        currentPathCoordinate = nextPathCoordinate;
      }
      else
      {
        _fillWallsAroundDeadEnd(currentPathCoordinate);
        possibleSplitCoordinates.remove(currentPathCoordinate);
        currentPathCoordinate = _splitForNewAlternatePath(possibleSplitCoordinates);
      }
    }
  }

  // Split positions are chosen randomly so that the maze generated is as random
  // as can be.
  MazeCoordinate? _splitForNewAlternatePath(List<MazeCoordinate> possibleSplitCoordinates)
  {
    MazeCoordinate? splitCoordinate;
    MazeCoordinate? newPath;
    bool coordinateFound = false;
    while (!coordinateFound && possibleSplitCoordinates.isNotEmpty)
    {
      int splitTileIndex = _random.nextInt(possibleSplitCoordinates.length);
      splitCoordinate = possibleSplitCoordinates[splitTileIndex];
      newPath = _splitCoordinate(splitCoordinate);
      if (newPath != null)
      {
        coordinateFound = true;
      }
      else
      {
        possibleSplitCoordinates.remove(splitCoordinate);
      }
    }
    return newPath;
  }

  MazeCoordinate? _splitCoordinate(MazeCoordinate coordinate)
  {
    List<MazeCoordinate> adjacentTiles = [
      MazeCoordinate(coordinate.column, coordinate.row + 1),
      MazeCoordinate(coordinate.column, coordinate.row - 1),
      MazeCoordinate(coordinate.column + 1, coordinate.row),
      MazeCoordinate(coordinate.column - 1, coordinate.row),
    ];
    adjacentTiles.removeWhere((element) => !_hasEmptyAdjacentTile(element));
    if (adjacentTiles.isEmpty)
    {
      return null;
    }
    return _splitNewPath(adjacentTiles);
  }

  // Walls are normally filled in when the next path is placed, in a dead-end
  // there is no next path so this fills in those walls.
  _fillWallsAroundDeadEnd(MazeCoordinate path)
  {
    for (int y = -1; y <= 1; y++)
    {
      for (int x = -1; x <= 1; x++)
      {
          _grid.setTileIfUndecided(MazeCoordinate(path.column + x, path.row + y), MazeTile.wall);
      }
    }
  }

  // After all paths are generated, some coordinates in the grid may have been
  // missed due to how the walls generated around them.
  // This sets all those missed tiles to paths, these paths will be single
  // pieces of path surrounded on all sides by wall, but it makes it more
  // interesting then having them set to walls and without this method they'd stay
  // set to undecided.
  _fillEmptySpace()
  {
    for (MazeCoordinate coordinate in _mazeResolution)
    {
      _grid.setTileIfUndecided(coordinate, MazeTile.path);
    }
  }
}