import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'BG APP Contacts Module'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllContacts();
  }

  getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts;
      for (var cnct in contacts) {
        var num = cnct.phones?.elementAt(0).value?.replaceAll(RegExp("[^0-9]"), "").toString();

      }
      getBGAppUsers();
    });
  }

  getBGAppUsers() async {
    var url = Uri.parse('https://25fd-110-227-92-109.ngrok.io/api');
    var body = json.encode({
      "userId": "BG001",
      "contacts": ["8847872656", "9191875678"]
    });
    http.Response response = await http
        .post(url, body: body, headers: {'Content-type': 'application/json'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text("Contacts"),
            ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  Contact contact = contacts[index];
                  return ListTile(
                    title: Text(contact.displayName.toString()),
                  );
                })
          ],
        ),
      ),
    );
  }
}
