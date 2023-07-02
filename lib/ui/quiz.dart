import 'dart:async';

import 'package:first_flutter_app/util/requests.dart';
import 'package:flutter/cupertino.dart';
import 'package:first_flutter_app/model/question.dart';
import 'package:flutter/material.dart';

class QuizApp extends StatefulWidget {
  const QuizApp(this.difficulty, {super.key});

  final Difficulty difficulty;

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _questioncount = 0;

  late Future<List<Question>> futureQuestionBank;

  @override
  void initState() {
    super.initState();
    futureQuestionBank = fetchQuestions(widget.difficulty);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureQuestionBank,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(backgroundColor: Colors.blueGrey);
          }
          if (snapshot.hasError) {
            throw Exception('データ取得に失敗しました');
          }
          final questionBank = snapshot.data!;
          final problemImageURL =
              questionBank[_currentQuestionIndex].problemImageURL;
          return Scaffold(
            // appBar: AppBar(
            //   title: Text("${_currentQuestionIndex + 1}問目"),
            //   centerTitle: true,
            //   backgroundColor: Colors.blueGrey,
            // ),
            backgroundColor: Colors.yellow,
            body: Builder(
              builder: (BuildContext context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 30,
                          left: 20,
                        ),
                        width: 250,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                          child: Text(
                            "QUESTION",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 30,
                          right: 30,
                          bottom: 10,
                        ),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.deepPurpleAccent,
                            width: 10,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${_currentQuestionIndex + 1}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: quizImage(problemImageURL),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 20),
                            alignment: Alignment.bottomRight,
                            width: MediaQuery.of(context).size.width * 2 / 5,
                            height: 120,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _checkAnswer(AnswerOption.A, context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey.shade900,
                                minimumSize: Size(80, 80),
                                shape: const CircleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "A",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 2 / 5,
                            height: 120,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _checkAnswer(AnswerOption.B, context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey.shade900,
                                minimumSize: Size(80, 80),
                                shape: const CircleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "B",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.bottomRight,
                            width: MediaQuery.of(context).size.width * 2 / 5,
                            height: 115,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _checkAnswer(AnswerOption.C, context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey.shade900,
                                minimumSize: Size(80, 80),
                                shape: const CircleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "C",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            width: MediaQuery.of(context).size.width * 2 / 5,
                            height: 115,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _checkAnswer(AnswerOption.D, context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey.shade900,
                                minimumSize: Size(80, 80),
                                shape: const CircleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              child: const Text(
                                "D",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          );
        });
  }

  _checkAnswer(AnswerOption userChoice, BuildContext context) async {
    final questionBank = await futureQuestionBank;
    if (!mounted) return;

    ///正解した時に scoreが上がる
    if (userChoice == questionBank[_currentQuestionIndex].correctAnswer) {
      _score = _score + 1;
    }

    ///何問目か
    _questioncount = _questioncount + 1;
    debugPrint("Questioncounts(now)=$_questioncount");

    ///現在の得点
    debugPrint("Score(now)=$_score");
    await _dialogBuilder(context, userChoice);
    _nextQuestion();
  }

  Future<void> _dialogBuilder(
      BuildContext context, AnswerOption userChoice) async {
    final questionBank = await futureQuestionBank;
    if (!mounted) return;
    final isCorrect =
        userChoice == questionBank[_currentQuestionIndex].correctAnswer;
    final answerImageURL = questionBank[_currentQuestionIndex].answerImageURL;
    return showDialog<void>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: isCorrect
                ? Image(
                    image: AssetImage("images/IMG_0587.PNG"),
                  )
                : Image(
                    image: AssetImage("images/IMG_0590.PNG"),
                  ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: quizImage(answerImageURL),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image(
                    image: AssetImage("images/IMG_0588.PNG"),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _updateQuestion() async {
    final questionBank = await futureQuestionBank;
    setState(() {
      _currentQuestionIndex = (_currentQuestionIndex + 1) % questionBank.length;
    });
  }

  _nextQuestion() {
    _updateQuestion();
  }

  Widget quizImage(String imageUrl) {
    return Container(
      width: 400,
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 5,
        ),
        borderRadius: BorderRadius.circular(10),
        // shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
