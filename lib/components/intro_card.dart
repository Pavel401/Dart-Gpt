import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:promts/models/EmptyCardModel.dart';
import 'package:promts/models/model_theme.dart';
import 'package:provider/provider.dart';

//Credit :(Saif) https://github.com/beSaif/FlutGPT

class IntroCards extends StatelessWidget {
  final EmptyStateCardModel card;
  const IntroCards({Key? key, required this.card}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
      builder: (context, ModelTheme themeNotifier, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: Image.asset(card.icon),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  card.title,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: card.items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: themeNotifier.isDark
                            ? Color(0xFF40414f)
                            : Color(0xFFe0e0e0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${card.items[index]}',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 30,
            ),
          ],
        );
      },
    );
  }
}

extension StringExtension on String {
  String deleteLastChar({int toDelete = 1}) => substring(0, length - toDelete);
}
