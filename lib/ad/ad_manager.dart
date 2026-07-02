import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  InterstitialAd? _interstitialAd;
  final StreamController<bool> _adDisplayController = StreamController<bool>();

  Stream<bool> get adDisplayStatus => _adDisplayController.stream;

  Future<void> loadAd() async {
    final adLoad = InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',  // Quảng cáo thử nghiệm
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Failed to load an interstitial ad: $error');
        },
      ),
    );
    await adLoad;
  }

  Future<void> showAd() async {
    if (_interstitialAd == null) {
      await loadAd();
    } else {
      _adDisplayController.add(true);  // Notify that ad will be displayed
      _interstitialAd!.show();
      _interstitialAd = null;
      _adDisplayController.add(false);  // Notify that ad has been hidden
    }
  }

  void showAdPeriodically() {
    Timer.periodic(Duration(minutes: 50), (Timer timer) async {
      await showAd();
    });
  }
}