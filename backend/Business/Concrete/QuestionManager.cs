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
    public class QuestionManager : IQuestionService
    {
        private readonly IQuestionDal _questionDal;

        public QuestionManager(IQuestionDal questionDal)
        {
            _questionDal = questionDal;
        }

        public void Add(Question question)
        {
            _questionDal.Add(question);
        }

        public void Update(Question question)
        {
            _questionDal.Update(question);
        }

        public void Delete(int questionId)
        {
            var question = _questionDal.Get(q => q.QuestionID == questionId);
            if (question != null)
            {
                _questionDal.Delete(question);
            }
        }
    }
}
