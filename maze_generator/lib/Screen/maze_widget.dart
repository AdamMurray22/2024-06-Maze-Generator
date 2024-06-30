import 'package:flutter/material.dart';
import 'package:maze_generator/Generation%20Logic/maze_resolution.dart';

import '../Generation Logic/maze.dart';

class MazeWidget extends StatefulWidget {
  const MazeWidget({super.key});

  @override
  State<MazeWidget> createState() => MazeWidgetState();

}

class MazeWidgetState extends State<MazeWidget> {

  // For best visual results use the same value for height and width.
  // Min 4 rows and columns.
  final MazeResolution _resolution = MazeResolution(20,20);

  // This is here to ensure that the correct path is not too short by marking
  // an area around the start point in which the endpoint cannot appear.
  // The value is a multiplier to the average of the height and width of the maze
  final double nonCompletionZone = 1.2;

  late Maze _maze;

  @override
  initState()
  {
    _maze = Maze.seed(_resolution, nonCompletionZone,100);
  }

  createNewMaze()
  {
    setState(() {
      _maze = Maze(_resolution, nonCompletionZone);
    });
  }

  List<Container> _generateTiles()
  {
    return List<Container>.generate(_resolution.getTotalTiles(), (index) {
      return Container(color: _maze.getTile(index).color);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: _resolution.columns),
      children: _generateTiles(),
    );
  }
}