using Business.Abstract;
using Entities.Concrete;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SectionsController : ControllerBase
    {
        private readonly ISectionService _sectionService;

        public SectionsController(ISectionService sectionService)
        {
            _sectionService = sectionService;
        }

        [HttpGet("course/{courseId}")]
        public IActionResult GetSectionsByCourseId(int courseId)
        {
            var result = _sectionService.GetSectionsByCourseId(courseId);
            return Ok(result);
        }

        [HttpPost("add")]
        public IActionResult Add(Section section)
        {
            _sectionService.Add(section);
            return Ok("Section added successfully");
        }

        [HttpPost("update")]
        public IActionResult Update(Section section)
        {
            _sectionService.Update(section);
            return Ok("Section updated successfully");
        }

        [HttpDelete("{sectionId}")]
        public IActionResult Delete(int sectionId)
        {
            _sectionService.Delete(sectionId);
            return Ok("Section deleted successfully");
        }
    }

}
