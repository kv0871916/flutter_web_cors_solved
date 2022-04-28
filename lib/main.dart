import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? text;

  @override
  Widget build(BuildContext context) {
    ui.platformViewRegistry.registerViewFactory(
        'test-view-type',
        (int viewId) => ImageElement()
          ..src = "https://navoki.com/wp-content/uploads/2019/09/200_40.png"
          ..style.border = 'none');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              height: 100,
              image: NetworkImage(
                'https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Google-flutter-logo.svg/2560px-Google-flutter-logo.svg.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Own Server Allows any request using \n (access-control-allow-origin: *)",
                textAlign: TextAlign.center,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 40)),
            Image(
              image: NetworkImage(
                'https://cros-anywhere.herokuapp.com/https://navoki.com/wp-content/uploads/2019/09/200_40.png',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Using CORS Proxy"),
            ),
            Padding(padding: EdgeInsets.only(top: 40)),
            Container(
              child: HtmlElementView(viewType: 'test-view-type'),
              height: 100,
              width: 400,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("HTML View"),
            ),
            Padding(padding: EdgeInsets.only(top: 40)),
            Image.memory(base64Decode(
                "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")),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Images as Base64"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchApi,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future fetchApi() async {
    // HttpRequest httpRequest=HttpRequest();
    // httpRequest.open("GET", 'https://navoki.com');
    // print('Response 2: ${httpRequest.response}');

    var url =
        Uri.parse('https://cros-anywhere.herokuapp.com/https://navoki.com');
    http.Response? response;
    try {
      response = await http.get(url, headers: {});
      print('Response body: ${response.body}');
      print('Response body: ${response.headers}');
      print('Response body: ${response.request!.headers}');
      text = response.body;
    } on Exception catch (e) {
      print('Response body:Exception1 $e');
      print('Response body:Exception2 ${response!.body}');
      print('Response body:Exception3 ${response.headers}');
      print('Response body:Exception4 ${response.request!.headers}');
    }

    setState(() {});
  }
}
