part of 'transactions_bloc.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

class GetTransactions extends TransactionsEvent {}

class UpdateTransactions extends TransactionsEvent {
  final List<Transaction> transactions;

  const UpdateTransactions({
    required this.transactions,
  });

  @override
  List<Object> get props => [transactions];
}

class AddTransaction extends TransactionsEvent {
  final Transaction transaction;

  const AddTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];
}

class RemoveTransaction extends TransactionsEvent {
  final String transactionID;

  const RemoveTransaction({required this.transactionID});

  @override
  List<Object> get props => [transactionID];
}

class UpdateTransaction extends TransactionsEvent {
  final Transaction transaction;

  const UpdateTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];
}
