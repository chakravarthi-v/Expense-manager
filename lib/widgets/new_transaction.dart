import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class New_transaction extends StatefulWidget {
  final Function add;

  New_transaction(this.add);

  @override
  _New_transactionState createState() => _New_transactionState();
}

class _New_transactionState extends State<New_transaction> {
  final title = TextEditingController();

  final amount = TextEditingController();
  DateTime _selectedDate;
  void _submit() {
    final a = title.text;
    final b = double.parse(amount.text);
    if (a.isEmpty || b <= 0 || _selectedDate == null) {
      return;
    }
    widget.add(
      a,
      b,
      _selectedDate,
    );
    Navigator.of(context).pop();
  }

  void _presentDatePIcker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((picked) {
      if (picked == null) {
        return;
      }
      setState(() {
        _selectedDate = picked;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(top: 10,left: 10,right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom+10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: title,
                onSubmitted: (_) => _submit(),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: amount,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submit(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? "No date chosen!"
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: _presentDatePIcker,
                        child: Text(
                          'choose date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
              RaisedButton(
                onPressed: _submit,
                color: Theme.of(context).primaryColor,
                child: Text('Add Transaction'),
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
