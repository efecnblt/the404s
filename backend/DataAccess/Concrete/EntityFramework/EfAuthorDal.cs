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

    public class EfAuthorDal : EfEntityRepositoryBase<Author, SWContext>, IAuthorDal
    {
        public List<Author> GetTopRatedAuthors(int count)
        {
            using (var context = new SWContext())
            {
                return context.Authors.OrderByDescending(a => a.Rating).Take(count).ToList();
            }
        }

        public Author GetById(int id)
        {
            using (var context = new SWContext())
            {
                return context.Authors.SingleOrDefault(a => a.AuthorID == id);
            }
        }

    }

}
