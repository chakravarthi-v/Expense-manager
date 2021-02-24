import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendamt;
  final double spendpercent;
  ChartBar(this.label, this.spendamt, this.spendpercent);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx,constraints) => Column(
        children: <Widget>[
          //which shows the total amount spend on that day
          Container(
              height: constraints.maxHeight*0.15,
              child: FittedBox(child: Text("₹${spendamt.toStringAsFixed(0)}"))),
          SizedBox(height: constraints.maxHeight*0.05),
          //Bar w=which shows tha amount spend
          Container(
              height: constraints.maxHeight*0.6,
              width: 10,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendpercent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              )),
          SizedBox(height: constraints.maxHeight*0.11),
          //size of days being set
          Container(height: constraints.maxHeight*0.09,
              child: FittedBox(
                  child: Text(label,style: TextStyle(height:1),))),
        ],
      ),);
  }
}
