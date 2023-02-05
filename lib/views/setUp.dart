import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:promts/views/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SetUp extends StatefulWidget {
  SetUp({super.key});

  @override
  State<SetUp> createState() => _SetUpState();
}

class _SetUpState extends State<SetUp> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    init();
    super.initState();
  }

  init() async {
    final prefs = await SharedPreferences.getInstance();

    final String? api = prefs.getString('key');

    if (api != null) {
      controller.text = api;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ElasticIn(
              child: Text(
                "Enter your ChatGPT API Key",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            ElasticIn(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'API Key',
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            ElasticIn(
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text("Please enter a valid API key to continue"),
                      ),
                    );
                  } else {
                    if (controller.text.contains('sk-')) {
                      final prefs = await SharedPreferences.getInstance();

                      await prefs.setString('key', controller.text.toString());

                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Home()));

                      // Navigation.
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Please enter a valid API key to continue"),
                      ));
                    }
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
