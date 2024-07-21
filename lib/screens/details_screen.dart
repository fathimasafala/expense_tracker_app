

import 'package:expense_test_app/utils/extensions/currency_extension.dart';
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/widgets.dart';
import '../models/models.dart';

class DetailsScreen extends StatelessWidget {
  final Transaction _transaction;
  const DetailsScreen({Key? key, required Transaction transaction})
      : _transaction = transaction,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Details',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 25),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 54.0),
          child: Column(
            children: [
              DetailsRow(title: 'Title:', content: _transaction.title),
              DetailsRow(
                  title: 'Amount:',
                  content:
                      '${getCurrencySymbol()} ${_transaction.amount.toStringAsFixed(2)},',),
              DetailsRow(
                  title: 'Date:',
                  content:
                      '${DateFormat.yMMMMEEEEd().format(_transaction.date)}'),
              DetailsRow(
                  title: 'Added:',
                  content:
                      '${DateFormat.yMMMEd().format(_transaction.createdOn)} ${DateFormat.jm().format(_transaction.createdOn)}'),
           
            
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: StyleResources.primarycolor,
        onPressed: () async {
          final editedTransaction = await showModalBottomSheet(
           backgroundColor: const Color.fromARGB(255, 46, 46, 46),
            context: context,
            builder: (_) => NewTransaction.edit(
              transaction: _transaction,
            ),
            isScrollControlled: true,
          );
          if (editedTransaction != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailsScreen(transaction: editedTransaction),
              ),
            );
          }
        },
        child: Icon(Icons.edit,color: Colors.black,size: 30,),
      ),
    );
  }
}

class DetailsRow extends StatelessWidget {
  final String title;
  final String content;

  const DetailsRow({
    Key? key,
   required this.title,
   required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            margin: EdgeInsets.only(right: 8.0),
            child: Text(
              title,
              style: TextStyle(
                  color:StyleResources.primarycolor,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }
}
