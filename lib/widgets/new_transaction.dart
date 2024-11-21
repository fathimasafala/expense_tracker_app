
// ignore_for_file: library_private_types_in_public_api

import 'package:expense_test_app/bloc/transaction_bloc/transactions_bloc.dart';
import 'package:expense_test_app/presentation/models/transaction_model.dart';
import 'package:expense_test_app/utils/extensions/currency_extension.dart';
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

enum NewTransactionState {
  edit,
  add,
}

class NewTransaction extends StatefulWidget {
  final NewTransactionState state;
  final Transaction? transaction;

  const NewTransaction.add({
    super.key,
  })  : state = NewTransactionState.add,
        transaction = null;

  const NewTransaction.edit({
    super.key,
    @required this.transaction,
  })  : state = NewTransactionState.edit;

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DateTime _pickedDate;

  @override
  void initState() {
    super.initState();
    if (widget.state == NewTransactionState.edit) {
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _pickedDate = widget.transaction!.date;
      _dateController.text = DateFormat.yMMMd().format(_pickedDate);
    }
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final tBloc = context.read<TransactionsBloc>();
    final transaction = Transaction(
      id: widget.state == NewTransactionState.add
          ? const Uuid().v4()
          : widget.transaction!.id,
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      date: _pickedDate,
      createdOn: DateTime.now(),
    );
    if (widget.state == NewTransactionState.add) {
      tBloc.add(
        AddTransaction(transaction: transaction),
      );
    } else {
      tBloc.add(
        UpdateTransaction(transaction: transaction),
      );
    }
    Navigator.of(context).pop(transaction);
  }

  void _startDatePicker() {
    ThemeData(
        cardColor: Colors.black,
        canvasColor: StyleResources.primarycolor,
        primaryColor: Colors.white);
    showDatePicker(
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    background: Colors.black,
                    primary: StyleResources.primarycolor,
                    onPrimary: Colors.black,
                    onSurface: Colors.white,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: StyleResources.primarycolor,
                    ),
                  ),
                ),
                child: child!,
              );
            },
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.parse("2020-01-01 00:00:01Z"),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      _pickedDate = value;
      _dateController.text = DateFormat.yMMMd().format(_pickedDate);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.black,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            18,
          ),
        ),
        elevation: 8,
        child: Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(color: Colors.grey)),
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixText: getCurrencySymbol(),
                    prefixIconColor: Colors.yellow
                  ),
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  onFieldSubmitted: (_) => _startDatePicker(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Amount cannot be empty';
                    }
                    final price = double.tryParse(value);
                    if (price == null) {
                      return 'Please enter numbers only';
                    }
                    if (price <= 0) {
                      return 'Price must be greater than 0';
                    }
                    if (price >= 1000000) {
                      return 'Price must be less than 100,00,00';
                    }
                    return null;
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                    bottom: 30,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          readOnly: true,
                          controller: _dateController,
                          decoration: const InputDecoration(
                              labelText: 'Date',
                              labelStyle: TextStyle(color: Colors.grey)),
                          enableInteractiveSelection: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please pick a date';
                            }
                            return null;
                          },
                        ),
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                StyleResources.primarycolor)),
                        onPressed: _startDatePicker,
                        child: const Text(
                          'Choose Date',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              StyleResources.primarycolor)),
                      onPressed: _onSubmit,
                      child: Text(
                        widget.state == NewTransactionState.add
                            ? 'Add Transaction'
                            : 'Update',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
