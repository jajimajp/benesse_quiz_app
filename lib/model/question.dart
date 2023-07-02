enum AnswerOption { A, B, C, D }

class Question {
  AnswerOption correctAnswer;
  String problemImageURL;
  String answerImageURL;

  Question.name(this.correctAnswer, this.problemImageURL, this.answerImageURL);
}
