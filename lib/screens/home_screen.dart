
import 'package:expense_test_app/screens/search_screen.dart.dart';
import 'package:expense_test_app/screens/settings_screen.dart';
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/app_blocs.dart';
import '../widgets/widgets.dart';
import '../repositories/repositories.dart';
import '../utils/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 46, 46, 46),
      context: context,
      builder: (_) => NewTransaction.add(),
      isScrollControlled: true,
    );
  }
  bool _showBarChart = true;
  final NotificationService notificationService = NotificationService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }
  @override
  Widget build(BuildContext context) {
    AppBar _appbar = AppBar(
      automaticallyImplyLeading: false,
      title: Text(
      
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
                  child: SearchScreen(),
                ),
              ),
            );
          },
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
        ),
      ],
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _appbar,
        
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(0),
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
                labelStyle: TextStyle(fontWeight: FontWeight.w700),
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
                      child: Tab(text: 'Weekly')),
                  Container(
                      height: 50,
                      width: 220,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 0.5, color: StyleResources.primarycolor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Tab(text: 'Monthly')),
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
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
          backgroundColor: StyleResources.primarycolor,
          foregroundColor: Colors.white,
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
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ));
          }
        },
        builder: (context, state) {
          if (state.status == TStatus.initial ||
              state.status == TStatus.loading) {
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state.transactionsList.isEmpty) {
            return Padding(
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
              Container(
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
              Padding(
                padding: const EdgeInsets.only(left: 16),
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
              Container(
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
   Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {},
    );

    _scheduleDailyReminderNotification();
  }

  Future<void> _scheduleDailyReminderNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_reminder_channel_id',
      'Daily Reminder',
      channelDescription: 'Channel for daily reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Reminder',
      'This is your daily reminder notification',
      _nextInstanceOfNineAM(),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfNineAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      9,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(Duration(days: 1));
    }

    return scheduledDate;
  }
}
