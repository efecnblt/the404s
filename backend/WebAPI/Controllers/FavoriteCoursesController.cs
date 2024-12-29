using Business.Abstract;
using Entities.Concrete;
using Entities.DTOs;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FavoriteCoursesController : ControllerBase
    {
        IFavoriteCourseService _favoriteCourseService;
        IAuthorService _authorService;
        private readonly ICourseService _courseService;

        public FavoriteCoursesController(IFavoriteCourseService favoriteCourseService, IAuthorService authorService, ICourseService courseService)
        {
            _favoriteCourseService = favoriteCourseService;
            _authorService = authorService;
            _courseService = courseService;
        }

        [HttpPost("addToFavorites")]
        public IActionResult AddToFavorites(int studentId, int courseId)
        {
            var favorite = new FavoriteCourse
            {
                StudentID = studentId,
                CourseID = courseId
            };

            _favoriteCourseService.Add(favorite);
            return Ok("Course successfully added to favorites.");
        }


        [HttpDelete("removeFromFavorites")]
        public IActionResult RemoveFromFavorites(int studentId, int courseId)
        {
            var favorite = _favoriteCourseService.Get(f => f.StudentID == studentId && f.CourseID == courseId);
            if (favorite == null)
            {
                return NotFound("Favorite not found.");
            }

            _favoriteCourseService.Delete(favorite);
            return Ok("Course successfully removed from favorites.");
        }


        [HttpGet("getFavorites")]
        public IActionResult GetFavorites(int studentId)
        {
            var favoriteCourses = _favoriteCourseService.GetAll(fc => fc.StudentID == studentId);

            var favoriteDtos = favoriteCourses.Select(f =>
            {
                var courseResult = _courseService.GetById(f.CourseID); // IDataResult<Course>
                var course = courseResult.Data; // Course nesnesine erişim

                return new FavoriteCourseDto
                {
                    CourseID = f.CourseID,
                    CourseName = course?.Name ?? "Course not found",
                    Rating = course?.Rating ?? 0.0,
                    Price = course?.Price ?? 0m,
                    ImageURL = course?.Image
                };
            }).ToList();

            return Ok(favoriteDtos);
        }





    }
}
