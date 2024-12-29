using Core.DataAccess;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Abstract
{
    public interface IStudentAnswerDal : IEntityRepository<StudentAnswer>
    {
        // Ek işlemler için gerekli metotları burada tanımlayabilirsiniz.
        List<StudentAnswer> GetAnswersByStudent(int studentId, int quizId);
    }
}
