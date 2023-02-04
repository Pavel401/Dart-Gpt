import 'dart:async';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:promts/components/intro_card.dart';
import 'package:promts/models/model_theme.dart';
import 'package:promts/views/AboutPage.dart';
import 'package:promts/views/setUp.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../models/ChatModel.dart';
import '../models/EmptyCardModel.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  void handleScreenChanged(int selectedScreen) {
    if (selectedScreen == 0) {
      Get.back();
    } else if (selectedScreen == 1) {
      Get.to(SetUp());
    } else if (selectedScreen == 2) {
      Get.to(About());
    }
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  late TextEditingController textEditingController;
  ScrollController scrollController = ScrollController();
  FlutterTts flutterTts = FlutterTts();
  double volume = 1.0;
  double pitch = 1.0;
  double speechRate = 0.5;
  List<String>? languages;
  String langCode = "en-US";
  int screenIndex = 0;
  bool isListening = false;
  bool speechEnabled = false;

  bool isSpeaking = false;
  final chatGpt =
      ChatGpt(apiKey: "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");
  StreamSubscription<CompletionResponse>? streamSubscription;
  SpeechToText _speechToText = SpeechToText();

  /// This has to happen only once per app
  void _initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      textEditingController.text = result.recognizedWords;
    });

    // Get.snackbar("title", "${result.recognizedWords}");
  }

  /// Each time to start a speech recognition session
  void startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  @override
  void initState() {
    flutterTts.setStartHandler(() {
      ///This is called when the audio starts
      setState(() {
        isSpeaking = true;
      });
      print(isSpeaking);
    });

    flutterTts.setCompletionHandler(() {
      ///This is called when the audio ends
      setState(() {
        isSpeaking = false;
      });
      print(isSpeaking);
    });
    textEditingController = TextEditingController();

    scrollController.addListener(() {
      //scroll listener
      double showoffset =
          10.0; //Back to top botton will show on scroll offset 10.0

      if (scrollController.offset > showoffset) {
        showbtn = true;
        setState(() {
          //update state
        });
      } else {
        showbtn = false;
        setState(() {
          //update state
        });
      }
    });
    _initSpeech();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    streamSubscription?.cancel();

    super.dispose();
  }

  void initSetting() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);
    await flutterTts.setSpeechRate(speechRate);
    await flutterTts.setLanguage(langCode);
  }

  String gptResponse = "";
  final List<EmptyStateCardModel> list = [
    exampleCardModel,
    capabilitiesCardModel,
    limitationsCardModel
  ];

  final List<QuestionAnswer> questionAnswers = [];
  bool loading = false;
  bool showbtn = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
      bool light = themeNotifier.isDark ? true : false;
      final spinkit = SpinKitWave(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven
                  ? themeNotifier.isDark
                      ? Color(0xFFe0e0e0)
                      : Color(0xFF40414f)
                  : themeNotifier.isDark
                      ? Color(0xFF40414f)
                      : Color(0xFFe0e0e0),
            ),
          );
        },
      );

      return Scaffold(
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 5.h),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 1000), //show/hide animation
            opacity: showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
            child: FloatingActionButton.small(
              onPressed: () {
                scrollController.animateTo(
                    //go to top of scroll
                    0, //scroll offset to go
                    duration: Duration(milliseconds: 500), //duration of scroll
                    curve: Curves.fastOutSlowIn //scroll type
                    );
              },
              child: Icon(Icons.arrow_upward),
            ),
          ),
        ),
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text("Promts"),
          actions: [
            Switch(
              // This bool value toggles the switch.
              value: light,

              onChanged: (bool value) {
                // This is called when the user toggles the switch.
                setState(() {
                  light = value;
                });
                themeNotifier.isDark
                    ? themeNotifier.isDark = false
                    : themeNotifier.isDark = true;
              },
            ),
          ],
        ),
        drawer: NavigationDrawer(
            onDestinationSelected: handleScreenChanged,
            selectedIndex: screenIndex,
            children: [
              SizedBox(height: 10.h),
              NavigationDrawerDestination(
                icon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationDrawerDestination(
                icon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
              NavigationDrawerDestination(
                icon: Icon(Icons.info),
                label: Text('About'),
              ),
            ]),
        body: Column(
          children: [
            Expanded(
              child: questionAnswers.length > 0
                  ? ListView.separated(
                      itemCount: questionAnswers.length,
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,

                      // padding: EdgeInsets.only(left: 4.w, right: 4.w),
                      itemBuilder: (context, index) {
                        final questionAnswer = questionAnswers[index];
                        final answer = questionAnswer.answer.toString().trim();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                                padding: EdgeInsets.all(8),
                                child: Text('Q: ${questionAnswer.question}')),
                            const SizedBox(height: 12),
                            if (answer.isEmpty && loading)
                              SizedBox(
                                height: 4.h,
                                child: spinkit,
                              )
                            else
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: themeNotifier.isDark
                                      ? Color(0xFF40414f)
                                      : Color(0xFFe0e0e0),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        AnimatedOpacity(
                                          duration: Duration(milliseconds: 100),
                                          opacity: isSpeaking ? 1.0 : 0.0,
                                          child: IconButton(
                                            isSelected: false,
                                            onPressed: () async {
                                              initSetting();

                                              setState(() {
                                                isSpeaking = false;
                                              });
                                              await flutterTts.stop();
                                            },
                                            icon: Icon(Icons.stop),
                                          ),
                                        ),
                                        IconButton(
                                          isSelected: false,
                                          selectedIcon: Icon(Icons.volume_down),
                                          onPressed: () async {
                                            initSetting();

                                            setState(() {
                                              isSpeaking = true;
                                            });
                                            await flutterTts.speak(answer);
                                          },
                                          icon: Icon(Icons.volume_up),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Share.share('Answear: $answer',
                                                  subject:
                                                      'Question: ${questionAnswer.question}');
                                            },
                                            icon: Icon(Icons.share)),
                                        IconButton(
                                            onPressed: () async {
                                              await Clipboard.setData(
                                                  ClipboardData(
                                                      text: "$answer"));
                                            },
                                            icon: Icon(Icons.copy))
                                      ],
                                    ),
                                    Text('A: $answer'),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        20,
                        20,
                        8,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              "ChatGPT Promts",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return IntroCards(
                                  card: list[index],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: textEditingController,
                    decoration: const InputDecoration(hintText: 'Type in...'),
                    onFieldSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  style: IconButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    disabledBackgroundColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    hoverColor: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.08),
                    focusColor: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.12),
                    highlightColor: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.12),
                  ),
                ),
                IconButton(
                  icon: Icon(
                      _speechToText.isNotListening ? Icons.mic : Icons.stop),
                  onPressed: _speechToText.isNotListening
                      ? startListening
                      : stopListening,
                  style: IconButton.styleFrom(
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer,
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    disabledBackgroundColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.12),
                    hoverColor: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.08),
                    focusColor: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.12),
                    highlightColor: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.12),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  _sendMessage() async {
    final question = textEditingController.text;
    setState(() {
      textEditingController.clear();
      loading = true;
      questionAnswers.add(
        QuestionAnswer(
          question: question,
          answer: StringBuffer(),
        ),
      );
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        //do your stuff here
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(microseconds: 300), curve: Curves.easeOut);
      }
    });

    final testRequest = CompletionRequest(
      prompt: question,
      stream: true,
      maxTokens: 4000,
    );
    await _streamResponse(testRequest);
    setState(() => loading = false);
  }

  _streamResponse(CompletionRequest request) async {
    streamSubscription?.cancel();
    try {
      final stream = await chatGpt.createCompletionStream(request);
      streamSubscription = stream?.listen((event) {
        setState(
          () => questionAnswers.last.answer.write(event.choices?.first.text),
        );
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            //do your stuff here
            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Duration(microseconds: 300),
                curve: Curves.easeOut);
          }
        });
      });
    } catch (error) {
      setState(() {
        loading = false;
        questionAnswers.last.answer.write("Error");
      });
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          //do your stuff here
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: Duration(microseconds: 300), curve: Curves.easeOut);
        }
      });
    }
  }
}
