
import 'package:expense_test_app/bloc/search_cubit/search_cubit.dart';
import 'package:expense_test_app/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/transaction_bloc/transactions_bloc.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();

    return Scaffold(
      appBar: AppBar(
           iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Search Transactions',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 25),),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchError) {
            return Center(
              child: Text(state.error),
            );
          }

          if (state is SearchSuccess) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16.0),
                  child: TextField(
                  style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search by Title',
                      hintStyle: TextStyle(color: Colors.grey)
                    ),
                    onChanged: (keyword) {
                      searchCubit.search(keyword);
                    },
                  ),
                ),
                Expanded(
                  child: state.transactions.isEmpty
                      ? const Center(
                          child: Text('No Transactions To Show',style: TextStyle(color: Colors.white),),
                        )
                      : TransactionList(
                          transactions: state.transactions,
                          deleteTransaction: (String transactionID) {
                            context.read<TransactionsBloc>().add(
                                  RemoveTransaction(
                                      transactionID: transactionID),
                                );
                          },
                        ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
