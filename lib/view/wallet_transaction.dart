import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'dart:convert';
import 'package:kyvanvien/models/history_model.dart';
import 'package:kyvanvien/theme/colors.dart';
import 'package:kyvanvien/view/LoginRegister/TokenHandler.dart';

import '../models/wallet_transection.dart';

class WalletTransaction extends StatefulWidget {
  @override
  _WalletTransactionState createState() => _WalletTransactionState();
}

class _WalletTransactionState extends State<WalletTransaction> {
  List<WalletModel> transactions = []; // Change this line
  int? userId;

  @override
  void initState() {
    super.initState();
    _initializeUserId().then((_) {
      if (userId != null) {
        fetchWalletTransactions(userId!).then((walletTransactions) {
          setState(() {
            transactions = walletTransactions;
          });
        });
      }
    });
  }

  Future<void> _initializeUserId() async {
    String? token = await getToken();
    if (token != null) {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('invalid token');
      }

      final payloadPart = parts[1];
      final payloadString = B64urlEncRfc7515.decodeUtf8(payloadPart);
      final payload = jsonDecode(payloadString) as Map<String, dynamic>;

      userId = payload['userId']; // extract userId from the payload
    }
  }

  Future<List<WalletModel>> fetchWalletTransactions(int userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/transactions/list?userId=$userId'));

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => WalletModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load wallet transactions from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 50), // Add left padding to the title
          child: Text(
            'Lịch Sử Giao Dịch',
            style: TextStyle(color: titleColor), // Set the color of the title
          ),
        ),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: titleColor, // Set the color of the back button
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return TransactionItem(
            date: DateFormat('dd/MM/yyyy').format(transactions[index].createdAt),
            amount: transactions[index].amount.toString(),
            description: Utf8Decoder().convert(transactions[index].userName.codeUnits),
            time: DateFormat('HH:mm').format(transactions[index].createdAt),
          );
        },
      ),
      backgroundColor: primaryColor,
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String date;
  final String amount;
  final String description;
  final String time;

  const TransactionItem({
    required this.date,
    required this.amount,
    required this.description,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            date,
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.arrow_circle_down,
                    color: Colors.blue,
                    size: 24.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'Nạp Vào Ví',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "+ " + double.parse(amount).toInt().toString() + " Kim Cương",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            time,
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}