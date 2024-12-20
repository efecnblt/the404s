using Business.Abstract;
using Business.Concrete;
using DataAccess.Concrete.EntityFramework;
using Entities.Concrete;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CoursesController : ControllerBase
    {
        //Loosely coupled
        //naming convention
        //IoC Container -- Inversion of Control
        ICourseService _courseService;

        public CoursesController(ICourseService courseService)
        {
            _courseService = courseService;
        }

        [HttpGet("getall")]

        public IActionResult GetAll()
        {
            //Dependency chain --
            //IProductService productservice = new ProductManager(new EfProductDal());
            var result = _courseService.GetAll();
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result.Message);
        }

        [HttpGet("getbyid")]

        public IActionResult GetById(int id)
        {
            //Dependency chain --
            //IProductService productservice = new ProductManager(new EfProductDal());
            var result = _courseService.GetById(id);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result.Message);
        }



        [HttpGet("getallbycategoryid")]

        public IActionResult GetAllByCategoryId(int id)
        {
            
            var result = _courseService.GetAllByCategoryId(id);
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result.Message);
        }


        [HttpGet("getbylevel")]
        public IActionResult GetCoursesByLevel(int levelId)
        {
            var result = _courseService.GetCoursesByLevel(levelId);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Data);
        }




        [HttpGet("getcoursedetails")]
        public IActionResult GetCourseDetails()
        {

            var result = _courseService.GetCourseDetails();
            if (result.Success)
            {
                return Ok(result);
            }

            return BadRequest(result.Message);
        }


        [HttpPost("add")]

        public IActionResult Add(Course course)
        {
            var result = _courseService.Add(course);
            if (result.Success) { return Ok(result); }
            return BadRequest(result.Message);
        }

        [HttpPost("update")]
        public IActionResult Update(Course course)
        {
            var result = _courseService.Update(course);
            if (result.Success)
            {
                return Ok(result); // HTTP 200 ve başarılı sonucu döndür
            }
            return BadRequest(result.Message); // HTTP 400 ve hata mesajı döndür
        }



        [HttpDelete("{courseId}")]
        public IActionResult Delete(int courseId)
        {
            var result = _courseService.Delete(courseId);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }

            return Ok(result.Message);
        }


        [HttpGet("top-rated-courses")]
        public IActionResult GetTopRatedCourses()
        {
            var result = _courseService.GetTopRatedCourses();
            return Ok(result);
        }

        [HttpPut("updateDiscount")]
        public IActionResult UpdateDiscount(int courseId, decimal discount)
        {
            var result = _courseService.UpdateDiscount(courseId, discount);
            if (!result.Success)
            {
                return BadRequest(result.Message);
            }
            return Ok(result.Message);
        }


        [HttpPost("enroll")]
        public IActionResult EnrollCourse(int studentId, int courseId)
        {
            _courseService.EnrollCourse(studentId, courseId);
            return Ok("Student successfully enrolled in the course!");
        }


    }
}
