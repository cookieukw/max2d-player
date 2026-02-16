import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'globalvars.dart';

Ads2 theads2 = Ads2();

class Ads2 {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool ishidden = false;
  bool isnaaybanner = false;
  bool isdebug = false;

  String anchor = "bottom";
  String bannersize = "banner";

  // Test App Id
  String appid = Platform.isAndroid ? 'ca-app-pub-3940256099942544~3347511713' : 'ca-app-pub-3940256099942544~1458002511';
  
  // Test IDs
  String get rewardid => Platform.isAndroid ? 'ca-app-pub-3940256099942544/5224354917' : 'ca-app-pub-3940256099942544/1712485313';
  String get bannerid => Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716';
  String get interstitialid => Platform.isAndroid ? 'ca-app-pub-3940256099942544/1033173712' : 'ca-app-pub-3940256099942544/4411468910';

  bool ismanaagvideo = false;

  Future initialize(bool visdebug) async {
    isdebug = visdebug;
    await MobileAds.instance.initialize();
  }

  Future showvideo() async {
    await RewardedAd.load(
      adUnitId: isdebug ? (Platform.isAndroid ? 'ca-app-pub-3940256099942544/5224354917' : 'ca-app-pub-3940256099942544/1712485313') : rewardid,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
             print('User earned reward: ${reward.amount} ${reward.type}');
             ismanaagvideo = true;
             hideBannerAd();
             Future.delayed(Duration(minutes: 30), () {
                ismanaagvideo = false;
             });
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          if (ismanaagvideo == false) {
             ismanaagvideo = true;
             hideBannerAd();
             Future.delayed(Duration(minutes: 5), () {
                ismanaagvideo = false;
             });
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
     InterstitialAd.load(
      adUnitId: isdebug ? (Platform.isAndroid ? 'ca-app-pub-3940256099942544/1033173712' : 'ca-app-pub-3940256099942544/4411468910') : interstitialid,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd!.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  // Returns a Widget to be added to the tree
  Widget getBannerWidget() {
     if (_bannerAd == null) return Container();
     return Container(
       alignment: Alignment.center,
       width: _bannerAd!.size.width.toDouble(),
       height: _bannerAd!.size.height.toDouble(),
       child: AdWidget(ad: _bannerAd!),
     );
  }
  
  Function? onBannerLoaded;

  void showBannerAd(bool istop) {
    // If usage expects overlay, we might have issues. This implementation prepares the banner.
    // gameplayer.dart needs to put getBannerWidget() in the stack.
    
    // Actually, createBannerAd needs to know size.
    AdSize size = AdSize.banner;
    if (bannersize == "fullBanner") size = AdSize.fullBanner;
    else if (bannersize == "largeBanner") size = AdSize.largeBanner;
    else if (bannersize == "leaderboard") size = AdSize.leaderboard;
    else if (bannersize == "mediumRectangle") size = AdSize.mediumRectangle;
    else if (bannersize == "smartBanner") size = AdSize.fluid; // Smart banner deprecated? Use fluid or specialized.

    _bannerAd = BannerAd(
      adUnitId: isdebug ? (Platform.isAndroid ? 'ca-app-pub-3940256099942544/6300978111' : 'ca-app-pub-3940256099942544/2934735716') : bannerid,
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('BannerAd loaded.');
          isnaaybanner = true;
          ishidden = false;
          onBannerLoaded?.call(); 
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('BannerAd failed to load: $error');
          ad.dispose();
          isnaaybanner = false;
        },
      ),
    );

    _bannerAd!.load();
  }

  Future hideBannerAd() async {
    if (_bannerAd != null) {
      ishidden = true;
      await _bannerAd!.dispose();
      _bannerAd = null;
      isnaaybanner = false;
      onBannerLoaded?.call(); // Refresh UI to remove it
    }
  }
}
