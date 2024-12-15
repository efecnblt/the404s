using Business.Abstract;
using Entities.Concrete;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class VideosController : ControllerBase
    {
        IVideoService _videoService;

        public VideosController(IVideoService videoService)
        {
            _videoService = videoService;
        }

        [HttpGet("section/{sectionId}")]
        public IActionResult GetVideosBySectionId(int sectionId)
        {
            var result = _videoService.GetVideosBySectionId(sectionId);
            return Ok(result);
        }

        [HttpPost("add")]
        public IActionResult Add(Video video)
        {
            _videoService.Add(video);
            return Ok("Video added successfully");
        }

        [HttpPost("update")]
        public IActionResult Update(Video video)
        {
            _videoService.Update(video);
            return Ok("Video updated successfully");
        }

        [HttpDelete("{videoId}")]
        public IActionResult Delete(int videoId)
        {
            _videoService.Delete(videoId);
            return Ok("Video deleted successfully");
        }
    }
}
