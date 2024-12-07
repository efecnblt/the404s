import 'package:flutter/material.dart';
import 'package:cyber_security_app/screens/quiz_screen/models/quiz_question_template.dart';
import 'package:cyber_security_app/screens/quiz_screen/quiz/results_page.dart';
import 'package:cyber_security_app/screens/quiz_screen/quiz/quiz_page.dart';
class MainQuizPage extends StatelessWidget {
  MainQuizPage({super.key});

  final List<QuizQuestion> _questions = [
    QuizQuestion(
      question: 'What was the first product launched by Apple?',
      answers: ['iPhone', 'iPad', 'Apple', 'iPod'],
      correctanswer: 'Apple',
    ),
    QuizQuestion(
      question: 'Who founded Microsoft?',
      answers: ['Steve Jobs', 'Bill Gates', 'Elon Musk', 'Jeff Bezos'],
      correctanswer: 'Bill Gates',
    ),
  ];

  late final List<String?> _selectedAnswers = List.filled(_questions.length, null);
  int _score = 0;

  void _startQuiz(BuildContext context) async {
    int startTime = DateTime.now().millisecondsSinceEpoch;
    _score = 0;

    for (int i = 0; i < _questions.length; i++) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizPage(
            currentQuestionIndex: i,
            question: _questions[i],
            shuffleAnswers: _questions[i].shuffleAnswers(),
            totalQuestions: _questions.length,
          ),
        ),
      ) as Map<String, dynamic>?;

      if (result != null) {
        _selectedAnswers[i] = result['selectedAnswer'];
        if (result['correct']) {
          int elapsedTime = result['timeTaken'];
          _score += 10 * (10 - elapsedTime~/2);
        }
      }
    }
    _showResults(context);
  }

  void _showResults(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultsPage(
          questions: _questions,
          selectedAnswers: _selectedAnswers,
          score: _score,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "Quiz Time!",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // navigate to where the course is
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Quiz Subject",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "This quiz contains ${_questions.length} questions. "
              "It's a time-based quiz, so the faster you answer, the more points you earn. "
              "Test your knowledge and aim for the highest score!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 40),
            Icon(
              Icons.timer,
              size: 100,
              color: Colors.purple.shade400,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _startQuiz(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Start Quiz',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
