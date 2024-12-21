using Business.Abstract;
using Core.Utilities.Results;
using DataAccess.Abstract;
using Entities.Concrete;
using Entities.DTOs;
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
        private readonly IDepartmentService _departmentService;

        public AuthorManager(IAuthorDal authorDal, IDepartmentService departmentService)
        {
            _authorDal = authorDal;
            _departmentService = departmentService;
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

        public IDataResult<AuthorDetailsDto> GetAuthorDetails(int authorId)
        {
            var author = _authorDal.Get(a => a.AuthorID == authorId);
            if (author == null)
            {
                return new ErrorDataResult<AuthorDetailsDto>("Author not found.");
            }

            // DTO'ya dönüştürme
            var authorDetails = new AuthorDetailsDto
            {
                AuthorID = author.AuthorID,
                Name = author.Name,
                Rating = (float?)author.Rating ?? 0, // Eğer NULL ise 0 atanır
                StudentCount = author.StudentCount ?? 0, // Eğer NULL ise 0 atanır
                CourseCount = author.CourseCount ?? 0, // Eğer NULL ise 0 atanır
                ImageURL = author.ImageURL
            };




            return new SuccessDataResult<AuthorDetailsDto>(authorDetails, "Author details retrieved successfully.");
        }


        public List<TopAuthorDto> GetTopRatedAuthors()
        {
            return _authorDal.GetTopRatedAuthors();
        }

        public List<TopAuthorDto> GetAuthorsByMostStudents()
        {
            return _authorDal.GetAuthorsByMostStudents();
        }

        public IDataResult<AuthorProfileDto> GetAuthorProfile(int authorId)
        {
            var authorProfile = _authorDal.GetAuthorProfile(authorId);
            if (authorProfile == null)
            {
                return new ErrorDataResult<AuthorProfileDto>("Author not found.");
            }

            return new SuccessDataResult<AuthorProfileDto>(authorProfile, "Author profile retrieved successfully.");

        }

        public void Update(Author author)
        {
            var existingAuthor = _authorDal.Get(a => a.AuthorID == author.AuthorID);
            if (existingAuthor != null)
            {
                existingAuthor.Name = author.Name;
                existingAuthor.Rating = author.Rating;
                existingAuthor.StudentCount = author.StudentCount;
                existingAuthor.CourseCount = author.CourseCount;
                existingAuthor.ImageURL = author.ImageURL;

                _authorDal.Update(existingAuthor);
            }
        }

        public void UpdateAuthorDepartment(int authorId, int departmentId)
        {
            var author = _authorDal.Get(a => a.AuthorID == authorId);
            if (author != null)
            {
                author.DepartmentID = departmentId;
                _authorDal.Update(author);
            }
        }

        public List<Author> GetAuthorsByDepartmentId(int departmentId)
        {
            return _authorDal.GetAuthorsByDepartmentId(departmentId);
        }
    }

}
