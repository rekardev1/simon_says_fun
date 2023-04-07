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
      if (_playerPattern.contains(tileIndex)) {
        var index = _playerPattern.indexOf(tileIndex);
        _playerPattern.removeRange(index, _playerPattern.length);
      } else {
        _playerPattern.add(tileIndex);
      }

      if (_playerPattern.length == _game.pattern.length) {
        if (const ListEquality().equals(_playerPattern, _game.pattern)) {
          _currentLevel++;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('You win!', style: TextStyle(color: Colors.green)),
            action: SnackBarAction(
              label: 'Next level',
              onPressed: () {
                _playGame();
              },
            ),
          ));
        } else {
          _currentLevel = 1;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('You lose!', style: TextStyle(color: Colors.red)),
            action: SnackBarAction(
              label: 'Play again',
              onPressed: () {
                _playGame();
              },
            ),
          ));
        }
        _gameStarted = false;
        _playerPattern.clear();
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
        padding: EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(10),
            child: TextButton(
                style: TextButton.styleFrom(
                  splashFactory: NoSplash.splashFactory,
                  backgroundColor: _gameStarted && _currentTile == index ? Colors.blue : Colors.white,
                  foregroundColor: _gameStarted && _currentTile == index ? Colors.white : Colors.blue,
                ),
                onPressed: () async {
                  setState(() {
                    _currentTile = index;
                  });
                  await Future.delayed(const Duration(milliseconds: 50));
                  _handleTileTap(index);
                  setState(() {
                    _currentTile = null;
                  });
                },
                child: _playerPattern.isNotEmpty && _playerPattern.contains(index)
                    ? Text('${_playerPattern.indexOf(index) + 1}', style: const TextStyle(fontSize: 50))
                    : const SizedBox.shrink()),
          );
        },
        itemCount: 4,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_gameStarted) {
            _playGame();
          }
        },
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
