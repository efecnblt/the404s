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
    public class AuthorManager : IAuthorService
    {
        IAuthorDal _authorDal;

        public AuthorManager(IAuthorDal authorDal)
        {
            _authorDal = authorDal;
        }

        public void Add(Author author)
        {
            _authorDal.Add(author);
        }

        public Author GetById(int id)
        {
            return _authorDal.GetById(id);
        }

        public List<Author> GetAll()
        {
            return _authorDal.GetAll();
        }
    }

}
