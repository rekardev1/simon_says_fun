import 'dart:math';

class SimonSaysGame {
  final List<int> _pattern = [];
  int _currentIndex = 0;

  List<int> get pattern => _pattern;

  void start() {
    _pattern.clear();
    _currentIndex = 0;
    _generatePattern();
  }

  void _generatePattern() {
    final random = Random();
    for (int i = 0; i < 4; i++) {
      int tileIndex;
      do {
        tileIndex = random.nextInt(4);
      } while ((_pattern.contains(tileIndex)));
      _pattern.add(tileIndex);
    }
  }

  int? getNextTile() {
    if (_currentIndex < _pattern.length) {
      return _pattern[_currentIndex++];
    } else {
      return null;
    }
  }
}
