
// ignore_for_file: library_private_types_in_public_api

import 'package:expense_test_app/bloc/search_cubit/search_cubit.dart';
import 'package:expense_test_app/bloc/transaction_bloc/transactions_bloc.dart';
import 'package:expense_test_app/presentation/screens/search_screen.dart.dart';
import 'package:expense_test_app/presentation/screens/settings_screen.dart';
import 'package:expense_test_app/utils/notification_service.dart';
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:expense_test_app/widgets/month_line_chart.dart';
import 'package:expense_test_app/widgets/new_transaction.dart';
import 'package:expense_test_app/widgets/transaction_list.dart';
import 'package:expense_test_app/widgets/week_bar_chart.dart';
import 'package:expense_test_app/widgets/week_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/repositories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 46, 46, 46),
      context: context,
      builder: (_) => const NewTransaction.add(),
      isScrollControlled: true,
    );
  }
  bool _showBarChart = true;
  final NotificationService notificationService = NotificationService();
  @override
  Widget build(BuildContext context) {
    AppBar appbar = AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
      
        'Expense Tracker',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<SearchCubit>(
                  create: (context) => SearchCubit(
                    transactionsRepository:
                        context.read<TransactionsRepository>(),
                  )..loadAll(),
                  child: const SearchScreen(),
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
      ],
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appbar,
        
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                indicator: ShapeDecoration(
                  color: Colors.amber[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                dividerHeight: 0,

                labelColor: Colors.white,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Container(
                      height: 50,
                      width: 220,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: StyleResources.primarycolor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Tab(text: 'Weekly')),
                  Container(
                      height: 50,
                      width: 220,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5, color: StyleResources.primarycolor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Tab(text: 'Monthly')),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTransactionView(context, isWeekly: true),
                  _buildTransactionView(context, isWeekly: false),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _startAddNewTransaction(context),
          backgroundColor: StyleResources.primarycolor,
          foregroundColor: Colors.white,
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }

  Widget _buildTransactionView(BuildContext context, {required bool isWeekly}) {
    return SingleChildScrollView(
      child: BlocConsumer<TransactionsBloc, TransactionsState>(
        listener: (context, state) {
          if (state.status == TStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                state.error,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          if (state.status == TStatus.initial ||
              state.status == TStatus.loading) {
            return SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state.transactionsList.isEmpty) {
            return const Padding(
              padding: EdgeInsets.only(top: 200.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'No Transactions Added Yet!',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              SizedBox(
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.5,
                child: GestureDetector(
                  onHorizontalDragEnd: (details) {
                    int sensitivity = 8;
                    if (details.primaryVelocity! > sensitivity ||
                        details.primaryVelocity! < -sensitivity) {
                      setState(() {
                        _showBarChart = !_showBarChart;
                      });
                    }
                  },
                  child: _showBarChart
                      ? (isWeekly
                          ? WeekBarChart(transactions: state.transactionsList)
                          : MonthLineChart(
                              transactions: state.transactionsList))
                      : (isWeekly
                          ? WeekPieChart(transactions: state.transactionsList)
                          : MonthLineChart(
                              transactions: state.transactionsList)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Expenses',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: (MediaQuery.of(context).size.height -
                        AppBar().preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.5,
                child: TransactionList(
                  transactions: state.transactionsList.reversed.toList(),
                  deleteTransaction: (String transactionID) {
                    context.read<TransactionsBloc>().add(
                          RemoveTransaction(transactionID: transactionID),
                        );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
