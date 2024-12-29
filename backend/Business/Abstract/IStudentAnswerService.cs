using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface IStudentAnswerService
    {
        void Add(StudentAnswer studentAnswer);
        void AddAnswers(List<StudentAnswer> studentAnswers);
        List<StudentAnswer> GetAnswersByStudent(int studentId, int quizId);
        int CalculateScore(int studentId, int quizId);
        List<StudentAnswer> GetAll(Expression<Func<StudentAnswer, bool>> filter = null);
    }
}
