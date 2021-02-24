import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:try_app/widgets/chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  Chart(this.recentTransaction);
  //generating the last 7 days transactions
  List<Map<String, Object>> get groupedTransactionValue {
    return List.generate(7, (index) {
      final weekday = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalsum = 0.0;
      for (int i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].date.day == weekday.day &&
            recentTransaction[i].date.month == weekday.month &&
            recentTransaction[i].date.year == weekday.year) {
          totalsum += recentTransaction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amout': totalsum
      };
    }).reversed.toList();
  }
  //getting total amount
  double get maxSpend {
    return groupedTransactionValue.fold(0.0, (sum, item) {
      return sum + item['amout'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValue.map((dat) {
            return Flexible(
              fit: FlexFit.tight,
              //calling chartBar function
              child: ChartBar(dat['day'], dat['amout'],
                  maxSpend == 0.0 ? 0.0 : (dat['amout'] as double) / maxSpend),
            );
          }).toList(),
        ),
      ),
    );
  }
}
