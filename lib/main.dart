import 'package:flutter/material.dart';
import 'package:try_app/transaction_list.dart';
import 'package:try_app/widgets/chart.dart';
import 'package:try_app/widgets/new_transaction.dart';
import './models/transaction.dart';
import 'database/databaseProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Personal Expenses",
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool load=true;
   List<Transaction> _transactionUsers = [
    /*Transaction(
      id: 't1',
      title: 'new shoes',
      amount: 69.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'old shoes',
      amount: 780,
      date: DateTime.now(),
    ),*/
  ];

  List<Transaction> get _recentTran {
    return _transactionUsers.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }
bool _showChart=false;

  //function to add transaction in the list as well as SQLite
  void _addNewTransaction(String txtile, double txamount, DateTime dateer) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txtile,
        amount: txamount,
        date: dateer);
    setState(() {
      _transactionUsers.add(newTx);
      DatabaseProvider.db.addTranasactionToDatabase(newTx);
    });
  }
//Adding transaction through modal sheet
  void _startAddNewTransaction(
    BuildContext ctx,
  ) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: New_transaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
          );
        });
  }
//deleting transaction in list and SQLite
  void _delettran(String id) {
    setState(() {
      _transactionUsers.removeWhere((tx) => tx.id == id);
      DatabaseProvider.db.deleteTransaction(id);
    });
  }

  //adding all the transaction data into current list
  void Data() async{
    List data=await DatabaseProvider.db.getAllTransaction();
    _transactionUsers=_transactionUsers+data;
    setState(() {
      load=false;
    });

  }
  @override
  void initState() {
    Data();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mediaquery=MediaQuery.of(context);
    final isLandscape=mediaquery.orientation==Orientation.landscape;
    final appbar = AppBar(
      title: Text('Expense Tracker'),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _startAddNewTransaction(context)),
      ],
    );
    final transactionList=Container(
        height: (mediaquery.size.height-appbar.preferredSize.height-mediaquery.padding.top)*0.7,
        child: TransactionList(_transactionUsers, _delettran));
    return Scaffold(
      appBar: appbar,
      body: load?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if(isLandscape)Row(mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Text('Show chart'),
              Switch(value: _showChart,onChanged: (val) {
                setState(() {
                  _showChart=val;
                });
              },),
            ],),

            if(!isLandscape)Container(
              height: (mediaquery.size.height-appbar.preferredSize.height-mediaquery.padding.top)*0.3,
              child: Chart(_recentTran)),
            if(!isLandscape)transactionList,
            if(isLandscape)_showChart
            ?Container(
              height: (mediaquery.size.height-appbar.preferredSize.height-mediaquery.padding.top)*0.7,

                //Calling of chart widget which holds the sum of previous 7 day transactions
                child: Chart(_recentTran))
                :transactionList,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat ,

      //FloatingButton-which adds calls the bottomModal sheet
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context)),
    );
  }
}
