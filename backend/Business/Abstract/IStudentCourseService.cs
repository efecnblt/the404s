using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{

    public interface IStudentCourseService
    {

        void Add(StudentCourse studentCourse);
        List<StudentCourse> GetAll();
        List<StudentCourse> GetByStudentId(int studentId);
        List<StudentCourse> GetByCourseId(int courseId);
        List<Student> GetStudentsByCourse(int courseId);
    }


}
