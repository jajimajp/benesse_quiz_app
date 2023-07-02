import 'dart:async';

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
            appBar: AppBar(
              title: Text("${_currentQuestionIndex + 1}問目"),
              centerTitle: true,
              backgroundColor: Colors.blueGrey,
            ),
            backgroundColor: Colors.blueGrey,
            body: Builder(
              builder: (BuildContext context) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: quizImage(problemImageURL),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () =>
                              _checkAnswer(AnswerOption.A, context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey.shade900,
                          ),
                          child: const Text("A")),
                      ElevatedButton(
                        onPressed: () => _checkAnswer(AnswerOption.B, context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade900,
                        ),
                        child: const Text("B"),
                      ),
                      ElevatedButton(
                        onPressed: () => _checkAnswer(AnswerOption.C, context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade900,
                        ),
                        child: const Text("C"),
                      ),
                      ElevatedButton(
                        onPressed: () => _checkAnswer(AnswerOption.D, context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade900,
                        ),
                        child: const Text("D"),
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
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: isCorrect ? const Text("正解") : const Text("不正解"),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: quizImage(answerImageURL),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("次の問題へ")),
              ],
            ),
          );
        });
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: isCorrect ? const Text("正解") : const Text("不正解"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: quizImage(answerImageURL),
              ),
              const Spacer(),
              Expanded(
              child: (() { // 関数を使う
                if (_questioncount == questionBank.length) {
                  return TextButton(onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Quizresult(param:"$_score"),
                      )
                    );
                  }, child: const Text("結果"),
                  );
                } else {
                  return TextButton(onPressed: () {
                    Navigator.of(context).pop();
                  }, child: const Text("次の問題へ"),
                  );
                }
              })(),
              ),
            ],
          ),
        );
      }
    );
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
        // shape: BoxShape.circle,
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
