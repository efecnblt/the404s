using Core.Utilities.Results;
using Entities.Concrete;
using Entities.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface ICourseService
    {
        IDataResult<List<Course>> GetAll();
        IDataResult<List<Course>> GetAllByCategoryId(int id);
        //IDataResult<List<Course>> GetByUnitPrice(decimal min, decimal max);
        IDataResult<List<CourseDetailDto>> GetCourseDetails();
        IDataResult<List<Course>> GetCoursesByLevel(int levelId);
        IResult Add(Course course);
        IDataResult<Course> GetById(int courseId);
        IResult Update(Course course);
        IResult TransactionalTest(Course course);
        IResult Delete(int courseId);
        List<TopCourseDto> GetTopRatedCourses();
        IResult UpdateDiscount(int courseId, decimal discountPercentage);
        IResult EnrollCourse(int studentId, int courseId);
    }
}
