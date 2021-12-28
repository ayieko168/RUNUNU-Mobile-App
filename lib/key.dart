// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rununu_app/database_helper.dart';
import 'dart:developer';


import 'package:qr_flutter/qr_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:rununu_app/utils.dart';

class KeyPage extends StatefulWidget {
  const KeyPage({ Key? key }) : super(key: key);

  @override
  _KeyPageState createState() => _KeyPageState();
}

class _KeyPageState extends State<KeyPage> {

  var passed_data;
  Utils utilities = Utils();
  late Timer _uiUpdateTimer;
  String qr_code_data = "Nothing";
  var percentage = 0.0;
  String remainingTime = "0";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _uiUpdateTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    passed_data = ModalRoute.of(context)!.settings.arguments;
    var selected_key = passed_data['selected_key'];
    var json_data = passed_data['json_data'];
    log("passed_data :: $passed_data");

    // Function to update the app timer and the qr code
    void updateUi(Timer t){

      if (!mounted) return;

      String _key = json_data[selected_key]['_32bitkeymain'];
      double remTime = utilities.getRemainingTime();
      String mainQrData = utilities.generateQRData(
          json_data[selected_key]['keyid'],
          utilities.getSixCode(_key));

      // Genarate new qr code
      qr_code_data = "$mainQrData";
      log("QR DATA: $mainQrData");

      // Set new timer value
      percentage = ((remTime * 100.0) / 30.0) / 100.0;

      // Set new timer string value


      // Finally update the UI
      setState(() {
        // Your state change code goes here
        remainingTime = "${remTime.ceil()}";
      });

    }


    // Initialize and setup recurring future
    const oneSec = const Duration(seconds:1);
    _uiUpdateTimer = Timer.periodic(oneSec, updateUi);

    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        // ignore: prefer_const_constructors
        title: Text("Key To ${json_data[selected_key]['locationname']}"),
      ),
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [

          // The Key location label
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                child: Text(
                  "Key Location:",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white60
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ),
          
          // The Key location data label
          Expanded(
            flex: 2,
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 30),
                child: Text(
                  "${json_data[selected_key]['locationname']}",
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic
                  ),
                ),
                
              ),
            )
          ),
          
          // The Qr Code Image Widget
          Expanded(
            flex: 5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                child: QrImage(
                  data: qr_code_data,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  // embeddedImage: AssetImage('assets/images/my_embedded_image.png'),
                  // embeddedImageStyle: QrEmbeddedImageStyle(
                  //   size: Size(80, 80),
                  //   ),

                ),
              ),
            ),
          ),

          // The Time Left Indicator
          Expanded(
            flex: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 5.0,
                  // animation: true,
                  percent: percentage,
                  center: Text(
                    "$remainingTime s",
                    style: TextStyle(color: Colors.white70,),
                  ),
                  footer: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Time Remaining",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Colors.blue,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  
}