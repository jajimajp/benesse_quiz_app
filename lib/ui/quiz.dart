import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:first_flutter_app/model/question.dart';
import 'package:flutter/material.dart';

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  List<Question> questionBank = [
    Question.name(AnswerOption.A, 'https://placehold.jp/150x150.png',
        'https://placehold.jp/150x150.png'),
    Question.name(AnswerOption.B, 'https://placehold.jp/150x150.png',
        'https://placehold.jp/150x150.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final problemImageURL = questionBank[_currentQuestionIndex].problemImageURL;
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
                    onPressed: () => _checkAnswer(AnswerOption.A, context),
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
  }

  _checkAnswer(AnswerOption userChoice, BuildContext context) async {
    if (userChoice == questionBank[_currentQuestionIndex].correctAnswer) {
      _score = _score + 1;
    }
    debugPrint("$_score");
    await _dialogBuilder(context, userChoice);
    _nextQuestion();
  }

  Future<void> _dialogBuilder(BuildContext context, AnswerOption userChoice) {
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
  }

  _updateQuestion() {
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
