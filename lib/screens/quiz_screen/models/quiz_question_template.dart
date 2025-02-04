// Updated quiz_question_template.dart to support backend API integration
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizQuestion {
  final String question;
  final List<String> answers;
  final String correctAnswer;

  const QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctAnswer,
  });

  List<String> shuffleAnswers() {
    List<String> shuffledAnswers = List.from(answers);
    shuffledAnswers.shuffle();
    return shuffledAnswers;
  }

  // Factory constructor to create a QuizQuestion from a map
  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'] ?? '',
      answers: List<String>.from(map['answers'] ?? []),
      correctAnswer: map['correctAnswer'] ?? '',
    );
  }

  // Method to fetch quiz questions from backend
  static Future<List<QuizQuestion>> fetchQuestions(String quizId) async {
    const String baseUrl = 'http://165.232.76.61:5001/api';
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/Quiz/list-by-section/$quizId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((question) => QuizQuestion.fromMap(question)).toList();
      } else {
        throw Exception('Failed to fetch quiz questions');
      }
    } catch (e) {
      print('Error fetching quiz questions: $e');
      return [];
    }
  }

  // Method to convert a QuizQuestion to a map (if needed for saving)
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answers': answers,
      'correctAnswer': correctAnswer,
    };
  }
}
