import 'dart:async';

import 'package:fishtokri/src/web_view_stack.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
//ignore_for_file: prefer_const_constructors

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  Future<void> initUniLinks() async {
    // Handle deep link when the app is launched from a cold start
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        handleDeepLink(initialLink);
      }
    } catch (e) {
      print("Error getting initial link: $e");
    }

    // Listen for deep links while the app is running in the foreground
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        handleDeepLink(link);
      }
    }, onError: (err) {
      print("Error receiving link: $err");
    });
  }

  void handleDeepLink(String link) {
    // Here, simply navigate to the home screen regardless of the deep link
    print("Received deep link: $link");
    WebViewStack();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const WebViewStack(),
      ),
    );
  }
}
