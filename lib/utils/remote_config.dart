import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_gradient_generator/models/banner_ad_config.dart';

/// A wrapper class for Firebase Remote Config.
class RemoteConfig {
  /// The backing field for the remote config instance.
  ///
  /// Use [_getRemoteConfigInstance] to get the remote config instance.
  FirebaseRemoteConfig? _remoteConfig;

  /// Fetches the remote config instance.
  ///
  /// Use this method to get the remote config instance instead of
  /// the [_remoteConfig] variable.
  Future<FirebaseRemoteConfig> _getRemoteConfigInstance() async {
    if (_remoteConfig != null) return _remoteConfig!;

    _remoteConfig = await () async {
      final newRemoteConfig = FirebaseRemoteConfig.instance;
      await newRemoteConfig.fetchAndActivate();

      return newRemoteConfig;
    }();

    return _remoteConfig!;
  }

  /// Fetches the banner ad config from the remote config.
  Future<BannerAdConfig?> getBannerAdConfig() async {
    try {
      final remoteConfigInstance = await _getRemoteConfigInstance();

      final allConfig = remoteConfigInstance.getAll();

      final bannerAdConfigRemoteValue = allConfig['banner_ad_config'];

      if (bannerAdConfigRemoteValue == null) return null;

      final bannerAdConfigJson =
          jsonDecode(bannerAdConfigRemoteValue.asString());

      return BannerAdConfig.fromJson(bannerAdConfigJson);
    } catch (e) {
      return null;
    }
  }
}
