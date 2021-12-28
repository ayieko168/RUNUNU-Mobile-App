import 'package:flutter/material.dart';
import 'dart:io';

import 'package:rununu_app/database_helper.dart';
import 'dart:developer';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Initialize the variables
  String menuValue = "";
  var allKeys;
  Map data = {};

  // Reference to the db class
  final dbHelper = DataBaseHelper.instance;
  
  @override
  void initState() {
    super.initState();
    queryDatabaseKeys();
  }

  // Home Page Layout And UI
  @override
  Widget build(BuildContext context) {
    var lis = dbHelper.queryAllKeys();
    log("DB Log::");
    

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        // ignore: prefer_const_constructors
        title: Text("Rununu Key Chain"),
        actions: <Widget>[
          PopupMenuButton<String>(
            color: Colors.grey[800],
            offset: Offset(10, 40),
            onSelected: handleContextMenu,
            itemBuilder: (BuildContext context) {
              return {
                'How it Works',
                'View In Light Mode',
                'Transfer Accounts',
                "Set Passcode",
                'Settings',
                'Help & Feedback'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 5.0, 20.0, 5.0),
                    child: Text(
                      choice,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: allKeys == null ? 0 : allKeys.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                color: Colors.grey[850],
                child: ListTile(
                  title: Text(
                    "${allKeys[index]['locationname']}",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: Colors.blue[400]
                    ),
                  ),
                  subtitle: Text(
                    "${allKeys[index]['locationdescription']}",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 16
                    ),
                  ),
                  onTap: () { handleKeySelect(index); },
                )
              ),
            );
          },

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { print("Move to add key page!"); Navigator.pushNamed(context, '/add_key'); },
        child: Icon(
          Icons.add,
          size: 35,
          color: Colors.grey[550],
        ),
      ),
    );
  }

  void queryDatabaseKeys() async {
    final readKeys = await dbHelper.queryAllKeys();
    print('query all rows: $readKeys');
    readKeys.forEach(print);

    setState(() => allKeys = readKeys);
  }

  void handleContextMenu(value) {
    // setState(() {
    //   _menu_value = value;

    // });
    print(value);
    // print(dbHelper.queryRowCount());
  }

  void handleKeySelect(int index) async {

    log("Key at index $index selected");

    // Move to other page
    dynamic result = await Navigator.pushNamed(context, '/key', arguments: {"json_data": allKeys, "selected_key": index});

  }
 
}


