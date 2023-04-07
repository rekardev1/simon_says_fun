import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../SimonSaysGame.dart';

class SimonSaysApp extends StatefulWidget {
  const SimonSaysApp({super.key});

  @override
  _SimonSaysAppState createState() => _SimonSaysAppState();
}

class _SimonSaysAppState extends State<SimonSaysApp> {
  SimonSaysGame _game = SimonSaysGame();
  List<int> _playerPattern = [];
  bool _gameStarted = false;
  int? _currentTile;
  int _currentLevel = 1;

  @override
  void initState() {
    super.initState();
    _game.start();
  }

  void _handleTileTap(int tileIndex) async {
    if (_gameStarted) {
      _playerPattern.add(tileIndex);
      setState(() {
        _currentTile = tileIndex;
      });
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _currentTile = null;
      });

      if (_playerPattern.length == _game.pattern.length) {
        SnackBar snackBar;
        if (const ListEquality().equals(_playerPattern, _game.pattern)) {
          _currentLevel++;
          snackBar = SnackBar(
            content: const Text('You win!', style: TextStyle(color: Colors.green)),
            action: SnackBarAction(
              label: 'Play again',
              onPressed: () {
                _playGame();
              },
            ),
          );
        } else {
          _currentLevel = 1;
          snackBar = SnackBar(
            content: const Text('You lose!', style: TextStyle(color: Colors.red)),
            action: SnackBarAction(
              label: 'Play again',
              onPressed: () {
                _playGame();
              },
            ),
          );
        }
        _gameStarted = false;
        _playerPattern.clear();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void _playGame() async {
    _game.start();

    setState(() {
      _gameStarted = true;
      _playerPattern.clear();
      _currentTile = _game.getNextTile();
    });

    while (_currentTile != null) {
      final duration = _currentLevel == 1 ? 1000 : 1000 ~/ _currentLevel;

      await Future.delayed(Duration(milliseconds: duration));
      setState(() {
        _currentTile = _game.getNextTile();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simon Says Game: Current Level: $_currentLevel'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _handleTileTap(index),
            child: Container(
              color: _gameStarted && _currentTile == index
                  ? Color.fromARGB(255, 42, 30, 255)
                  : Color.fromARGB(255, 108, 122, 248),
              margin: const EdgeInsets.all(8),
            ),
          );
        },
        itemCount: 4,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _playGame,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
