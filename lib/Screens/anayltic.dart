import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Transaction {
  final String title;
  final double credit;
  final String filling;
  final double amount;
  final Timestamp timestamp;

  Transaction({
    required this.title,
    required this.credit,
    required this.filling,
    required this.amount,
    required this.timestamp,
  });

  factory Transaction.fromDocument(DocumentSnapshot doc) {
    return Transaction(
      title: doc['title'],
      credit: doc['credit'],
      filling: doc['filling'],
      amount: doc['amount'],
      timestamp: doc['timestamp'],
    );
  }
}

class AnalyticsPage extends StatefulWidget {
  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  List<Transaction> transactions = [];

  Future<void> _refreshData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Data').get();
      transactions = snapshot.docs
          .map((doc) => Transaction.fromDocument(doc))
          .toList();
      setState(() {});
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Color(0xff38D3AE),
      ),
      body: transactions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: _buildTransactionList()),
                Expanded(child: _buildTransactionChart()),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
        child: Icon(Icons.refresh),
        backgroundColor: Color(0xff38D3AE),
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        Transaction transaction = transactions[index];
        return ListTile(
          title: Text(transaction.title),
          subtitle: Text(transaction.filling),
          trailing: Text('\$${transaction.amount.toStringAsFixed(2)}'),
        );
      },
    );
  }

  Widget _buildTransactionChart() {
    Map<String, double> dataMap = {};
    for (var transaction in transactions) {
      dataMap[transaction.title] =
          (dataMap[transaction.title] ?? 0) + transaction.amount;
    }

    List<PieChartSectionData> sections = dataMap.entries
        .map((entry) => PieChartSectionData(
              title: entry.key,
              value: entry.value,
              color: Colors.primaries[
                  dataMap.keys.toList().indexOf(entry.key) % Colors.primaries.length],
            ))
        .toList();

    return PieChart(
      PieChartData(sections: sections),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnalyticsPage(),
  ));
}
