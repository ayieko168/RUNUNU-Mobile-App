import 'package:otp/otp.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;

class Utils {

  final chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  String getSixCode(String _32bitString){

    dev.log("Getting 6 digit for $_32bitString");

    final _code = OTP.generateTOTPCodeString(
        _32bitString,
        DateTime.now().millisecondsSinceEpoch,
        interval: 30,
        algorithm: Algorithm.SHA1,
        isGoogle: true);
        print("Decoded 6 digit: $_code");

    return _code;

  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));

  String generateQRData(String key_id, String currentCode){

    // key_id = The Key ID on DB
    // currentCode = The 6 digit OTP value

    final String qrData = key_id + currentCode + (int.parse(currentCode) % 999).toString();
    
    return qrData.toString();

  } 

  double getRemainingTime(){

    double time_remaining;
    time_remaining = 30.0 - ((DateTime.now().millisecondsSinceEpoch) / 1000.0) % 30.0;

    // print(time_remaining);

    return time_remaining;

  }
}