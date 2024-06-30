import 'maze_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final GlobalKey<MazeWidgetState> _mazeStateKey = GlobalKey();

  late final MazeWidget _maze;

  @override
  initState()
  {
    _maze = MazeWidget(key: _mazeStateKey);
    super.initState();
  }

  _generateMaze()
  {
    _mazeStateKey.currentState?.createNewMaze();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: _maze),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _generateMaze();
            },
            child: const Text("Generate New Maze", style: TextStyle(fontSize: 27)),
          ),
        ],
      ),
    );
  }
}