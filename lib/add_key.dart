// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';
import 'package:otp/otp.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddKeyPage extends StatefulWidget {
  const AddKeyPage({Key? key}) : super(key: key);

  @override
  _AddKeyPageState createState() => _AddKeyPageState();
}

class _AddKeyPageState extends State<AddKeyPage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String sixCode = "";
  String scanned_qr_data = "None";
  String resultText = 'Scan a code';

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  resultText,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: FloatingActionButton.extended(
                onPressed: () {
                  print("Move!");
                  Navigator.popAndPushNamed(context, '/add_key_next',
                      arguments: {'scanned_data': scanned_qr_data});
                },
                label: Text('Next Step'),
                icon: Icon(Icons.navigate_next),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      scanned_qr_data = scanData.code;
      sixCode = "";
      log("scanned_qr_data :: $scanned_qr_data");

      if (scanned_qr_data.length == 37) {
        log("Valid Code!");

        // Get the 6 digit otp
        try {
          String scanned_32_key = scanned_qr_data.substring(21, 37).trim();
          log("scanned_32_key :: $scanned_32_key");
          sixCode = getSixCode(scanned_32_key);
          log("sixCode :: $sixCode");
        } catch (e) {
          log("Error getting six code: $e");
          sixCode = "ERROR";

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not generate six code. Error:: $e')),
          );
        }

        if (sixCode == "ERROR") {
          resultText = "INVALID QR Code! Try another.";
          scanned_qr_data = "None";
        } else {
          resultText = "VALID DATA. Scanned Code: $sixCode";
          log(resultText);
        }
      } else {
        log("Invalid Code!");
        resultText = "INVALID DATA! Try scanning again";
      }

      setState(() {
        result = scanData;
        resultText = resultText;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  String getSixCode(String _32bitString) {
    try {
      final _code = OTP.generateTOTPCodeString(
          _32bitString, DateTime.now().millisecondsSinceEpoch,
          interval: 30, algorithm: Algorithm.SHA1, isGoogle: true);

      return _code;
    } on Exception catch (e) {
      log("Exception :: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Exception :: $e")),
      );
      return "ERROR";
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
