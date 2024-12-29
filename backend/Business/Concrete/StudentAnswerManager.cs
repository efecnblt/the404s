using Business.Abstract;
using DataAccess.Abstract;
using DataAccess.Concrete.EntityFramework;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Business.Concrete
{
    public class StudentAnswerManager : IStudentAnswerService
    {
        private readonly IStudentAnswerDal _studentAnswerDal;
        private readonly IChoiceService _choiceService; // Servis kullanıyoruz
        private readonly IQuestionService _questionService; // Servis kullanıyoruz

        public StudentAnswerManager(IStudentAnswerDal studentAnswerDal, IChoiceService choiceService, IQuestionService questionService)
        {
            _studentAnswerDal = studentAnswerDal;
            _choiceService = choiceService;
            _questionService = questionService;
        }

        public void Add(StudentAnswer studentAnswer)
        {
            _studentAnswerDal.Add(studentAnswer);
        }

        public void AddAnswers(List<StudentAnswer> studentAnswers)
        {
            foreach (var answer in studentAnswers)
            {
                _studentAnswerDal.Add(answer);
            }


            // Quiz skoru hesaplama (herhangi bir quizID'ye göre)
            if (studentAnswers.Any())
            {
                var quizId = _questionService.GetById(studentAnswers.First().QuestionID).QuizID;
                var studentId = studentAnswers.First().StudentID;

                // Quiz skoru hesapla ve güncelle
                var score = CalculateScore(studentId, quizId);

                // QuizResults tablosunu güncelle
                AddOrUpdateQuizResult(studentId, quizId, score);
            }
        }

        public List<StudentAnswer> GetAnswersByStudent(int studentId, int quizId)
        {
            return _studentAnswerDal.GetAnswersByStudent(studentId, quizId);
        }

        public int CalculateScore(int studentId, int quizId)
        {
            using (var context = new SWContext())
            {
                var studentAnswers = context.StudentAnswers
                    .Where(sa => sa.Question.QuizID == quizId && sa.StudentID == studentId)
                    .ToList();

                int totalScore = 0;

                foreach (var answer in studentAnswers)
                {
                    var correctChoice = context.Choices
                        .FirstOrDefault(c => c.QuestionID == answer.QuestionID && c.IsCorrect);

                    if (correctChoice != null && correctChoice.ChoiceID == answer.ChoiceID)
                    {
                        var question = context.Questions.FirstOrDefault(q => q.QuestionID == answer.QuestionID);
                        if (question != null)
                        {
                            totalScore += question.Points;
                        }
                    }
                }

                return totalScore; // Toplam puanı döndür
            }
        }



        private void AddOrUpdateQuizResult(int studentId, int quizId, int score)
        {
            using (var context = new SWContext())
            {
                var existingResult = context.StudentQuizResults
                    .FirstOrDefault(qr => qr.StudentID == studentId && qr.QuizID == quizId);

                if (existingResult == null)
                {
                    context.StudentQuizResults.Add(new StudentQuizResult
                    {
                        StudentID = studentId,
                        QuizID = quizId,
                        Score = score,
                        TotalPoints = 100, // Örnek bir değer
                        Percentage = (float)score / 100 * 100, // Explicit cast to float
                        CompletedDate = DateTime.Now
                    });
                }
                else
                {
                    existingResult.Score = score;
                    existingResult.Percentage = (float)score / 100 * 100; // Explicit cast to float
                    existingResult.CompletedDate = DateTime.Now;
                }

                context.SaveChanges();
            }
        }



        public List<StudentAnswer> GetAll(Expression<Func<StudentAnswer, bool>> filter = null)
        {
            return _studentAnswerDal.GetAll(filter);
        }

    }
}
