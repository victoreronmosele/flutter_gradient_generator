import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gradient_generator/models/abstract_gradient.dart';

///TODO: Set app version when releasing the app

/// A wrapper class for Analytics event logging.
class Analytics {
  /// Logs the [firebaseAnalyticsEvent] and optional [parameters] in release
  /// mode only.
  ///
  /// Ensure to only use this method to log events and not use the Analytics
  /// instance (in this case, `FirebaseAnalytics`) directly.
  @visibleForTesting
  Future<void> logEventInReleaseMode(
      FirebaseAnalyticsEvent firebaseAnalyticsEvent,
      {Map<String, dynamic>? parameters}) async {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    /// Return if not in release mode
    if (!kReleaseMode) return;

    final firebaseAnalyticsKey = firebaseAnalyticsEvent.key;

    await analytics.logEvent(
        name: firebaseAnalyticsKey, parameters: parameters);
  }

  /// Logs when a gradient is generated and copied to the clipboard.
  Future<void> logGradientGeneratedEvent(AbstractGradient gradient) async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.gradientGenerated,
      parameters: gradient.toJson(),
    );
  }

  /// Logs when a gradient is downloaded as an image.
  Future<void> logGradientDownloadedAsImageEvent(
      AbstractGradient gradient) async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.gradientDownloadedAsImage,
      parameters: gradient.toJson(),
    );
  }

  /// Logs when the random gradient sample button is clicked.
  Future<void> logRandomGradientSampleButtonClickEvent() async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.randomGradientSampleButtonClicked,
    );
  }

  /// Logs when a gradient sample is clicked.
  Future<void> logGradientSampleClickEvent(String sampleName) async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.gradientSampleClicked,
      parameters: <String, String>{
        'sampleName': sampleName,
      },
    );
  }

  /// Logs when the banner ad CTA button is clicked.
  Future<void> logBannerAdCTAButtonClickEvent({
    required String name,
    required String url,
  }) async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.bannerAdCTAButtonClicked,
      parameters: <String, String>{
        'name': name,
        'url': url,
      },
    );
  }

  /// Logs when the banner ad close button is clicked.
  Future<void> logBannerAdCloseButtonClickEvent() async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.bannerAdCloseButtonClicked,
    );
  }

  /// Logs when the feature request button is clicked.
  Future<void> logFeatureRequestButtonClickEvent() async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.featureRequestButtonClicked,
    );
  }

  /// Logs when the feedback button is clicked.
  Future<void> logFeedbackButtonClickEvent() async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.feedbackButtonClicked,
    );
  }

  /// Logs when the bug report button is clicked.
  Future<void> logBugReportButtonClickEvent() async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.bugReportButtonClicked,
    );
  }

  /// Logs when the view source code on GitHub button is clicked.
  Future<void> logViewSourceCodeOnGitHubButtonClickEvent() async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.viewSourceCodeOnGitHubButtonClicked,
    );
  }

  /// Logs when the Victor Eronmosele link is clicked.
  Future<void> logVictorEronmoseleClickEvent() async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.victorEronmoseleClicked,
    );
  }

  /// Logs when the undo button is clicked.
  Future<void> logUndoButtonClickEvent() async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.undoButtonClicked,
    );
  }

  /// Logs when the redo button is clicked.
  Future<void> logRedoButtonClickEvent() async {
    await logEventInReleaseMode(
      FirebaseAnalyticsEvent.redoButtonClicked,
    );
  }
}

/// The list of Firebase Analytics events to log.
///
/// Each event has a unique [key] that is used to log the event.
///
/// Please use the [key] to log the event and not the enums's `.name` property.
enum FirebaseAnalyticsEvent {
  gradientGenerated(key: 'gradientGenerated'),
  gradientDownloadedAsImage(key: 'gradientDownloadedAsImage'),
  randomGradientSampleButtonClicked(key: 'randomGradientSampleButtonClicked'),
  gradientSampleClicked(key: 'gradientSampleClicked'),
  bannerAdCTAButtonClicked(key: 'bannerAdCTAButtonClicked'),
  bannerAdCloseButtonClicked(key: 'bannerAdCloseButtonClicked'),
  featureRequestButtonClicked(key: 'featureRequestButtonClicked'),
  feedbackButtonClicked(key: 'feedbackButtonClicked'),
  bugReportButtonClicked(key: 'bugReportButtonClicked'),
  viewSourceCodeOnGitHubButtonClicked(
      key: 'viewSourceCodeOnGitHubButtonClicked'),
  undoButtonClicked(key: 'undoButtonClicked'),
  redoButtonClicked(key: 'redoButtonClicked'),
  victorEronmoseleClicked(key: 'victorEronmoseleClicked');

  const FirebaseAnalyticsEvent({required this.key});

  final String key;
}
