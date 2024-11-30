using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface IStudentService
    {
        void Add(Student student);
        Student GetById(int id);
        List<Student> GetAll();
    }

}
