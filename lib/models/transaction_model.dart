import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final DateTime createdOn;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.createdOn,
  });

  @override
  List<Object> get props {
    return [
      id,
      title,
      amount,
      date,
      createdOn,
    ];
  }

  Transaction copyWith({
    required String id,
    required String title,
    required double amount,
    required DateTime date,
    required DateTime createdOn,
    required String imagePath,
  }) {
    return Transaction(
      id: id,
      title: title,
      amount: amount,
      date: date,
      createdOn: createdOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount.toString(),
      'date': date.millisecondsSinceEpoch,
      'createdOn': createdOn.millisecondsSinceEpoch,
    };
  }

  factory Transaction.fromMap(Map<dynamic, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: double.tryParse(map['amount']) ?? 0.0,
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      createdOn: DateTime.fromMillisecondsSinceEpoch(map['createdOn']),
    );
  }

  @override
  bool get stringify => true;
}
