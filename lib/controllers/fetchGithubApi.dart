import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:promts/Model/ContributorModel.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContributorController extends GetxController {
  List<ContributorModel> contributors = [];
  @override
  void onInit() {
    // TODO: implement onInit

    // AddTimeLineController addTimeLineController =
    //     Get.put(AddTimeLineController());
    getallData();
    super.onInit();
  }

  String otp = "";

  Future<void> getallData() async {
    // var spinkit = SpinKitPulse(
    //   size: 50.0,
    // );
    // Get.dialog(
    //   Container(
    //     height: 100,
    //     width: 100,
    //     child: Center(
    //       child: spinkit,
    //     ),
    //   ),
    //   barrierDismissible: false,
    // );
    String token = "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";
    Map<String, String> header = {
      'Authorization': 'Bearer $token',
      'X-GitHub-Api-Version': '2022-11-28',
      'Accept': 'application/vnd.github+json'
    };

    // print(dataToSend);

    // print(base_url);
    // print(token.toString());

    var response = await http.get(
      Uri.parse(
        "https://api.github.com/repos/Pavel401/DartGpt/contributors",
      ),
      headers: header,
    );

    print("status" + response.statusCode.toString());

    if (response.statusCode == 200) {
      contributors = contributorModelFromJson(response.body);

      Get.forceAppUpdate();
      // Get.back();
    } else if (response.statusCode == 401) {
      Get.back();
    }
  }
}
