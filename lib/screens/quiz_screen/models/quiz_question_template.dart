class QuizQuestion {
  const QuizQuestion({required this.question,required this.answers,required this.correctanswer});

  final String question;
  final List<String> answers;
  final String correctanswer;

  List<String> shuffleAnswers() {
    List<String> shuffledAnswers = answers;
    shuffledAnswers.shuffle();
    return shuffledAnswers;
  }

  
}