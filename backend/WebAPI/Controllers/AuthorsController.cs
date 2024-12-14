using Business.Abstract;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthorsController : ControllerBase
    {
        private readonly IAuthorService _authorService;

        public AuthorsController(IAuthorService authorService)
        {
            _authorService = authorService;
        }

        // Tüm yazarları getiren endpoint
        [HttpGet("getall")]
        public IActionResult GetAll()
        {
            var result = _authorService.GetAll();
            if (result == null)
            {
                return BadRequest("No authors found.");
            }
            return Ok(result);
        }

        // ID'ye göre tek bir yazarı getiren endpoint
        [HttpGet("getbyid/{authorId}")]
        public IActionResult GetById(int authorId)
        {
            var result = _authorService.GetById(authorId);
            if (result == null)
            {
                return NotFound("Author not found.");
            }
            return Ok(result);
        }


        [HttpGet("top-rated-authors")]
        public IActionResult GetTopRatedAuthors()
        {
            var result = _authorService.GetTopRatedAuthors();
            return Ok(result);
        }

        [HttpGet("most-students-authors")]
        public IActionResult GetAuthorsByMostStudents()
        {
            var result = _authorService.GetAuthorsByMostStudents();
            return Ok(result);
        }

    }
}
