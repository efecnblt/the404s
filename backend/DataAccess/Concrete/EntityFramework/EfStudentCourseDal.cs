using Core.DataAccess.EntityFramework;
using DataAccess.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Concrete.EntityFramework
{
    public class EfStudentCourseDal : EfEntityRepositoryBase<StudentCourse, SWContext>, IStudentCourseDal
    {
        public List<Student> GetStudentsByCourseId(int courseId)
        {
            using (var context = new SWContext())
            {
                return (from sc in context.StudentCourses
                        join s in context.Students on sc.StudentId equals s.StudentId
                        where sc.CourseID == courseId
                        select s).ToList();
            }
        }
    }
}
