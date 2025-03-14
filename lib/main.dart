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

  void shuffle() {
    cards.shuffle();
    notifyListeners();
  }

  void flip(int index){
    if (gameOver || cards[index].isFaceUp){
      return;
    }

    cards[index].isFaceUp = true;
    if(cardIndex1 == -1){
      cardIndex1 = index;
    }
    else{
      cardIndex2 = index;
    }
    notifyListeners();

  }

  bool checkGameOver(){
    for(Card card in cards){
      if(card.isFaceUp){
        return true;
      }
    }
    
    return false;

  }

  void checkMatch() async{
    if (cards[cardIndex1].index == cards[cardIndex2].index) {
      cardIndex1 = -1;
      cardIndex2 = -1;

      if (checkGameOver()) {
        gameOver = true;
        notifyListeners();
      }
    }
    else{
      cards[cardIndex1].isFaceUp = false;
      cards[cardIndex2].isFaceUp = false;



    }
  }
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Card Matching Game'),
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

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(''),
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
