using Business.Abstract;
using Entities.Concrete;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LearningOutcomesController : ControllerBase
    {
        private readonly ILearningOutcomeService _learningOutcomeService;

        public LearningOutcomesController(ILearningOutcomeService learningOutcomeService)
        {
            _learningOutcomeService = learningOutcomeService;
        }

        [HttpPost("add")]
        public IActionResult Add([FromBody] LearningOutcome outcome)
        {
            var result = _learningOutcomeService.Add(outcome);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Message);
        }

        [HttpGet("getByCourseId")]
        public IActionResult GetByCourseId(int courseId)
        {
            var result = _learningOutcomeService.GetByCourseId(courseId);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Data);
        }
    }
}
