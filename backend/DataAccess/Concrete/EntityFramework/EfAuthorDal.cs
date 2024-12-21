using Core.DataAccess.EntityFramework;
using DataAccess.Abstract;
using Entities.Concrete;
using Entities.DTOs;
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

        public List<TopAuthorDto> GetTopRatedAuthors()
        {
            using (var context = new SWContext())
            {
                var result = context.Authors
                    .Where(a => a.Rating != null)
                    .OrderByDescending(a => a.Rating)
                    .Take(10)
                    .Select(a => new TopAuthorDto
                    {
                        AuthorID = a.AuthorID,
                        Name = a.Name,
                        Rating = a.Rating ?? 0.0,
                        StudentCount = a.StudentCount ?? 0,
                        CourseCount = a.CourseCount ?? 0
                    }).ToList();

                return result;
            }
        }

        public List<TopAuthorDto> GetAuthorsByMostStudents()
        {
            using (var context = new SWContext())
            {
                var result = context.Authors
                    .OrderByDescending(a => a.StudentCount)
                    .Take(10)
                    .Select(a => new TopAuthorDto
                    {
                        AuthorID = a.AuthorID,
                        Name = a.Name,
                        Rating = a.Rating ?? 0.0,
                        StudentCount = a.StudentCount ?? 0,
                        CourseCount = a.CourseCount ?? 0
                    }).ToList();

                return result;
            }
        }



        public AuthorProfileDto GetAuthorProfile(int authorId)
        {
            using (var context = new SWContext())
            {
                var author = context.Authors.FirstOrDefault(a => a.AuthorID == authorId);
                if (author == null) return null;

                var courses = context.Courses
                    .Where(c => c.AuthorId == authorId)
                    .Select(c => new CourseDto
                    {
                        CourseID = c.CourseID,
                        Name = c.Name,
                        Description = c.Description,
                        Rating = c.Rating ?? 0.0,
                        Price = c.Price,
                        TotalStudentCount = c.TotalStudentCount ?? 0
                        
                    }).ToList();

                return new AuthorProfileDto
                {
                    AuthorID = author.AuthorID,
                    Name = author.Name,
                    Biography = author.Biography ?? "Biography not available.",
                    DepartmentID = author.DepartmentID ?? 0,
                    Rating = author.Rating ?? 0.0,
                    StudentCount = author.StudentCount ?? 0,
                    CourseCount = author.CourseCount ?? 0,                                     
                    ImageURL = author.ImageURL,
                    Courses = courses
                };
            }
        }

        public List<Author> GetAuthorsByDepartmentId(int departmentId)
        {
            using (var context = new SWContext())
            {
                return context.Authors.Where(a => a.DepartmentID == departmentId).ToList();
            }
        }

    }




}
