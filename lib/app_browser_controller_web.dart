import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/material.dart';

/// Web cannot embed an unrestricted hidden WebView or inspect cross-origin
/// redirects. This controller opens the requested page in a new tab instead.
class AppBrowserController {
  final StreamController<String> _urls = StreamController<String>.broadcast();
  bool get isWindows => false;
  Stream<String> get url => _urls.stream;
  Future<void> initialize() async {}
  Future<void> loadUrl(String url) async {
    html.window.open(url, '_blank');
  }
  Widget buildView() => const SizedBox.shrink();
  Future<void> dispose() => _urls.close();
}
