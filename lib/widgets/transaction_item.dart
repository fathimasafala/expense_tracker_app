
import 'package:expense_test_app/models/transaction_model.dart';
import 'package:expense_test_app/screens/details_screen.dart';
import 'package:expense_test_app/utils/extensions/currency_extension.dart';
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({
    Key? key,
    required Transaction transaction,
    required Function deleteTransaction,
  })  : _transaction = transaction,
        _deleteTransaction = deleteTransaction,
        super(key: key);

  final Transaction _transaction;
  final Function _deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(width: 0.5, color: StyleResources.primarycolor)),
      child: Dismissible(
        key: Key(_transaction.id),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: EdgeInsets.only(right: 20.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              size: 30.0,
            ),
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _deleteTransaction(_transaction.id);
        },
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: StyleResources.primarycolor, width: 1.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Colors.black,
                title: Text(
                  "Confirm",
                  style: TextStyle(color: StyleResources.primarycolor),
                ),
                content: Text(
                  "Are you sure you wish to delete this transaction?",
                  style: TextStyle(color: Colors.white),
                ),
                actions: <Widget>[
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              StyleResources.primarycolor)),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        "DELETE",
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            StyleResources.primarycolor)),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(transaction: _transaction),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: StyleResources.primarycolor,
                  border: Border.all(
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  '${_transaction.amount.parseCurrency()}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _transaction.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      DateFormat.yMMMd().format(_transaction.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
