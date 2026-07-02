import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:kyvanvien/payment/payment.dart';
import 'package:kyvanvien/view/LoginRegister/TokenHandler.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();
  Function? onPaymentSuccess;

  Future<void> makePayment(double amount, BuildContext context) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        amount, "usd",
      );
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentClientSecret,
            merchantDisplayName: "Ky Van Vien",
          ),
      );
      await _processPayment(amount: amount, context: context);
    } catch (e) {
      print(e);
    }
  }
  Future<String?>_createPaymentIntent(double amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount':int.parse(_calculateAmount(amount)),
        'currency': currency,
      };
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        data: data,
        options: Options(contentType: Headers.formUrlEncodedContentType,
          headers: {
          "Authorization": "Bearer $stripeSecretKey",
          "Content-Type": "application/x-www-form-urlencoded",
          },
          ),
        );
      if (response.data != null) {
        return response.data['client_secret'];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }



  Future<void> _processPayment({required double amount,required BuildContext context}) async {
    try {
      // In ra trước khi gọi payment sheet
      print("Đang hiển thị Payment Sheet...");
      await Stripe.instance.presentPaymentSheet();  // Hiển thị Payment Sheet

      // In ra sau khi xác nhận thanh toán thành công
      print("Thanh toán thành công! Bắt đầu cập nhật cơ sở dữ liệu...");
      await _updatePaymentInDatabase(amount: amount);
      print("Cập nhật cơ sở dữ liệu thành công");

      // Cập nhật số dư
      if (onPaymentSuccess != null) {
        onPaymentSuccess!();
      }

      // Navigate back to the previous screen
      Navigator.pop(context);

    }on StripeException catch (e) {
      // Bắt lỗi từ Stripe và in thông tin chi tiết
      print('StripeException: ${e.error.localizedMessage}');
    } catch (e, stackTrace) {
      print('Lỗi trong quá trình thanh toán: $e');
      print('Chi tiết lỗi: $stackTrace');
    }
  }

  Future<int?> _initializeUserId() async {
    String? token = await getToken();
    if (token != null) {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('invalid token');
      }

      final payloadPart = parts[1];
      final payloadString = B64urlEncRfc7515.decodeUtf8(payloadPart);
      final payload = jsonDecode(payloadString) as Map<String, dynamic>;

      return payload['userId']; // extract userId from the payload
    }
    return null;
  }

  Future<void> _updatePaymentInDatabase({required double amount}) async {
    try {
      final Dio dio = Dio();
      int? userId = await _initializeUserId();
      if (userId == null) {
        print('Không thể lấy userId từ token');
        return;
      }

      // Dữ liệu để gửi tới backend của bạn nhằm thêm giao dịch vào cơ sở dữ liệu
      Map<String, dynamic> paymentData = {
        'userId': userId, // ID người dùng
        'amount': amount * 25, // Số tiền thanh toán
      };
      print('Gọi API với amount: $amount');

      // Thực hiện API call đến backend của bạn
      var response = await dio.post(
        'http://10.0.2.2:8080/api/v1/transactions/add', // Thay thế bằng endpoint API backend của bạn
        queryParameters: paymentData, // Gửi dữ liệu qua query parameters
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      // Xử lý phản hồi
      if (response.statusCode == 200) {
        print('Giao dịch đã được thêm vào cơ sở dữ liệu thành công.');
      } else {
        print('Thêm giao dịch vào cơ sở dữ liệu thất bại.');
      }
    } catch (e) {
      print('Đã xảy ra lỗi khi cập nhật cơ sở dữ liệu: $e');
    }
  }



  String _calculateAmount(double amount) {
    final calculatedAmount = (amount * 100).round();
    return calculatedAmount.toString();
  }
}