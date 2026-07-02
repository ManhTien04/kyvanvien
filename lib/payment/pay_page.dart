import 'package:flutter/material.dart';
import 'package:kyvanvien/payment/stripe_service.dart';
import 'package:kyvanvien/theme/colors.dart';

class PayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 65), // Add left padding to the title
          child: Text(
            'Thanh Toán',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Background Image
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/nen1.jpg'), // Đặt hình nền tương tự
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
                    'Xin chào, vui lòng chọn số lượng muốn mua',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  // Buttons with coin icons
                  _buildButton(context, '50  =  50.000 VND', Icons.diamond, 2.0),
                  _buildButton(context, '100  =  100.000 VND', Icons.diamond, 4.0),
                  _buildButton(context, '250  =  250.000 VND', Icons.diamond, 10.0),
                  _buildButton(context, '500  =  500.000 VND', Icons.diamond, 20.0),
                  SizedBox(height: 20),
                  // Footer text
                  Text(
                    'Kỳ Văn Viện là nền tảng mở dành cho các tác giả và độc giả đam mê truyện chữ,nơi các thành '
                        'viên có thể đọc và viết truyện miễn phí. Đọc truyện, viết truyện, sáng tác, sáng tạo, tương tác với nhau.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: primaryColor,
    );
  }

  // Reusable button widget
  Widget _buildButton(BuildContext context, String text, IconData icon, double actualAmount) {
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
        onPressed: () async {
          // Handle button press
          await StripeService.instance.makePayment(actualAmount, context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.blue,
            ),
            SizedBox(width: 5), // Add this line
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