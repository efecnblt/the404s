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
            using (var context = new SWContext())
            {
                var result = from c in context.Courses
                             join cat in context.Categories on c.CategoryId equals cat.CategoryId
                             join lvl in context.Levels on c.LevelId equals lvl.LevelId
                             select new CourseDetailDto
                             {
                                 CourseId = c.CourseID,
                                 Name = c.Name,
                                 Description = c.Description,
                                 CategoryName = cat.Name, // Category ismi
                                 LevelName = lvl.Name, // Level ismi
                                 Price = c.Price,
                                 Image = c.Image
                             };

                return result.ToList();
            }
        }
        public List<TopCourseDto> GetTopRatedCourses()
        {
            using (var context = new SWContext())
            {
                var result = context.Courses
                    .Where(c => c.Rating != null)
                    .OrderByDescending(c => c.Rating)
                    .Take(10)
                    .Select(c => new TopCourseDto
                    {
                        CourseID = c.CourseID,
                        Name = c.Name,
                        Rating = c.Rating ?? 0,
                        RatingCount = c.RatingCount ?? 0,
                        TotalStudentCount = c.TotalStudentCount ?? 0
                    }).ToList();

                return result;
            }
        }

    }
}
