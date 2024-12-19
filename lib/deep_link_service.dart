import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links3/uni_links.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  // Stream to handle incoming links
  StreamSubscription? _linkSubscription;

  // Initialize deep linking
  Future<void> initUniLinks(BuildContext context) async {
    // Handle initial link if the app was opened via a link
    try {
      String? initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(context, initialLink);
      }
    } on PlatformException {
      // Handle exception
    }

    // Listen for future links
    _linkSubscription = linkStream.listen(
      (String? link) {
        if (link != null) {
          _handleDeepLink(context, link);
        }
      },
      onError: (err) {
        // Handle stream error
      },
    );
  }

  // Parse and handle deep link
  void _handleDeepLink(BuildContext context, String link) {
    Uri uri = Uri.parse(link);

    // Example deep link parsing
    switch (uri.path) {
      case '/product':
        String? productId = uri.queryParameters['id'];
        if (productId != null) {
          _navigateToProductPage(context, productId);
        }
        break;
      case '/profile':
        String? userId = uri.queryParameters['id'];
        if (userId != null) {
          _navigateToProfilePage(context, userId);
        }
        break;
      default:
      // Handle unknown links or navigate to home
      // _navigateToHomePage(context);
    }
  }

  // Navigation methods
  void _navigateToProductPage(BuildContext context, String productId) {
    Navigator.pushNamed(context, '/product',
        arguments: {'productId': productId});
  }

  void _navigateToProfilePage(BuildContext context, String userId) {
    Navigator.pushNamed(context, '/profile', arguments: {'userId': userId});
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }

  // Cleanup method
  void dispose() {
    _linkSubscription?.cancel();
  }
}
