import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './course.dart';

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
      home: const MyHomePage(title: 'HTTP JSON API'),
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

  final String url = 'https://my-json-server.typicode.com/houcem-h/public_courses_api/courses';
  List<dynamic> _courses = [];
  bool loading = true;

  @override
  void initState() {
    getCourses();
    super.initState();
  }

  Future<void> getCourses() async  {
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      final parsedData = jsonDecode(response.body).cast<Map<String, dynamic>>();
      _courses = parsedData.map<Course>((json) => Course.fromJson(json)).toList();
      setState(() {
        loading = !loading;
      });
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: loading ? waitingScreen() : coursesList()
    );
  }

  Widget waitingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text("Loading data ..."),
          Padding(padding: EdgeInsets.only(bottom: 25)),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget coursesList() {
    /*return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("DATA OK! ${_courses[3].description}"),
          const Padding(padding: EdgeInsets.only(bottom: 25)),
        ],
      ),
    );*/
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          Course course = _courses[index];
          return Card(
            color: Colors.cyan,
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: Image.network(course.image)),
                  const Divider(color: Colors.white),
                  Text(
                    course.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "\$${course.price.toString()}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


}
