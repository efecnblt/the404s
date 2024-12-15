using Business.Abstract;
using Entities.Concrete;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LevelsController : ControllerBase
    {
        private readonly ILevelService _levelService;

        public LevelsController(ILevelService levelService)
        {
            _levelService = levelService;
        }

        [HttpGet("getall")]
        public IActionResult GetAll()
        {
            var result = _levelService.GetAll();
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Data);
        }

        [HttpGet("getbyid/{id}")]
        public IActionResult GetById(int id)
        {
            var result = _levelService.GetById(id);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Data);
        }

        [HttpPost("add")]
        public IActionResult Add(Level level)
        {
            var result = _levelService.Add(level);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Message);
        }

        [HttpPut("update")]
        public IActionResult Update(Level level)
        {
            var result = _levelService.Update(level);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Message);
        }

        [HttpDelete("delete/{id}")]
        public IActionResult Delete(int id)
        {
            var level = _levelService.GetById(id).Data;
            if (level == null)
            {
                return NotFound("Level not found.");
            }

            var result = _levelService.Delete(level);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Message);
        }
    }
}
