using Core.DataAccess.EntityFramework;
using DataAccess.Abstract;
using Entities.Concrete;
using Entities.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Concrete.EntityFramework
{
    public class EfCourseDal : EfEntityRepositoryBase<Course, SWContext>, ICourseDal
    {
        public List<CourseDetailDto> GetCourseDetails()
        {
            using (SWContext context = new SWContext())
            {
                var result = from p in context.Courses
                             join c in context.Categories
                             on p.CategoryId equals c.CategoryId
                             select new CourseDetailDto
                             {
                                 CourseId = p.CourseID,
                                 CourseName = p.Name,
                                 CategoryName = c.Name,
                                 
                             };
                return result.ToList();
            }
        }
    }
}
