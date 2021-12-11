import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class StorageProvider {
  Map<String, dynamic> _contactMap = {};
  StorageProvider() {
    // readData();
    readFromFile();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    // print(path);
    return File('$path/map.json');
  }

  readFromFile() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      // print(contents);
       _contactMap = json.decode(contents);
       print("Length " + _contactMap.length.toString());
    } catch (e) {
      // If encountering an error, return 0
      print("No File");
    }
  }

  writeData() {
    var jsobj = json.encode(_contactMap);
    // print(jsobj);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('contactMap', jsobj);
    });
    writeInFile();
  }

  readData() async {
    SharedPreferences.getInstance().then((prefs) {
      var jsobj = prefs.getString('contactMap');
      print(jsobj);
      if (jsobj != null) {
        _contactMap = json.decode(jsobj);
        print(_contactMap.length);
      }
    });
  }

  addContact(String number, String person) {
    _contactMap[number] = person;
    writeData(); // problem is when we add multiple new contact, the write will call for each new contact
  }

  removeContact(String number) {
    _contactMap.remove(number);
    writeData();
  }

  bool checkContact(String number) {
    return _contactMap.containsKey(number);
  }

  getContact(String number) {
    return _contactMap[number];
  }

  getContactMap() {
    return _contactMap;
  }

  writeInFile() async {
    final file = await _localFile;
    return file.writeAsString(json.encode(_contactMap));
  }
}
