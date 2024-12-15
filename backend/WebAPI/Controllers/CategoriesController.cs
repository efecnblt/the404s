using Business.Abstract;
using Entities.Concrete;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoriesController : ControllerBase
    {
        private readonly ICategoryService _categoryService;

        public CategoriesController(ICategoryService categoryService)
        {
            _categoryService = categoryService;
        }

        [HttpGet("getall")]
        public IActionResult GetAll()
        {
            var result = _categoryService.GetAll();
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Data);
        }

        [HttpGet("getbyid/{id}")]
        public IActionResult GetById(int id)
        {
            var result = _categoryService.GetById(id);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Data);
        }

        [HttpPost("add")]
        public IActionResult Add(Category category)
        {
            var result = _categoryService.Add(category);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Message);
        }

        [HttpPut("update")]
        public IActionResult Update(Category category)
        {
            var result = _categoryService.Update(category);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Message);
        }

        [HttpDelete("delete/{id}")]
        public IActionResult Delete(int id)
        {
            var category = _categoryService.GetById(id).Data;
            if (category == null)
            {
                return NotFound("Category not found.");
            }

            var result = _categoryService.Delete(category);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Message);
        }
    }
}
