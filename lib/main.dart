import 'dart:convert';

import 'package:bgapp/const.dart';
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
  Set<String> contactNumbers = {};
  StorageProvider storageProvider = new StorageProvider();

  @override
  void initState() {
    super.initState();
    getAllContacts();
    print(json.encode(storageProvider.getContactMap()));
  }

  getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts;
      for (var cnct in contacts) {
        List<Item> _items = cnct.phones ?? [];
        for (var phone in _items) {
          String num = phone
                  .value
                  ?.replaceAll(RegExp("[^0-9]"), "")
                  .toString() ??
              "";
          print(num);
          // if length of num is >= 10 then print last 10 digits
          if ((num.length) >= 10 && !storageProvider.checkContact(num.substring(num.length - 10))) {
            num = num.substring(num.length - 10);
            contactNumbers.add(num);
          }
        }
      }
      // Call API
      if (contactNumbers.length > 0) {
        print("Hello : "+contactNumbers.length.toString());
        print(contactNumbers.join(","));
        getBGAppUsers();
      }
    });
  }

  getBGAppUsers() async {
    var url = Uri.parse('https://25fd-110-227-92-109.ngrok.io/api');
    var body = json.encode({"userId": "BG001", "contacts": contactNumbers.toList()});
    http.Response response = await http
        .post(url, body: body, headers: {'Content-type': 'application/json'});
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    var data = json.decode(response.body);
    data['data'].forEach((element) {
      // if (element['hasAccount'] == true) {
      storageProvider.addContact(element['phone'], json.encode(element));
    });
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
