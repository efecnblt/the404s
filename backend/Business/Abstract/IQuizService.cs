using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface IQuizService
    {
        void Add(Quiz quiz);
        void Update(Quiz quiz);
        void Delete(int quizId);
        List<Quiz> GetQuizzesBySectionId(int sectionId);

        void AddQuizWithQuestions(Quiz quiz, List<Question> questions);
        public int CalculateQuizScore(int studentId, int quizId);

    }

}
