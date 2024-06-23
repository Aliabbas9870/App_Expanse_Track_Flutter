import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  Future<void> createTransaction(String amount) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:3000/create-transaction'),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      final transaction = jsonDecode(response.body);
      print('Transaction Details: $transaction');
    } else {
      throw Exception('Failed to create transaction.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixIcon: Icon(Icons.money),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final amount = _amountController.text;
              if (amount.isNotEmpty) {
                createTransaction(amount);
              }
            },
            child: Text('Pay with JazzCash'),
          ),
        ],
      ),
    );
  }
}
