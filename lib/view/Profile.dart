import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:kyvanvien/gift/gift_page.dart';
import 'package:kyvanvien/payment/pay_page.dart';
import 'package:kyvanvien/payment/stripe_service.dart';
import 'package:kyvanvien/theme/colors.dart';
import 'package:kyvanvien/view/user_setting.dart';
import 'package:kyvanvien/view/wallet_transaction.dart';
import 'LoginRegister/TokenHandler.dart';
import 'LoginRegisterPage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import 'history_gift.dart';
import 'new_password.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String imageUrl = ''; // Initial image URL
  String fullName = '';// Initial fullName
  String balance = '0';


  @override
  void initState() {
    super.initState();
    loadFullName();
    loadBalance();
    StripeService.instance.onPaymentSuccess = loadBalance; // Add this line
  }
  //balance
  Future<void> loadBalance() async {
    String? token = await getToken();
    if (token != null) {
      final parts = token.split('.');
      final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
      Map<String, dynamic> tokenData = json.decode(payload);
      final userId = tokenData['userId'];

      final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/user/$userId'));
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);
        setState(() {
          balance = userData['balance'].toString();
          imageUrl = userData['userImg'].toString();
        });
      } else {
        print('Failed to load balance');
      }
    }
  }

  Future<void> loadFullName() async {
    String? token = await getToken();
    if (token != null) {
      final parts = token.split('.');
      final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
      Map<String, dynamic> tokenData = json.decode(payload);
      setState(() {
        fullName = tokenData['fullName'];
      });
    }
  }

  void handleLogout() {
    logout().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginRegisterPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        title: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Trang Cá Nhân",
            style: TextStyle(color: titleColor), // Set the text color to #FFE8D6
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.notifications_active_sharp, color: extracolor,),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true, // Add this line to make the bottom sheet full height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)), // Adjust the corner radius here
                ),
                builder: (BuildContext context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.75, // Set the height to 3/4 of the screen height
                    child: Center(
                      child: Text('Thông báo'), // Replace this with the content you want to show
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 17.0),
                  child: InkWell(
                    onTap: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.getImage(source: ImageSource.gallery);

                      if (pickedFile != null) {
                        final bytes = await pickedFile.readAsBytes();
                        final base64Image = base64Encode(bytes);

                        setState(() {
                          imageUrl = 'data:image/png;base64,$base64Image';
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 45,
                      backgroundImage: imageUrl.isNotEmpty && imageUrl.contains('data:image/png;base64,')
                          ? MemoryImage(base64Decode(imageUrl.split(',').last)) // Use MemoryImage to create an image from bytes
                          : AssetImage('lib/images/anhuser.jpg'), // Use AssetImage for default image
                      // child: imageUrl.isEmpty
                      //     ? Icon(Icons.camera_alt_outlined) // Show camera icon if no image
                      //     : null,
                    ),
                  ),
                ),
                SizedBox(width: 20.0), // Increase the space to 40px
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            color: textColor, // Set the icon color to #FFFFFF
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            fullName, // Use the fullName from SharedPreferences
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.5,
                              color: textColor, // Set the text color to #FFFFFF
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.account_balance_wallet_rounded,
                            color: textColor, // Set the icon color to #FFFFFF
                          ), // Existing icon
                          SizedBox(width: 8.0), // Space between the icon and the text
                          Text('${balance != null ? double.parse(balance).toInt() : 0} ',
                            style: TextStyle(
                              fontSize: 20,
                              height: 1.5,
                              color: textColor, // Set the text color to #FFFFFF
                              // Increase line spacing
                            ),
                          ),
                          SizedBox(width: 1.0), // Add some space between the text and the new icon
                          Icon(Icons.diamond, color: Colors.blue[400],), // New diamond icon
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0), // Add some space between the rows
            Padding(
              padding: EdgeInsets.only(left: 17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Tài Khoản',
                    style: TextStyle(fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ), // Title
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => UserProfile()),
                  //     );
                  //   },
                  //   child: ListTile(
                  //     leading: Icon(Icons.manage_accounts,color: textColor,
                  //     ),
                  //     title: Text('Thông Tin Cá Nhân',
                  //       style: TextStyle(
                  //         color: textColor, // Set the text color to #FFFFFF
                  //       ),
                  //     ),
                  //     trailing: Icon(Icons.navigate_next,color: textColor,),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WalletTransaction()),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.receipt_long,color: textColor,),
                      title: Text('Lịch Sử Giao Dịch',
                        style: TextStyle(
                          color: textColor, // Set the text color to #FFFFFF
                        ),
                      ),
                      trailing: Icon(Icons.navigate_next,color: textColor,),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoryGift()),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.redeem ,color: textColor,),
                      title: Text('Lịch Sử Tặng Quà',
                        style: TextStyle(
                          color: textColor, // Set the text color to #FFFFFF
                        ),
                      ),
                      trailing: Icon(Icons.navigate_next, color: textColor,),
                    ),
                  ),

                  InkWell(
                    onTap: () async {
                      String? token = await getToken();
                      if (token != null) {
                        final parts = token.split('.');
                        final payload = B64urlEncRfc7515.decodeUtf8(parts[1]);
                        Map<String, dynamic> tokenData = json.decode(payload);
                        final userId = tokenData['userId'];

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NewPassword(userId: userId)),
                        );
                      }
                    },
                    child: ListTile(
                      leading: Icon(Icons.lock,color: textColor,),
                      title: Text('Đổi Mật Khẩu',
                        style: TextStyle(
                          color: textColor, // Set the text color to #FFFFFF
                        ),
                      ),
                      trailing: Icon(Icons.navigate_next,color: textColor,),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 17.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Thanh Toán',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: textColor,)), // StripeService.instance.makePayment();
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PayPage()),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.payments, color: textColor,),
                      title: Text('Mua Thêm Quà',
                        style: TextStyle(
                          color: textColor, // Set the text color to #FFFFFF
                        ),
                      ),
                      trailing: Icon(Icons.navigate_next, color: textColor,),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GiftPage()),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.currency_exchange, color: textColor,),
                      title: Text('Quy Đổi',
                        style: TextStyle(
                          color: textColor, // Set the text color to #FFFFFF
                        ),
                      ),
                      trailing: Icon(Icons.navigate_next, color: textColor,),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 90.0), // Remove the left and right padding here
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.0), // Add equal horizontal margin here
                  child: ElevatedButton(
                    onPressed: () {
                      handleLogout();
                    },
                    child: Row( // Use a Row widget to layout the Icon and Text widgets horizontally
                      mainAxisAlignment: MainAxisAlignment.center, // Center the children horizontally
                      children: <Widget>[
                        Icon(Icons.logout, color: Colors.white,), // Add the logout icon
                        SizedBox(width: 10.0), // Add some space between the icon and the text
                        Text(
                          'Đăng Xuất',
                          style: TextStyle(
                            color: Colors.white, // Set the text color to white
                          ),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey), // Set the button color to blue
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Set the border radius to 18
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],

        ),
      ),
    );
  }
}