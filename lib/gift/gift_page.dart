import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:kyvanvien/models/gitf_page_model.dart';
import 'package:kyvanvien/view/LoginRegister/TokenHandler.dart';
import 'package:kyvanvien/view/menu_page.dart';

import '../theme/colors.dart';

class GiftPage extends StatefulWidget {
  @override
  _GiftPageState createState() => _GiftPageState();
}

class _GiftPageState extends State<GiftPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Change the length to 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: titleColor),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MenuPage()),
            );
          },
        ),
        automaticallyImplyLeading: false, // This line removes the back button
        title: Text(
          'Đổi Quà',
          style: TextStyle(
            color: titleColor,
          ),
        ),
        centerTitle: true, // This line centers the title
        backgroundColor: primaryColor, // Set the AppBar background color
        bottom: TabBar(
          controller: _tabController,
          labelColor: titleColor,
          indicatorColor: titleColor,
          tabs: [
            Tab(text: 'Đổi Quà',),
            Tab(text: 'Lịch Sử',),
            // Remove the second tab
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            ExchangeGiftPage(),
            HistoryExchangePage(),
            // Remove the second tab's content
          ],
        ),
      ),
    );
  }
}








class HistoryExchangePage extends StatefulWidget {
  @override
  _HistoryExchangePageState createState() => _HistoryExchangePageState();
}

class _HistoryExchangePageState extends State<HistoryExchangePage> {
  List<GiftPageModel> transactions = [];
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

  Future<List<GiftPageModel>> fetchWalletTransactions(userId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/gift-request/user/$userId'));

    print('Response body: ${response.body}'); // In ra nội dung phản hồi

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => GiftPageModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load wallet transactions from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return TransactionItem(
            date: DateFormat('dd/MM/yyyy').format(transactions[index].requestDate),
            amount: transactions[index].cardValue.toString(),
            description: transactions[index].adminResponse != null ? Utf8Decoder().convert(transactions[index].adminResponse!.codeUnits) : '',
            status: Utf8Decoder().convert(transactions[index].status.codeUnits),
            time: DateFormat('HH:mm').format(transactions[index].requestDate),
          );
        },
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String date;
  final String amount;
  final String description;
  final String status;
  final String time;

  const TransactionItem({
    required this.date,
    required this.amount,
    required this.description,
    required this.status,
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
                  Text(
                    'Trạng Thái:  ' + status,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                double.parse(amount).toInt().toString() + " Viettel",
                style: TextStyle(
                  color: Colors.red[300],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            'Note: ' +description,
            style: TextStyle(
              color: Colors.grey[700],
            ),
          ),
          // SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(), // Widget trống để đẩy Text sang phải
              Text(
                time,
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}












class ExchangeGiftPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Background Image
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/nen3.jpg'), // Đặt hình nền tương tự
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Xin chào, vui lòng chọn quà muốn đổi.'
                      ' Lưu ý: Quà chịu triết khấu tới 10% dựa trên số kim cương quy đổi.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                // Buttons with coin icons
                _buildButton(context, '12   =  10k Viettel', Icons.diamond, 10000, 12),
                _buildButton(context, '24   =  20k Viettel', Icons.diamond, 20000, 24),
                _buildButton(context, '60   =  50k Viettel', Icons.diamond, 50000, 60),
                _buildButton(context, '120  =  100k Viettel', Icons.diamond, 100000, 120),
                _buildButton(context, '240  =  200k Viettel', Icons.diamond, 200000, 240),
                _buildButton(context, '600  =  500k Viettel ', Icons.diamond, 500000, 600),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Reusable button widget
  Widget _buildButton(BuildContext context, String text, IconData icon, double cardValue, double diamondsUsed) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.blue, width: 1),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Xác nhận'),
                content: Text('Bạn có chắc chắn muốn đổi quà?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Hủy'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Xác nhận'),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      // Read the token
                      String? token = await getToken();
                      if (token != null) {
                        // Extract the userId
                        final parts = token.split('.');
                        if (parts.length != 3) {
                          throw Exception('invalid token');
                        }
                        final payloadPart = parts[1];
                        final payloadString = B64urlEncRfc7515.decodeUtf8(payloadPart);
                        final payload = jsonDecode(payloadString) as Map<String, dynamic>;
                        int? userId = payload['userId'];

                        // Make a POST request to the API
                        if (userId != null) {
                          final data = <String, dynamic>{
                            'userId': userId,
                            'cardValue': cardValue.toInt(), // Convert to int
                            'diamondsUsed': diamondsUsed.toInt(), // Convert to int
                          };

                          // print('Sending data to API: $data'); // Print the data

                          final response = await http.post(
                            Uri.parse('http://10.0.2.2:8080/api/v1/gift-request?userId=$userId&cardValue=${cardValue.toInt()}&diamondsUsed=${diamondsUsed.toInt()}'),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                          );

                          // print('Response from API: ${response.body}'); // Print the response body

                          if (response.statusCode == 200) {
                            // Handle successful response
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Thành Công.Chúng Tôi Đã Gửi Mail Xác Nhận Đến Bạn!')),
                            );

                          } else {
                            // Handle error
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đổi Quà Thất Bại! Vui Lòng Kiểm Tra Số Dư!')),
                            );
                          }
                        }
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.blue,
            ),
            SizedBox(width: 5),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}