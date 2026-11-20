import 'dart:async';
import 'package:flutter/material.dart';

class AppBrowserController {
  final StreamController<String> _urls = StreamController<String>.broadcast();
  bool get isWindows => false;
  Stream<String> get url => _urls.stream;
  Future<void> initialize() async {}
  Future<void> loadUrl(String url) async {
    throw UnsupportedError('Browser navigation is unavailable on this platform.');
  }
  Widget buildView() => const SizedBox.shrink();
  Future<void> dispose() => _urls.close();
}
