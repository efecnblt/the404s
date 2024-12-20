using Core.DataAccess;
using Core.Entities.Concrete;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Abstract
{
    public interface IStudentDal : IEntityRepository<Student>
    {
        public Student GetById(int id);
        //public List<Student> GetStudentsByCourseId(int courseId);
    }
}
