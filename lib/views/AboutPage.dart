import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:promts/controllers/fetchGithubApi.dart';
import 'package:promts/models/model_theme.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  About({Key? key}) : super(key: key);
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  String introduction =
      "Hi there! MABUD here. I am a CS student with a passion for building beautiful and functional applications. I have used OPEN API and Flutter to build this app. I am open to any suggestions and feedbacks.Contributions are always welcomed :)";

  var controller = Get.put(ContributorController());
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ContributorController());
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // backgroundColor: Colors.black,
          elevation: 0,
          title: Text(
            "Contributions",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        body: ElasticIn(
          child: Padding(
            padding: EdgeInsets.only(top: 1.h, left: 2.w, right: 2.w),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //     height: 25.h,
                    //     width: 40.w,
                    //     child: Image.asset("assets/images/logot.png")),
                    SizedBox(
                        child: SvgPicture.asset(
                      "assets/logo.svg",
                      color: themeNotifier.isDark
                          ? Color(0xFFe0e0e0)
                          : Color(0xFF40414f),
                      height: 20.h,
                      width: 100.w,
                    )),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "Promts",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Version: ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "1.0.0",
                          style: TextStyle(fontSize: 15),
                        ),
                        IconButton(
                          onPressed: () async {
                            String url = "https://github.com/Pavel401/DartGpt";
                            if (!await launchUrl(Uri.parse(url))) {
                              throw Exception('Could not launch $url');
                            }
                          },
                          icon: SvgPicture.asset(
                            "assets/github.svg",
                            color: themeNotifier.isDark
                                ? Color(0xFFe0e0e0)
                                : Color(0xFF40414f),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      introduction,
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),

                    Text(
                      "For any further queries contact me through:",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 40.w, // <-- Button Width
                          height: 5.h, // <-- Button height
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              // primary: HexColor("#202020"),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                            onPressed: () async {
                              String url = "https://github.com/Pavel401";
                              if (!await launchUrl(Uri.parse(url))) {
                                throw Exception('Could not launch $url');
                              }
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.github,
                            ),
                            label: Text(
                              "GitHub",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40.w, // <-- Button Width
                          height: 5.h, // <-- Button height
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              // primary: HexColor("#4154FC"),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10), // <-- Radius
                              ),
                            ),
                            onPressed: () async {
                              String url =
                                  "https://www.linkedin.com/in/sk-mabud-alam-444a87133/";
                              if (!await launchUrl(Uri.parse(url))) {
                                throw Exception('Could not launch $url');
                              }
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.linkedinIn,
                              //
                            ),
                            label: Text(
                              "LinkedIN",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "All the contributors are listed below:",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Contribute on github to get your name here",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(
                      height: 2.h,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.contributors.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: themeNotifier.isDark
                                      ? Color(0xFF40414f)
                                      : Color(0xFFe0e0e0),
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      controller.contributors[index].avatarUrl),
                                ),
                                title: Text(
                                  controller.contributors[index].login,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  controller.contributors[index].contributions
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: IconButton(
                                  onPressed: () async {
                                    String url =
                                        controller.contributors[index].htmlUrl;
                                    if (!await launchUrl(Uri.parse(url))) {
                                      throw Exception('Could not launch $url');
                                    }
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.github,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
