import 'dart:ffi';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:audioplayers/audioplayers.dart';
import 'fun_codes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white12,
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
        ).apply(
          bodyColor: Colors.white,
        ),
        primarySwatch: Colors.lightGreen,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechToText _speechToText = SpeechToText();
  List _localeNames = [];
  String _currentLocaleId = "";
  bool speechEnabled = false;
  String _lastWords = '';
  String result = '';

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  List ayah_id_List = [];
  List<Widget> ayah_widget_List = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();

    setAudio();
    // listen to states: playing, paused, stopped
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    // listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  Future setAudio() async {
    // load audio from URL
    String url = await get_voice_url(sttRes());
    // String url = 'http://www.everyayah.com/data/MaherAlMuaiqly128kbps/002285.mp3';
    audioPlayer.setSourceUrl(url);
  }

  String formatTime(Duration position) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigit(duration.inHours);
    final minutes = twoDigit(duration.inMinutes.remainder(60));
    final seconds = twoDigit(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  void _initSpeech() async {
    /// This has to happen only once per app
    bool _speechEnabled = await _speechToText.initialize();
    if (_speechEnabled) {
      _localeNames = await _speechToText.locales();
      var systemLocale = await _speechToText.systemLocale();
      _currentLocaleId = systemLocale!.localeId;
    }
    if (!mounted) return;
    setState(() {
      speechEnabled = _speechEnabled;
    });
  }

  void _startListening() async {
    /// Each time to start a speech recognition session
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    /// Manually stop the active speech recognition session
    /// Note that there are also timeouts that each platform enforces
    /// and the SpeechToText plugin supports setting timeouts on the
    /// listen method.
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    /// This is the callback that the SpeechToText plugin calls when
    /// the platform returns recognized words.
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.lightGreen.withOpacity(0.1)),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(7),
              child: Text(
                speechEnabled
                    ? 'إضغط على الميكروفون لبدء الإستماع'
                    : 'خاصية الإستماع غير متوفرة/مفعلة',
                style: TextStyle(fontSize: 20.0),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.lightGreen.withOpacity(0)),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(7),
              child: Text(
                // If listening is active show the recognized words
                _speechToText.isListening ? '$_lastWords' : '$_lastWords',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Container(
              child: _speechToText.hasRecognized ? output() : Container(),
            ),
            Container(
              child:
                  _speechToText.hasRecognized ? debuging_output() : Container(),
            ),
            SizedBox(height: 125),
          ]),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _speechToText.isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 50.0,
        duration: const Duration(milliseconds: 3000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton.large(
          onPressed:
              // If not yet listening for speech start, otherwise stop
              _speechToText.isNotListening ? _startListening : _stopListening,
          tooltip: 'Listen',
          child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        ),
      ),
    );
  }


  String sttRes() {
    if (_speechToText.lastRecognizedWords == Null) {
      return ' ';
    } else {
      return _speechToText.lastRecognizedWords;
    }
  }

  Widget output() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.lightGreen.withOpacity(0.1)),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('رقم الآية'),
                    const SizedBox(width: 10, height: 10),
                    FutureBuilder<String>(
                        future: get_ayah_num(sttRes()),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          List<Widget> children = [];
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Text(
                                '${snapshot.data}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                              )
                            ];
                          } else if (snapshot.hasError) {
                            children = <Widget>[
                              Text(
                                'Error: ${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                              )
                            ];
                          }
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children,
                            ),
                          );
                        }),
                  ],
                )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('إسم السورة'),
                    const SizedBox(width: 10, height: 3),
                    FutureBuilder<String>(
                        future: get_surah_name(sttRes()),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          List<Widget> children = [];
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Text(
                                '${snapshot.data}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                              )
                            ];
                          } else if (snapshot.hasError) {
                            children = <Widget>[
                              Text(
                                'Error: ${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                              )
                            ];
                          }
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children,
                            ),
                          );
                        }),
                  ],
                )),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('رقم الجزء'),
                    const SizedBox(width: 10, height: 10),
                    FutureBuilder<String>(
                        future: get_surah_chapter(sttRes()),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          List<Widget> children = [];
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Text(
                                '${snapshot.data}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                              )
                            ];
                          } else if (snapshot.hasError) {
                            children = <Widget>[
                              Text(
                                'Error: ${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                              )
                            ];
                          }
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children,
                            ),
                          );
                        }),
                  ],
                )),
              ],
            )),
        Container(
            // the player container
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.lightGreen.withOpacity(0.1)),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FutureBuilder<String>(
                      future: get_img_url(sttRes()),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        List<Widget> children = [];
                        if (snapshot.hasData) {
                          children = <Widget>[
                            Image.network(
                              '${snapshot.data}',
                              color: Colors.white,
                            ),
                          ];
                        } else if (snapshot.hasError) {
                          children = <Widget>[
                            Text(
                              'Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20.0),
                            )
                          ];
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: children,
                          ),
                        );
                      }),
                ),
                Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                      // play audio if it was paused
                      await audioPlayer.resume();
                    }),
                /*
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(position)),
                        Text(formatTime(duration)),
                      ],
                    ),
                  ),
                  */
                CircleAvatar(
                  radius: 35,
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    iconSize: 50,
                    onPressed: () async {
                      setAudio();
                      if (isPlaying) {
                        await audioPlayer.pause();
                      } else {
                        await audioPlayer.resume();
                      }
                    },
                  ),
                )
              ],
            )),
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.lightGreen.withOpacity(0.1)),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(7),
            child: Column(
              children: [
                const Text(
                  '-{ التفسير }-',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 25.0),
                ),
                FutureBuilder<String>(
                    future: get_ayah_tafseer(sttRes()),
                    builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      List<Widget> children = [];
                      if (snapshot.hasData) {
                        children = <Widget>[
                          Text(
                            '${snapshot.data}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.0),
                          )
                        ];
                      } else if (snapshot.hasError) {
                        children = <Widget>[
                          Text(
                            'Error: ${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20.0),
                          )
                        ];
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: children,
                        ),
                      );
                    }),
              ],
            )),
      ],
    );
  }

  Future<Widget> output2() async {
    List list = await id_List();
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.lightGreen.withOpacity(0.1)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('رقم الآية'),
                          SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          FutureBuilder<String>(
                              future: get_ayah_num(list[index]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                List<Widget> children = [];
                                if (snapshot.hasData) {
                                  children = <Widget>[
                                    Text(
                                      '${snapshot.data}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                    )
                                  ];
                                } else if (snapshot.hasError) {
                                  children = <Widget>[
                                    Text(
                                      'Error: ${snapshot.error}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                    )
                                  ];
                                }
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: children,
                                  ),
                                );
                              }),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('إسم السورة'),
                          SizedBox(width: 10, height: 3),
                          FutureBuilder<String>(
                              future: get_surah_name(list[index]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                List<Widget> children = [];
                                if (snapshot.hasData) {
                                  children = <Widget>[
                                    Text(
                                      '${snapshot.data}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                    )
                                  ];
                                } else if (snapshot.hasError) {
                                  children = <Widget>[
                                    Text(
                                      'Error: ${snapshot.error}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                    )
                                  ];
                                }
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: children,
                                  ),
                                );
                              }),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('رقم الجزء'),
                          SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          FutureBuilder<String>(
                              future: get_surah_chapter(list[index]),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                List<Widget> children = [];
                                if (snapshot.hasData) {
                                  children = <Widget>[
                                    Text(
                                      '${snapshot.data}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                    )
                                  ];
                                } else if (snapshot.hasError) {
                                  children = <Widget>[
                                    Text(
                                      'Error: ${snapshot.error}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20.0),
                                    )
                                  ];
                                }
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: children,
                                  ),
                                );
                              }),
                        ],
                      )),
                    ],
                  )),
              Container(
                  // the player container
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.lightGreen.withOpacity(0.1)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(7),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FutureBuilder<String>(
                            future: get_img_url(list[index]),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              List<Widget> children = [];
                              if (snapshot.hasData) {
                                children = <Widget>[
                                  Image.network(
                                    '${snapshot.data}',
                                    color: Colors.white,
                                  ),
                                ];
                              } else if (snapshot.hasError) {
                                children = <Widget>[
                                  Text(
                                    'Error: ${snapshot.error}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20.0),
                                  )
                                ];
                              }
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: children,
                                ),
                              );
                            }),
                      ),
                      Slider(
                          min: 0,
                          max: duration.inSeconds.toDouble(),
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await audioPlayer.seek(position);
                            // play audio if it was paused
                            await audioPlayer.resume();
                          }),
                      /*
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(position)),
                        Text(formatTime(duration)),
                      ],
                    ),
                  ),
                  */
                      CircleAvatar(
                        radius: 35,
                        child: IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          iconSize: 50,
                          onPressed: () async {
                            setAudio();
                            if (isPlaying) {
                              await audioPlayer.pause();
                            } else {
                              await audioPlayer.resume();
                            }
                          },
                        ),
                      )
                    ],
                  )),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.lightGreen.withOpacity(0.1)),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(7),
                  child: Column(
                    children: [
                      Text(
                        '-{ التفسير }-',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 25.0),
                      ),
                      FutureBuilder<String>(
                          future: get_ayah_tafseer(list[index]),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            List<Widget> children = [];
                            if (snapshot.hasData) {
                              children = <Widget>[
                                Text(
                                  '${snapshot.data}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                )
                              ];
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                Text(
                                  'Error: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                )
                              ];
                            }
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: children,
                              ),
                            );
                          }),
                    ],
                  )),
            ],
          );
        });
  }

  Future<List> ayah_list(sttRes()) async {
    var list = await find_occurrences(sttRes());
    return list;
  }

  Future<List> id_List() async {
    return await find_occurrences(sttRes());
  }

  /*
  void add_ayah_widget(id) {
    setState(() {
      ayah_widget_List.add(ayah_widget(id));
    });
  }
   */

  Widget ayah_widget(id) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.lightGreen.withOpacity(0)),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.lightGreen.withOpacity(0.1)),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('رقم الآية'),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      FutureBuilder<String>(
                          future: get_ayah_num1(id),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            List<Widget> children = [];
                            if (snapshot.hasData) {
                              children = <Widget>[
                                Text(
                                  '${snapshot.data}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                )
                              ];
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                Text(
                                  'Error: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                )
                              ];
                            }
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: children,
                              ),
                            );
                          }),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('إسم السورة'),
                      SizedBox(width: 10, height: 3),
                      FutureBuilder<String>(
                          future: get_surah_name1(id),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            List<Widget> children = [];
                            if (snapshot.hasData) {
                              children = <Widget>[
                                Text(
                                  '${snapshot.data}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                )
                              ];
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                Text(
                                  'Error: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                )
                              ];
                            }
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: children,
                              ),
                            );
                          }),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('رقم الجزء'),
                      SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      FutureBuilder<String>(
                          future: get_surah_chapter1(id),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            List<Widget> children = [];
                            if (snapshot.hasData) {
                              children = <Widget>[
                                Text(
                                  '${snapshot.data}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                )
                              ];
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                Text(
                                  'Error: ${snapshot.error}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20.0),
                                )
                              ];
                            }
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: children,
                              ),
                            );
                          }),
                    ],
                  )),
                ],
              )),
          Container(
              // the player container
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.lightGreen.withOpacity(0.1)),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FutureBuilder<String>(
                        future: get_img_url1(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          List<Widget> children = [];
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Image.network(
                                '${snapshot.data}',
                                color: Colors.white,
                              ),
                            ];
                          } else if (snapshot.hasError) {
                            children = <Widget>[
                              Text(
                                'Error: ${snapshot.error}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                              )
                            ];
                          }
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: children,
                            ),
                          );
                        }),
                  ),
                  Slider(
                      min: 0,
                      max: duration.inSeconds.toDouble(),
                      value: position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await audioPlayer.seek(position);
                        // play audio if it was paused
                        await audioPlayer.resume();
                      }),
                  /*
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatTime(position)),
                        Text(formatTime(duration)),
                      ],
                    ),
                  ),
                  */
                  CircleAvatar(
                    radius: 35,
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                      ),
                      iconSize: 50,
                      onPressed: () async {
                        setAudio();
                        if (isPlaying) {
                          await audioPlayer.pause();
                        } else {
                          await audioPlayer.resume();
                        }
                      },
                    ),
                  )
                ],
              )),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.lightGreen.withOpacity(0.1)),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(7),
              child: Column(
                children: [
                  const Text(
                    '-{ التفسير }-',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 25.0),
                  ),
                  FutureBuilder<String>(
                      future: get_ayah_tafseer1(id),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        List<Widget> children = [];
                        if (snapshot.hasData) {
                          children = <Widget>[
                            Text(
                              '${snapshot.data}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20.0),
                            )
                          ];
                        } else if (snapshot.hasError) {
                          children = <Widget>[
                            Text(
                              'Error: ${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20.0),
                            )
                          ];
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: children,
                          ),
                        );
                      }),
                ],
              )),
        ],
      ),
    );
  }

  Widget debuging_output() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.lightGreen.withOpacity(0.1)),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(7),
      child: FutureBuilder<List>(
          future: find_occurrences(sttRes()),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            List<Widget> children = [];
            if (snapshot.hasData) {
              List? ayah_list = snapshot.data;
              for (var i in ayah_list!) {
                // add_ayah_widget(i);
                // ayah_id_List.add(i);
              }
              children = <Widget>[
                Text(
                  '${snapshot.data}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                )
              ];
            } else if (snapshot.hasError) {
              children = <Widget>[
                Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                )
              ];
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          }),
    );
  }
}
