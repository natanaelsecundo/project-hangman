import 'package:flutter/material.dart';
import 'package:forca/repository/alphabet_repository.dart';
import 'package:forca/views/win.dart';
import '../repository/word_repository.dart';
import '../ui/colors.dart';
import '../ui/widget/figure_image.dart';
import '../ui/widget/lettter.dart';
import '../utils/game.dart';
import 'lose.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool visible() {
    return Game.letterList.every((element) => element.hidden == false);
  }

  String word = WordRepository.wordList[0].word!.toUpperCase();
  String tip = WordRepository.wordList[0].tip!.toUpperCase();
  bool correct = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: Text(
          "Hangman",
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'super',
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColor.primaryColorDark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                figureImage(Game.tries >= 0, "assets/gallows.png"),
                figureImage(Game.tries >= 1, "assets/head.png"),
                figureImage(Game.tries >= 2, "assets/body.png"),
                figureImage(Game.tries >= 3, "assets/ra.png"),
                figureImage(Game.tries >= 4, "assets/la.png"),
                figureImage(Game.tries >= 5, "assets/rl.png"),
                figureImage(Game.tries >= 6, "assets/ll.png")
              ],
            ),
          ),
          Container(
            height: 60,
            width: 250,
            decoration: BoxDecoration(
              color: AppColor.containerColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: (Game.tries >= 5)
                  ? Text(
                      tip,
                      style: TextStyle(fontSize: 24, color: AppColor.wordColor),
                    )
                  : Text(
                      'Tip',
                      style: TextStyle(fontSize: 24, color: AppColor.wordColor),
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: Game.letterList = word
                .split('')
                .map((e) => Letter(
                    character: e.toUpperCase(),
                    hidden: !Game.selectChar.contains(e.toUpperCase())))
                .toList(),
          ),
          SizedBox(
            height: 12,
          ),
          (visible())
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColor.primaryColorDark,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Win()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Continue.',
                          style: TextStyle(
                              fontSize: 25,
                              color: AppColor.wordColor,
                              fontFamily: 'BreeSerif')),
                    ),
                  ),
                )
              : SizedBox(),
          SizedBox(
            width: double.infinity,
            height: 250.0,
            child: GridView.count(
              crossAxisCount: 10,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: EdgeInsets.all(8.0),
              children: AlphabetRepository.alph.map((e) {
                return RawMaterialButton(
                  onPressed: () {
                    if (!Game.selectChar.contains(e)) {
                      setState(() {
                        Game.selectChar.add(e);
                        print(Game.selectChar);

                        if (visible()) {
                          Game.selectChar = [];
                          Game.tries = 0;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => Win()));
                        }

                        if (!word.split('').contains(e.toUpperCase())) {
                          Game.tries++;
                          if (Game.tries == 6) {
                            Game.selectChar = [];
                            Game.tries = 0;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Lose()));
                          }
                        }
                      });
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    e,
                    style: TextStyle(
                        color: AppColor.wordColor,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'BreeSerif'),
                  ),
                  fillColor: Game.selectChar.contains(e)
                      ? AppColor.selectedColor
                      : AppColor.unselectedColor,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
