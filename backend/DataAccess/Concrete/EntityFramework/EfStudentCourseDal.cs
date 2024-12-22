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

        public void UpdateCompletedVideos(int studentId, int courseId, int completedVideos)
        {
            using (var context = new SWContext())
            {
                var studentCourse = context.StudentCourses
                    .FirstOrDefault(sc => sc.StudentId == studentId && sc.CourseID == courseId);
                if (studentCourse != null)
                {
                    studentCourse.CompletedVideos = completedVideos;
                    context.SaveChanges();
                }
            }
        }

    }
}
