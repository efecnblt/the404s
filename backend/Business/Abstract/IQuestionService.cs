using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface IQuestionService
    {
        void Add(Question question);
        void Update(Question question);
        void Delete(int questionId);
        Question GetById(int questionId);
        List<Question> GetAll(Expression<Func<Question, bool>> filter = null);
        Question Get(int questionId);
    }
}
