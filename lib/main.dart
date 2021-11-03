import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:octopus/my_square.dart';

void main() => runApp(const OctopusGame());

class OctopusGame extends StatelessWidget {
  const OctopusGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int octopusPosition = 0;
  int scores = 0;

  int food = Random().nextInt(119);
  int foodType = Random().nextInt(3);
  bool isRunning = false;

  List<int> fence = [3, 27, 42, 46, 50, 69, 74, 101, 108, 115];

  @override
  Widget build(BuildContext context) {
    double mWidth = MediaQuery.of(context).size.width;
    double mHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          SizedBox(
            width: mWidth,
            height: (mHeight - mWidth * 1.2) / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Octopus  Game',
                    style: TextStyle(fontSize: 24, color: Colors.white)),
                Text('Scores : $scores',
                    style: const TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ),
          SizedBox(
            width: mWidth,
            height: mWidth * 1.2,
            child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (direction != 'up' && details.delta.dy > 0) {
                    direction = 'down';
                  } else if (direction != 'down' && details.delta.dy < 0) {
                    direction = 'up';
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (direction != 'left' && details.delta.dx > 0) {
                    direction = 'right';
                  } else if (direction != 'right' && details.delta.dx < 0) {
                    direction = 'left';
                  }
                },
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 120,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10),
                  itemBuilder: (BuildContext context, int index) {
                    if (octopusPosition == index) {
                      return MySquare(
                        color: Colors.green[300],
                        child: Image.asset('assets/octopus.png'),
                      );
                    } else if (fence.contains(index)) {
                      return MySquare(
                        color: Colors.green[300],
                        child: Image.asset('assets/fence.png'),
                      );
                    } else if (food == index) {
                      if (foodType == 0) {
                        return MySquare(
                          color: Colors.green[300],
                          child: Image.asset('assets/cacao.png'),
                        );
                      } else if (foodType == 1) {
                        return MySquare(
                          color: Colors.green[300],
                          child: Image.asset('assets/kinder.png'),
                        );
                      } else if (foodType == 2) {
                        return MySquare(
                          color: Colors.green[300],
                          child: Image.asset('assets/pie.png'),
                        );
                      } else {
                        return MySquare(
                          // if (foodType)
                          color: Colors.red,
                        );
                      }
                    } else {
                      return MySquare(
                        color: Colors.green[300],
                        //child: Text(index.toString()),
                      );
                    }
                  },
                )),
          ),
          SizedBox(
            width: mWidth,
            height: (mHeight - mWidth * 1.2) / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: startGame,
                    child: const Text(
                      'START',
                      style: TextStyle(fontSize: 30),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void startGame() {
    if (!isRunning) {
      isRunning = true;
      scores = 0;
      octopusPosition = 0;
      direction = 'down';

      const duration = Duration(milliseconds: 400);
      Timer.periodic(duration, (Timer timer) {
        updateOctopus();
        if (octopusPosition == food) {
          scores += 1;
          generateFood();
        }
        if (gameOver()) {
          isRunning = false;
          timer.cancel();
          _showGameOverScreen();
          //print('GameOver');
        }
      });
    }
  }

  var direction = 'down';
  void updateOctopus() {
    setState(() {
      switch (direction) {
        case 'down':
          if (octopusPosition + 10 < 120) {
            octopusPosition += 10;
          }
          break;
        case 'up':
          if (octopusPosition - 10 >= 0) {
            octopusPosition -= 10;
          }
          break;
        case 'left':
          if (!(octopusPosition % 10 == 0)) {
            octopusPosition -= 1;
          }
          break;
        case 'right':
          if (!(octopusPosition % 10 == 9)) {
            octopusPosition += 1;
          }
          break;
        default:
          break;
      }
    });
  }

  bool gameOver() {
    if (fence.contains(octopusPosition)) {
      return true;
    } else {
      return false;
    }
  }

  void _showGameOverScreen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Game Over'),
            content: Text('Your scores: $scores'),
            actions: <Widget>[
              TextButton(
                  child: const Text('Play again ?'),
                  onPressed: () {
                    startGame();
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void generateFood() {
    generateFoodType();

    food = Random().nextInt(119);
    if (fence.contains(food)) {
      food += 1;
    } else {
      food = food;
    }
  }

  void generateFoodType() {
    foodType = Random().nextInt(2);
  }
}
