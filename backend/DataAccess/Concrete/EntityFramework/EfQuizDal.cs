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
    public class EfQuizDal : EfEntityRepositoryBase<Quiz, SWContext>, IQuizDal
    {
        public List<Quiz> GetQuizzesBySectionId(int sectionId)
        {
            using (var context = new SWContext())
            {
                return context.Quizzes.Where(q => q.SectionID == sectionId).ToList();
            }
        }
    }

}
