import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class Card {
  final int index;
  bool isFaceUp;

  Card({required this.index, this.isFaceUp = false});
}

class GameState extends ChangeNotifier {
  late List<Card> cards;
  bool gameOver = false;
  int cardIndex1 = -1;
  int cardIndex2 = -1;

  GameState() {
    cards = List.generate(16, (index) {
      return Card(index: index % 8); 
    });
    shuffle();
  }

    String getImagePath(int index){
    String file = "";

    if(cards[index].index == 0){
      file = "king_of_hearts2.png";
    }
    if(cards[index].index == 1){
      file = "ace_of_hearts.png";
    }
    if(cards[index].index == 2){
      file = "2_of_hearts.png";
    }
    if(cards[index].index == 3){
      file = "3_of_hearts.png";
    }
    if(cards[index].index == 4){
      file = "4_of_hearts.png";
    }
    if(cards[index].index == 5){
      file = "5_of_hearts.png";
    }
    if(cards[index].index == 6){
      file = "6_of_hearts.png";
    }
    if(cards[index].index == 7){
      file = "7_of_hearts.png";
    }
    if(cards[index].index == 8){
      file = "5_of_hearts.png";
    }

    return "assets/images/$file";
  }

  void shuffle() {
    cards.shuffle();
    notifyListeners();
  }

  void flip(int index){
    if (gameOver){
      return;
    }
    if(cards[index].isFaceUp == true){
      cards[index].isFaceUp = false;
    }
    if(cards[index].isFaceUp == false){
      cards[index].isFaceUp = true;
      if(cardIndex1 == -1){
        cardIndex1 = index;
      }
      else{
        cardIndex2 = index;
        checkMatch();
      }
    }
    notifyListeners();

  }

  bool checkGameOver(){
    for(Card card in cards){
      if(card.isFaceUp == false){
        return false;
      }

    }
    return true;

  }

  void checkMatch() async {
    if (cards[cardIndex1].index == cards[cardIndex2].index) {
      cardIndex1 = -1;
      cardIndex2 = -1;
      if (checkGameOver()) {
        gameOver = true;
        notifyListeners();
      }
    } 
    else {
      await Future.delayed(Duration(seconds: 1), () {
        cards[cardIndex1].isFaceUp = false;
        cards[cardIndex2].isFaceUp = false;
        cardIndex1 = -1;
        cardIndex2 = -1;
        notifyListeners();
      });
    }

    notifyListeners();
  }

  void reset(){
    for(Card card in cards){
      card.isFaceUp = false;
      cards.shuffle();
      gameOver = false;
      cardIndex1 = -1;
      cardIndex2 = -1;
      notifyListeners();
    }
  }

  
}

class CardBlock extends StatelessWidget{
  final int index;

  CardBlock({required this.index});

  @override
  Widget build(BuildContext context) {
    final card = context.watch<GameState>().cards[index]; 
    final gameState = context.watch<GameState>();

    return GestureDetector(
      onTap: () => context.read<GameState>().flip(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: card.isFaceUp ? Colors.white : Colors.red,
        ),
        child: Center(
          child: card.isFaceUp
              ? Image.asset(gameState.getImagePath(index), fit: BoxFit.cover)
              : Icon(Icons.help_outline, color: Colors.white),
        ),
      ),
    );
  }
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: 'Card Matching Game Game',
        theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white
        ),
        home: MyHomePage(title: "Card Matching Game",),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    final gameState = context.watch<GameState>();

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (gameState.gameOver) Padding(padding: const EdgeInsets.all(16.0), child: Text('You Won!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, ),),),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, 
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: gameState.cards.length,
                itemBuilder: (context, index) {
                  return CardBlock(index: index);
                },
              ),
            ),
            ElevatedButton(
              onPressed: gameState.reset, 
              child: Row(mainAxisAlignment:MainAxisAlignment.center, children: [
                Icon(Icons.refresh_outlined, size: 40,),
                Text("Reset", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),)]
              )
            )
          ],
        ),
      ),
    );
  }
}