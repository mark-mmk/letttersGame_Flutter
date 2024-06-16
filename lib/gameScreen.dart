import 'package:flutter/material.dart';
import 'apiLetters/apiService.dart';
import 'apiLetters/letters.dart';

class Gamescreen extends StatefulWidget {
  const Gamescreen({super.key});

  @override
  State<Gamescreen> createState() => _GamescreenState();
}

class _GamescreenState extends State<Gamescreen> {
  final Apiservice _apiService = Apiservice();
  Letters? _letters;

  final List<String> _words = [
    "APPLE",
    "GRAPES",
    "LEMON",
    "BANANA",
    "ORANGE",
    "MANGO",
  ];

  List<bool> _clicked = [];
  List<bool> _wordClicked = [];
  List<String> _clickedLetters = [];
  List<bool> _correctLetters = [];
  List<bool> _correctWords = [];

  @override
  void initState() {
    super.initState();
    _loadLetters();
  }

  Future<void> _loadLetters() async {
    _letters = await _apiService.getLetters();
    setState(() {
      _clicked = List.filled(_letters!.letters.length, false);
      _wordClicked = List.filled(_words.length, false);
      _correctLetters = List.filled(_letters!.letters.length, false);
      _correctWords = List.filled(_words.length, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _letters!= null? _buildGameBody() : _buildLoadingIndicator(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Center(child: Text("World Game")),
      actions: [
        IconButton(
          onPressed: _resetGame,
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildGameBody() {
    return Column(
      children: [
        const SizedBox(height: 40),
        _buildLetterGrid(),
        const SizedBox(height: 70),
        ElevatedButton(
          onPressed: _checkIfWord,
          child: const Text('Check Letters'),
        ),
        const SizedBox(height: 20),
        const Text(
          "Formed Words:",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          flex: 8,
          child: _buildWordGrid(),
        ),
      ],
    );
  }

  Widget _buildLetterGrid() {
    return GridView.count(
      crossAxisCount: 9,
      shrinkWrap: true,
      children: List.generate(
        _letters!.letters.length,
            (index) => GestureDetector(
          onTap: () => _handleLetterTap(index),
          child: _buildLetterContainer(index),
        ),
      ),
    );
  }

  Widget _buildLetterContainer(int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: _clicked[index] && _correctLetters[index]
            ? Colors.green
            : _clicked[index] &&!_correctLetters[index]
            ? Colors.red
            : Colors.white,
      ),
      child: Center(
        child: Text(
          _letters!.letters[index],
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildWordGrid() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: _words.map((word) {
        final int index = _words.indexOf(word);
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(1),
            color: _wordClicked[index] && _correctWords[index]
                ? Colors.green
                : _wordClicked[index]? Colors.red : Colors.white,
          ),
          child: Center(
            child: Text(
              word,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _resetGame() {
    setState(() {
      _clicked = List.filled(_letters!.letters.length, false);
      _wordClicked = List.filled(_words.length, false);
      _clickedLetters = [];
      _correctLetters = List.filled(_letters!.letters.length, false);
      _correctWords = List.filled(_words.length, false);
    });
  }

  void _handleLetterTap(int index) {
    setState(() {
      _clicked[index] =!_clicked[index];
      if (_clicked[index]) {
        _clickedLetters.add(_letters!.letters[index]);
      } else {
        _clickedLetters.remove(_letters!.letters[index]);
      }
    });
  }

  void _checkIfWord() {
    bool isWordFormed = false;
    for (int i = 0; i < _words.length; i++) {
      if (_words[i].toUpperCase() == _clickedLetters.join('').toUpperCase() &&
          _words[i].length == _clickedLetters.length) {
        setState(() {
          _wordClicked[i] = true;
          _correctWords[i] = true;
        });
        isWordFormed = true;
      } else {
        setState(() {
          _wordClicked[i] = false;
          _correctWords[i] = false;
        });
      }
    }
    for (int i = 0; i < _letters!.letters.length; i++) {
      if (_clickedLetters.contains(_letters!.letters[i].toUpperCase())) {
        if (isWordFormed) {
          setState(() {
            _correctLetters[i] = true;
          });
        } else {
          setState(() {
            _correctLetters[i] = false;
          });
        }
      } else {
        setState(() {
          _correctLetters[i] = false;
        });
      }
    }
    if (isWordFormed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You formed a word!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You did not form a word.')),
      );
    }
  }
}