using Business.Abstract;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StudentCoursesController : ControllerBase
    {
        private readonly IStudentCourseService _studentCourseService;

        public StudentCoursesController(IStudentCourseService studentCourseService)
        {
            _studentCourseService = studentCourseService;
        }

        [HttpGet("getstudentsbycourse")]
        public IActionResult GetStudentsByCourse(int courseId)
        {
            var result = _studentCourseService.GetStudentsByCourse(courseId);
            if (result != null)
            {
                return Ok(result);
            }
            return NotFound("No students found for this course.");
        }
    }
}
