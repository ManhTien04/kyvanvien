import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kyvanvien/ad/ad_manager.dart';
import 'package:kyvanvien/payment/payment.dart';
import 'package:kyvanvien/view/LoginRegister/TokenHandler.dart';
import 'package:kyvanvien/view/LoginRegisterPage.dart';
import 'package:kyvanvien/view/intro_page.dart';
import 'package:kyvanvien/view/menu_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  String? token = await getToken();
  AdManager adManager = AdManager();
  adManager.showAdPeriodically();
  await _setup();
  runApp(MyApp(homePage: token == null || token.isEmpty ? LoginRegisterPage() : MenuPage()));
}

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
}
class MyApp extends StatelessWidget {
  final Widget homePage;
  final AdManager _adManager = AdManager();

  MyApp({Key? key, required this.homePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _adManager.showAd();
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: homePage,
      routes: {
        '/intropage': (context) => const IntroPage(),
        '/menupage' : (context) => const MenuPage(),
        '/loginpage': (context) => LoginRegisterPage(),
      },
    );
  }
}