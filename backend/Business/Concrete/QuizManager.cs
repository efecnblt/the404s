using Business.Abstract;
using DataAccess.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Concrete
{
    public class QuizManager : IQuizService
    {
        private readonly IQuizDal _quizDal;
        private readonly IQuestionService _questionService;
        private readonly IChoiceService _choiceService;

        public QuizManager(IQuizDal quizDal,IQuestionService questionservice,IChoiceService choiceservice)
        {
            _quizDal = quizDal;
            _questionService = questionservice;
            _choiceService = choiceservice;
        }

        public void Add(Quiz quiz)
        {
            _quizDal.Add(quiz);
        }

        public void Update(Quiz quiz)
        {
            _quizDal.Update(quiz);
        }

        public void Delete(int quizId)
        {
            var quiz = _quizDal.Get(q => q.QuizID == quizId);
            if (quiz != null)
            {
                _quizDal.Delete(quiz);
            }
        }

        public List<Quiz> GetQuizzesBySectionId(int sectionId)
        {
            return _quizDal.GetQuizzesBySectionId(sectionId);
        }


        public void AddQuizWithQuestions(Quiz quiz, List<Question> questions)
        {
            // Quiz ekle
            _quizDal.Add(quiz);

            foreach (var question in questions)
            {
                question.QuizID = quiz.QuizID;
                _questionService.Add(question);

                foreach (var choice in question.Choices)
                {
                    choice.QuestionID = question.QuestionID;
                    _choiceService.Add(choice);
                }
            }
        }

    }

}
