import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';


class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {

  List<String> emojis = ['🦊''🦁''🦝''🐼''🐻''🐸''🐰'];
  List<String> gameCards = [];
  List<bool> flipped = [];
  List<int> selected = [];

  int score = 0;
  bool busy = false;

  @override

  void initState(){
    super.initState();
    startGame();
  }

  void startGame(){
    final random = Random();
    final pairs = [...emojis,...emojis];
    pairs.shuffle(random);

    setState(() {
      gameCards = pairs;
      flipped = List.generate(pairs.length, (index) => false);
      selected.clear();
      score = 0;
      busy = false;
    });
  }

  void flipCard(int index){
    if(busy || flipped[index]) return;


    setState(() {
      flipped[index] = true;
      selected.add(index);
    });

    if(selected.length == 2){
      busy = true;
      Timer(Duration(seconds: 1),(){
        checkMatch();
      });
    }
  }

  void checkMatch(){
    if(gameCards[selected[0]] != gameCards[selected[1]]){
      setState(() {
        flipped[selected[0]] = false;
        flipped[selected[1]] = false;
      });
    }else{
      setState(() {
        score++;
      });
    }
    setState(() {
      selected.clear();
    });

    if(flipped.every((card) => card)){
      showWinDialog();
    }
  }

  void showWinDialog(){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("🎉 You Won!"),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
              startGame();
            }, child: Text('Play Again!'))
          ],
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final gridCount = 4;

    return Scaffold(
      appBar: AppBar(
        title: Text('🧠 Memory Match Game'),
        centerTitle: true,
      ),
      backgroundColor: Colors.teal.shade50,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Score: $score'),
          SizedBox(height: 20,),
          Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10
                  ),
                  itemCount: gameCards.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: () => flipCard(index),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: flipped[index] ? Colors.white : Colors.teal,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(2, 2)
                            )
                          ],
                        ),
                        child: Center(
                          child: flipped[index]
                          ?Text(
                            gameCards[index],
                            style: TextStyle(
                              fontSize: 32,color: Colors.black
                            ),
                          ) : Text('?',
                            style: TextStyle(
                              fontSize: 32,color: Colors.white
                            ),
                          ),
                        ),

                      ),
                    );
                  },
              ),
          ),
          ElevatedButton.icon(
              onPressed: startGame,
              label: Text('Restart'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 15
              ),
            ),
          ),
          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
