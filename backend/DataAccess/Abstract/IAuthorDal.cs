using Core.DataAccess;
using Core.Utilities.Results;
using Entities.Concrete;
using Entities.DTOs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Abstract
{
    public interface IAuthorDal : IEntityRepository<Author>
    {
        List<TopAuthorDto> GetAuthorsByMostStudents();
        Author GetById(int id);
        List<TopAuthorDto> GetTopRatedAuthors();
        AuthorProfileDto GetAuthorProfile(int authorId);
        List<Author> GetAuthorsByDepartmentId(int departmentId);
    }
}
