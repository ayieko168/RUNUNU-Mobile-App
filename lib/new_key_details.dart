// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:rununu_app/database_helper.dart';
import 'package:rununu_app/utils.dart';

class KeyDetailsPage extends StatefulWidget {
  @override
  _KeyDetailsPageState createState() => _KeyDetailsPageState();
}

class _KeyDetailsPageState extends State<KeyDetailsPage> {
  // reference to our single class that manages the database
  final dbHelper = DataBaseHelper.instance;
  Utils? utilities = Utils();

  final nameController = TextEditingController();
  final decsriptionController = TextEditingController();
  var passed_data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    passed_data = ModalRoute.of(context)!.settings.arguments;
    log("passed_data :: $passed_data");
    log("Scanned data : ${passed_data['scanned_data']}");

    String _header_text = '';
    TextStyle _header_text_style = TextStyle();

    if (passed_data['scanned_data'] == 'None') {
      _header_text = "Scan Was Not Succesfull";
      _header_text_style = TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red[400]);
    } else {
      _header_text = "Scan Was A Success!";
      _header_text_style = TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.green[400]);
    }

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text("New Key Details"),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$_header_text",
                  style: _header_text_style,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "In This Section, You will Enter the Details of your new key such as:\n\n - Key TITLE (A title that will help you quickly identify your key For Example: 'Home Front Door')\n\n - Key DESCRIPTION (A Simple Description that will help you remember key details about the key, For Example: 'The Gland Hotel Temporary Guest Key That Expires On 26th May')",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Column(
                  children: [
                    Text(
                      "Key Name:",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextField(
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          maxLength: 30,
                          minLines: 1,
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Key Description:",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextField(
                          controller: decsriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLength: 120,
                          minLines: 1,
                          textAlign: TextAlign.center,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                FloatingActionButton.extended(
                  onPressed: saveKeyDetails,
                  label: Text(
                    "Finish Setup",
                  ),
                  icon: Icon(Icons.save_alt_outlined),
                ),
                SizedBox(
                  height: 15,
                )
              ],
            )
          ],
        )),
      ),
    );
  }

  void saveKeyDetails() {
    String name = nameController.text;
    String description = decsriptionController.text;
    final Map<String, String> key_object = {};

    name = name.trim();
    description = description.trim();

    // Check if the Name and Description field Are Filled
    if ((name == '') | (description == '')) {
      log("\n\n\t name: $name, description: $description");
      print("\n\n\t name: $name, description: $description");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You Need To Fill BOTH Fields',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.grey,
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    // Check if The Scanned data was valid
    if (passed_data['scanned_data'] == 'None') {
      print("\n\n\t name: $name, description: $description");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your Scan Seems To Be Invalid, Try Again',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.grey,
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    // Create A Key Json Object
    String scanData = passed_data['scanned_data'];
    String keyId = scanData.substring(5, 21).trim();
    String otp_32_key = scanData.substring(21, 37).trim();
    String rand_32_str = utilities!.getRandomString(16);

    Map<String, dynamic> row = {
      DataBaseHelper.columnKeyKeyId: keyId,
      DataBaseHelper.columnKey32BitKeyMain: otp_32_key,
      DataBaseHelper.columnKey32BitKeyRand: rand_32_str,
      DataBaseHelper.columnKeyLocationName: name,
      DataBaseHelper.columnKeyLocationDescription: description,
      DataBaseHelper.columnKeyOnCreateDate: "23",
      DataBaseHelper.columnKeyLastView: "23"
    };
    final id = dbHelper.insertKey(row);
    log('inserted row id: $id');
    log("Raw Data:: $row");

//     key_object['Key ID'] = key_id;
//     key_object["Location Name"] = name;
//     key_object["Location Description"] = description;
//     key_object["encryptKeyTp"] = _encrypt;
//     key_object["Key"] = _key;

//     //print(key_object);

//     // Save the key to disk
//     key_data.add(key_object);
//     data['keys'] = key_data;
//     print(data.toString());
//     log('DATA ::  $data');
//     log('KEY DATA ::  $key_data');
//     _write(data);

    // Go back to the main page
    Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/'));
//    Navigator.pop(context);
//    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Your Key Was Created Successfully. Enjoy.',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.grey,
          duration: Duration(seconds: 4),
        ),
      );
  }
}

class Routes {
  static const String firstPage = '/home';
}
