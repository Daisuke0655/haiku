import 'package:flutter/material.dart';
import 'package:dart_openai/openai.dart';
import 'package:http/http.dart' as http;

void main() {
  var apiKey = "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";
  OpenAI.apiKey = apiKey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<String> responses = [];
  List<String> response = [];
  double screenWidth = 0;
  double screenHeight = 0;
  bool isBusy = false;
  bool pushExplanation = false;
  @override
  void initState(){
    setState(() {});
    super.initState();
  }
  void generateHaiku() async{
    int _haikuCounter = 0;
    isBusy = true;
    setState(() {});
    while(response.length <2){
      _haikuCounter++;
      if(_haikuCounter == 3) break;
      OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content:
            "春をテーマに俳句をひとつだけ読んでください。必ず一行で終わるようにしてください",
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );
      response=chatCompletion.choices.first.message.content.split("　");
    }
    for(String text in response){
      responses.add(text);
      print(text);
    }
    //responses[2]までにそれぞれ俳句の要素が入っている
    isBusy = false;
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          mainPageWidget(),
          Positioned(
            right: MediaQuery.of(context).size.width/1.235,
            bottom: MediaQuery.of(context).size.width/1.235,
            child: pushExplanation ? _explanationWidget() : const SizedBox(),
          ),
        ],
      ),
    );
  }
  Widget mainPageWidget(){
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (){
                  pushExplanation ? pushExplanation = false : pushExplanation = true;
                },
                icon: Icon(Icons.question_mark),
              ),
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/12,
                    height: MediaQuery.of(context).size.width/23,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const Text("userName"),
                ],
              ),
            ],
          ),
          Container(
            color: Colors.blueAccent,
            height: MediaQuery.of(context).size.height/12,
            width: MediaQuery.of(context).size.width/4,
          ),
          TextButton(
              onPressed: (){},
              child: Container(
                alignment: Alignment.center,
                width: screenWidth/3,
                height: screenHeight/10,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                    'join'
                ),
              )
          ),
          const SizedBox(),
        ],
      ),
    );
  }
  Widget _explanationWidget(){
    return Container();
  }
}
