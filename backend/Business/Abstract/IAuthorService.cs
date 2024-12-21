using Core.Utilities.Results;
using Entities.Concrete;
using Entities.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface IAuthorService
    {
        void Add(Author author);
        Author GetById(int id);
        List<Author> GetAll();
        IDataResult<AuthorDetailsDto> GetAuthorDetails(int authorId);
        List<TopAuthorDto> GetTopRatedAuthors();
        List<TopAuthorDto> GetAuthorsByMostStudents();
        IDataResult<AuthorProfileDto> GetAuthorProfile(int authorId);
        void Update(Author author);

        List<Author> GetAuthorsByDepartmentId(int departmentId);
    }

}
