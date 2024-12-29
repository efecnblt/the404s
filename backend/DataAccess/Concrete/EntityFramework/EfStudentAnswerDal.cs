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
    public class EfStudentAnswerDal : EfEntityRepositoryBase<StudentAnswer, SWContext>, IStudentAnswerDal
    {
        public List<StudentAnswer> GetAnswersByStudent(int studentId, int quizId)
        {
            using (var context = new SWContext())
            {
                return (from sa in context.StudentAnswers
                        join q in context.Questions on sa.QuestionID equals q.QuestionID
                        where sa.StudentID == studentId && q.QuizID == quizId
                        select sa).ToList();
            }
        }
    }

}
