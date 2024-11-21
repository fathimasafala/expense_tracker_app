// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:expense_test_app/presentation/models/transaction_model.dart';
import 'package:flutter/material.dart';

import '../../presentation/repositories/transactions_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final TransactionsRepository _transactionsRepository;

  SearchCubit({required TransactionsRepository transactionsRepository})
      : _transactionsRepository = transactionsRepository,
        super(SearchInitial());

  void loadAll() async {
    try {
      final transactions = await _transactionsRepository.getAllTransactions();
      emit( SearchSuccess(transactions: transactions));
    } catch (e) {
      emit(SearchError(error: e.toString()));
    }
  }

  void search(String keyword) async {
   if (keyword.isEmpty) {
      emit(SearchLoading());
      loadAll();
      return;
    }

    try {
      final list =
          await _transactionsRepository.filterTransactions(keyword: keyword);
      emit(SearchSuccess(transactions: list));
    } catch (e) {
      emit(SearchError(error: e.toString()));
    }
  }
}
