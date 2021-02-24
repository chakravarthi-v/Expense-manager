import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transac;
  final Function del;
  TransactionList(this.transac, this.del);

  @override
  Widget build(BuildContext context) {
    return transac.isEmpty
    ?LayoutBuilder(builder: (stx,constraints) => Column(
        children: <Widget>[
          Text("No transactions added yet"),
          SizedBox(
            height: 10,
          ),
          //image if any transaction haven't done
          Container(
            height:constraints.maxHeight*0.6,
            child: Image.asset(
              'assets/Images/waiting.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),)
    //list view of all the transaction done
        : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child:
                            FittedBox(child: Text("₹${transac[index].amount}")),
                      ),
                    ),
                    title: Text(transac[index].title,
                        style: Theme.of(context).textTheme.title),
                    subtitle:
                        Text(DateFormat.yMMMMd().format(transac[index].date)),
                    trailing:
                    MediaQuery.of(context).size.width>460
                    ? FlatButton.icon(onPressed: () => del(transac[index].id) ,
                        icon: Icon(Icons.delete),
                        label: Text("Delete"),
                        textColor: Colors.red)
                        :IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.delete),
                        onPressed: () => del(transac[index].id))
                  ),
                );
              },
              itemCount: transac.length,
            );
  }
}
