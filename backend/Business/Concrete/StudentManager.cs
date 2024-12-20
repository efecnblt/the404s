using Business.Abstract;
using DataAccess.Abstract;
using DataAccess.Concrete.EntityFramework;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Concrete
{
    public class StudentManager : IStudentService
    {
       IStudentDal _studentDal;

        public StudentManager(IStudentDal studentDal)
        {
            _studentDal = studentDal;
        }

        public void Add(Student student)
        {

            if (student.UserId <= 0)
            {
                throw new Exception("Invalid UserId for Student");
            }
            _studentDal.Add(student);
        }

        public Student GetById(int id)
        {
            return _studentDal.GetById(id);
        }


        public List<Student> GetAll()
        {
            return _studentDal.GetAll();
        }
    }

}
