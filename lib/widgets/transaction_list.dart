
import 'package:expense_test_app/models/transaction_model.dart';
import 'package:expense_test_app/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _transactions;
  final Function _deleteTransaction;

  TransactionList(
      {super.key, required List<Transaction> transactions,
      required Function deleteTransaction})
      : _transactions = List.from(transactions)
          ..sort((a, b) => b.date.compareTo(a.date)),
        _deleteTransaction = deleteTransaction;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == _transactions.length) {
          return const SizedBox(height: 75.0);
        }
        if (index != 0 && index % 3 == 0 && _transactions.length > 4) {
          return Column(
            children: [
              TransactionItem(
                  transaction: _transactions[index],
                  deleteTransaction: _deleteTransaction),
            ],
          );
        }
        return TransactionItem(
            transaction: _transactions[index],
            deleteTransaction: _deleteTransaction);
      },
      itemCount: _transactions.length + 1,
    );
  }
}
