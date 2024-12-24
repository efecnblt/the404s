using Business.Abstract;
using Entities.Concrete;
using Entities.DTOs;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
   
    public class QuizController : ControllerBase
    {
        private readonly IQuizService _quizService;
        private readonly IQuestionService _questionService;
        private readonly IChoiceService _choiceService;

        public QuizController(IQuizService quizService, IQuestionService questionService, IChoiceService choiceService)
        {
            _quizService = quizService;
            _questionService = questionService;
            _choiceService = choiceService;
        }

        // Quiz ekleme
        [HttpPost("add-quiz")]
        public IActionResult AddQuizWithQuestions([FromBody] QuizWithQuestionsDto quizDto)
        {
            try
            {
                var quiz = new Quiz
                {
                    SectionID = quizDto.SectionID,
                    Name = quizDto.Name,
                    TotalPoints = quizDto.TotalPoints
                };

                var questions = quizDto.Questions.Select(q => new Question
                {
                    QuestionText = q.QuestionText,
                    Choices = q.Choices.Select(c => new Choice
                    {
                        ChoiceText = c.ChoiceText,
                        IsCorrect = c.IsCorrect
                    }).ToList()
                }).ToList();

                _quizService.AddQuizWithQuestions(quiz, questions);

                return Ok("Quiz başarıyla eklendi.");
            }
            catch (Exception ex)
            {
                return BadRequest($"Hata: {ex.Message}");
            }
        }

        // Quiz listeleme (section bazlı)
        [HttpGet("list-by-section/{sectionId}")]
        public IActionResult GetQuizzesBySectionId(int sectionId)
        {
            var quizzes = _quizService.GetQuizzesBySectionId(sectionId);
            return Ok(quizzes);
        }

        [HttpGet("CalculateQuizScore")]
        public IActionResult CalculateQuizScore(int studentId, int quizId)
        {
            var score = _quizService.CalculateQuizScore(studentId, quizId);
            return Ok(new { StudentId = studentId, QuizId = quizId, Score = score });
        }




    }


}
