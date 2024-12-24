using Business.Abstract;
using Entities.Concrete;
using Entities.DTOs;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StudentAnswersController : ControllerBase
    {
        private readonly IStudentAnswerService _studentAnswerService;

        public StudentAnswersController(IStudentAnswerService studentAnswerService)
        {
            _studentAnswerService = studentAnswerService;
        }

        [HttpPost("addAnswers")]
        public IActionResult AddAnswers(List<StudentAnswerDto> answers)
        {
            // DTO'dan StudentAnswer entity'sine dönüşüm
            var studentAnswers = answers.Select(a => new StudentAnswer
            {
                AnswerID = a.AnswerID, // Eğer AnswerID otomatik oluşturuluyorsa, bu satır kullanılmayabilir.
                StudentID = a.StudentID,
                QuestionID = a.QuestionID,
                ChoiceID = a.ChoiceID
            }).ToList();

            // Servis aracılığıyla ekleme işlemi
            _studentAnswerService.AddAnswers(studentAnswers);

            return Ok("Answers added successfully.");
        }


        [HttpGet("getScore")]
        public IActionResult GetScore(int studentId, int quizId)
        {
            var score = _studentAnswerService.CalculateScore(studentId, quizId);
            return Ok(new { StudentID = studentId, QuizID = quizId, Score = score });
        }
    }
}