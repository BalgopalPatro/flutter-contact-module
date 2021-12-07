import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider {
  Map<String, dynamic> _contactMap = {};
  StorageProvider() {
    readData();
  }
  writeData(){
    var jsobj = json.encode(_contactMap);
    print(jsobj);
    SharedPreferences.getInstance().then((prefs){
      prefs.setString('contactMap', jsobj);
    });
  }
  readData() async{
    SharedPreferences.getInstance().then((prefs){
      var jsobj = prefs.getString('contactMap');
      print(jsobj);
      if(jsobj != null){
        _contactMap = json.decode(jsobj);
        print(_contactMap.length);
      }
    });
  }
  addContact(String number,String person){
    _contactMap[number] = person;
    writeData();
  }
  removeContact(String number){
    _contactMap.remove(number);
    writeData();
  }
  bool checkContact(String number){
    return _contactMap.containsKey(number);
  }
  getContact(String number){
    return _contactMap[number];
  }
  getContactMap(){
    return _contactMap;
  }
}
