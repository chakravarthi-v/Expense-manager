import 'package:flutter/material.dart';
//transaction class to store data
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  Transaction({@required this.id,
    @required this.title,
    @required this.amount,
    @required this.date});
  //Adding Transaction scheme data for SQLite
  Map<String, dynamic> toMap() =>
      {
        "ids": id,
        "title":title,
        "amount":amount,
        "date":date.toIso8601String(),
      };
  //Mapping Transaction date to list
  factory Transaction.fromMap(Map<String,dynamic>json)=>
      new Transaction(id: json["ids"], title:json["title"], amount:json["amount"], date:DateTime.parse(json["date"]));


}


