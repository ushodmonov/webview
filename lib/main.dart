import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late InAppWebViewController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String name = 'Hello from Flutter';
          controller.evaluateJavascript(source: 'changeText(\'$name\');');
        },
        tooltip: 'Change',
        child: const Icon(Icons.change_circle),
      ),
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          isInspectable: kDebugMode,
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
          iframeAllow: "camera; microphone",
          iframeAllowFullscreen: true,
          clearCache: true,
          cacheEnabled: false,
          clearSessionCache: true,
          cacheMode: CacheMode.LOAD_NO_CACHE,
        ),
        initialUrlRequest: URLRequest(
          url: WebUri(Uri.dataFromString(
            '''
      <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>WebView Example</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            text-align: center;
        }
    </style>
    <script>
        function changeText(newText) {
            document.getElementById('text').innerHTML = newText;
        }
    </script>
</head>
<body>
    <h1 id="text">Initial Text</h1>
</body>
</html>
          ''',
            mimeType: 'text/html',
          ).toString()),
        ),
        initialUserScripts: UnmodifiableListView<UserScript>([]),
        onWebViewCreated: (controller) {
          this.controller = controller;
        },
        onConsoleMessage: (controller, consoleMessage) {
          log(consoleMessage.toString());
        },
      ),
    );
  }
}
