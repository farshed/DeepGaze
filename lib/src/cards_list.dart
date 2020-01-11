import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'constants.dart';

class CardList extends StatelessWidget {
  final Function onCardPress;
  CardList(this.onCardPress);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card("SSD MobileNet", onCardPress, ssd, 'bg-blue'),
        Card("YOLO", onCardPress, yolo, 'bg-red')
      ],
    );
  }
}

class Card extends StatelessWidget {
  final String title;
  final Function onCardPress;
  final String param;
  final String background;

  Card(this.title, this.onCardPress, this.param, this.background);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 20;
    return CupertinoButton(
      child: Container(
        height: width / 2.142,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage('assets/images/$background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: 'ProductSans',
              ),
            ),
          ),
        ),
      ),
      onPressed: () => onCardPress(param),
    );
  }
}
