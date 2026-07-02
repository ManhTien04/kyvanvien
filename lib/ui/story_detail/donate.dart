import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:kyvanvien/payment/pay_page.dart';
import 'package:kyvanvien/payment/stripe_service.dart';
import 'package:kyvanvien/theme/colors.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../view/LoginRegister/TokenHandler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Donate extends StatefulWidget {
  final int storyId;

  Donate({required this.storyId});

  @override
  State<Donate> createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  String balance = '0';
  String userId = '';
  final TextEditingController giftAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadBalance();
    StripeService.instance.onPaymentSuccess = loadBalance;
  }

  Future<void> loadBalance() async {
    String? token = await getToken();
    if (token != null) {
      final parts = token.split('.');
      final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
      Map<String, dynamic> tokenData = json.decode(payload);
      userId = tokenData['userId'].toString();

      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);
        setState(() {
          balance = userData['balance'].toString();
        });
      } else {
        print('Failed to load balance');
      }
    }
  }

  Future<void> donateGift() async {
    try {
      if (userId.isEmpty || widget.storyId == null || giftAmountController.text.isEmpty) {
        // Show a SnackBar with an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng nhập số kim cương và thử lại'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      int userIdInt = int.parse(userId);
      int storyIdInt = widget.storyId;
      double amountDouble = double.parse(giftAmountController.text);

      if (amountDouble <= 0.9) {
        // Show a SnackBar with an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng chọn số kim cương phù hợp'),
            duration: Duration(seconds: 2),
          ),
        );
        // Clear the text field
        giftAmountController.clear();
        return;
      }

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/api/v1/history-gift/gift?userId=$userIdInt&amount=$amountDouble&storyId=$storyIdInt'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        print('Gift donated successfully');
        await loadBalance(); // Reload balance after successful donation

        // Clear the text field
        giftAmountController.clear();

        // Show a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bạn đã donate thành công'),
            duration: Duration(seconds: 2),
          ),
        );
        await Future.delayed(Duration(seconds: 1));
        Navigator.pop(context);

      } else if (response.statusCode == 400 && response.body == 'Số dư trong ví không đủ') {
        print('Failed to donate gift');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Show a SnackBar with an error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Vui lòng nạp thêm kim cương'),
            duration: Duration(seconds: 2),
          ),
        );
        // Clear the text field
        giftAmountController.clear();

        // Navigate to PayPage
        await Future.delayed(Duration(seconds: 1));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PayPage()),
        );
      } else {
        print('Failed to donate gift');
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Bạn còn: ${balance != null ? double.parse(balance).toInt().toString() : '0'}",
                style: TextStyle(
                  color: textColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5,),
              Icon(
                Icons.diamond,
                color: Colors.blue[400],
                size: 25,
              ),
              SizedBox(width: 5,),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PayPage()),
                  );
                },
                child: Icon(
                  Icons.add_circle,
                  color: Colors.grey[300],
                  size: 25,
                ),
              ),
            ],
          ),

          SizedBox(height: 30,),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Tặng Quà :",
              style: TextStyle(
                color: textColor,
                fontSize: 18,
              ),
            ),
          ),

          SizedBox(height: 10,),

          TextField(
            controller: giftAmountController,
            style: TextStyle(
              color: titleColor,
              fontSize: 24,
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: titleColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: titleColor),
              ),
              hintText: 'Nhập vào đây',
              hintStyle: TextStyle(
                color: extracolor,
              ),
            ),
            enableInteractiveSelection: false,
          ),

          SizedBox(height: 20,),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '( Vui lòng nhập số lượng quà tặng phù hợp )',
              style: TextStyle(
                color: extracolor,
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(height: 50,),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: donateGift,
              style: ElevatedButton.styleFrom(
                backgroundColor: titleColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                "Tặng quà",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}