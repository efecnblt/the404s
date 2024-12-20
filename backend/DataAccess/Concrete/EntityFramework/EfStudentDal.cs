using Core.DataAccess.EntityFramework;
using DataAccess.Abstract;
using Entities.Concrete;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Concrete.EntityFramework
{
    public class EfStudentDal : EfEntityRepositoryBase<Student, SWContext>, IStudentDal
    {
        //public List<Student> GetStudentsByCourseId(int courseId)
        //{
        //    using (var context = new SWContext())
        //    {
        //        return context.Students.Where(s => s.CourseId == courseId).ToList();
        //    }
        //}

        public Student GetById(int id)
        {
            using (var context = new SWContext())
            {
                return context.Students.SingleOrDefault(s => s.StudentId == id); // Id kullanımı
            }
        }
    }
}
