import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  late final WebViewController _controller;
  String receivedMessage = "Waiting for JavaScript...";

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        "flutter_invoke",
        onMessageReceived: (JavaScriptMessage message) {
          log("Received message from JavaScript: ${message.message}");
        },
      )
      ..loadHtmlString(_loadHtml());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.runJavaScript("changeText('Hello from Flutter!');");
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  String _loadHtml() {
    return '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>WebView Example</title>
        <style>
            body {
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
                text-align: center;
            }
            button {
                margin-top: 20px;
                padding: 10px;
                font-size: 16px;
            }
        </style>
        <script>
            function changeText(newText) {
                document.getElementById('text').innerHTML = newText;
            }

            function sendMessageToFlutter() {
                window.flutter_invoke.postMessage("Hello from JavaScript!");
            }
        </script>
    </head>
    <body>
        <h1 id="text">Initial Text</h1>
        <button onclick="changeText('Hello from JavaScript!')">Change Text</button>
        <button onclick="sendMessageToFlutter()">Send Message to Flutter</button>
    </body>
    </html>
    ''';
  }
}
