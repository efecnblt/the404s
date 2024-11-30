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


    }
}
