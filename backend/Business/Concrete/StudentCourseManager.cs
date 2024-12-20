using Business.Abstract;
using DataAccess.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Concrete
{
    public class StudentCourseManager : IStudentCourseService
    {
        private readonly IStudentCourseDal _studentCourseDal;

        public StudentCourseManager(IStudentCourseDal studentCourseDal)
        {
            _studentCourseDal = studentCourseDal;
        }

        public void Add(StudentCourse studentCourse)
        {
            _studentCourseDal.Add(studentCourse);
        }

        public List<StudentCourse> GetAll()
        {
            return _studentCourseDal.GetAll();
        }

        public List<StudentCourse> GetByStudentId(int studentId)
        {
            return _studentCourseDal.GetAll(sc => sc.StudentId == studentId);
        }

        public List<StudentCourse> GetByCourseId(int courseId)
        {
            return _studentCourseDal.GetAll(sc => sc.CourseID == courseId);
        }


        public List<Student> GetStudentsByCourse(int courseId)
        {
            return _studentCourseDal.GetStudentsByCourseId(courseId);
        }
    }
}
