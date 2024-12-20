using Business.Abstract;
using Business.Aspects.Autofac;
using Business.Constants;
using Business.ValidationRules.FluentValidation;
using Core.Aspects.Autofac.Caching;
using Core.Aspects.Autofac.Transaction;
using Core.Aspects.Autofac.Validation;
using Core.CrossCuttingConcerns.Validation;
using Core.Utilities.Business;
using Core.Utilities.Results;
using DataAccess.Abstract;
using DataAccess.Concrete.EntityFramework;
using Entities.Concrete;
using Entities.DTOs;
using FluentValidation;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Business.Concrete
{
    public class CourseManager : ICourseService
    {
        ICourseDal _courseDal;
        ICategoryService _categoryService;
        IStudentCourseService _studentCourseService;
         IAuthorService _authorService;

        public CourseManager(ICourseDal coursetDal, ICategoryService categoryService,
                            IAuthorService authorService,IStudentCourseService studentCourseService)
        {
            _courseDal = coursetDal;
            _categoryService = categoryService;
            _authorService = authorService;
            _studentCourseService = studentCourseService;
        }

        // [SecuredOperation("course.add,admin")]
        //[ValidationAspect(typeof(CourseValidator))]
        // [CacheRemoveAspect("ICourseService.Get")]


        public IResult Add(Course course)
        {

            _courseDal.Add(course);

            return new SuccessResult(Messages.CourseAdded);

        }

        //[CacheAspect]
        public IDataResult<List<Course>> GetAll()
        {
            if (DateTime.Now.Hour == 3)
            {
                return new ErrorDataResult<List<Course>>(Messages.MaintenanceTime);
            }


            return new SuccessDataResult<List<Course>>(_courseDal.GetAll(), Messages.CoursesListed);
        }

        public IDataResult<List<Course>> GetAllByCategoryId(int id)
        {
            return new SuccessDataResult<List<Course>>(_courseDal.GetAll(p => p.CategoryId == id),Messages.CoursesListedByCategory);
        }

       

        //[CacheAspect]
        public IDataResult<Course> GetById(int courseId)
        {
            return new SuccessDataResult<Course>(_courseDal.Get(p => p.CourseID == courseId));
        }


        public IDataResult<List<CourseDetailDto>> GetCourseDetails()
        {
            return new SuccessDataResult<List<CourseDetailDto>>(_courseDal.GetCourseDetails());
        }

        public IResult TransactionalTest(Course course)
        {
            throw new NotImplementedException();
        }

        public IResult Update(Course course)
        {
            var courseToUpdate = _courseDal.Get(c => c.CourseID == course.CourseID);
            if (courseToUpdate == null)
            {
                return new ErrorResult("Course not found.");
            }

            try
            {
                // Güncellenebilir alanları atayın
                courseToUpdate.Description = course.Description;
                courseToUpdate.Name = course.Name;
                courseToUpdate.Image = course.Image;
                courseToUpdate.Price = course.Price;
                courseToUpdate.Hashtags = course.Hashtags;
                courseToUpdate.LevelId = course.LevelId;
                courseToUpdate.CategoryId = course.CategoryId;

                _courseDal.Update(courseToUpdate); // Veri erişim katmanında güncelle
                return new SuccessResult("Course updated successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error during update: {ex.Message}");
                return new ErrorResult("An error occurred while updating the course.");
            }
        }

        public IDataResult<List<Course>> GetCoursesByLevel(int levelId)
        {
            return new SuccessDataResult<List<Course>>(_courseDal.GetAll(c => c.LevelId == levelId));
        }

        public IResult Delete(int courseId)
        {
            var courseToDelete = _courseDal.Get(c => c.CourseID == courseId);
            if (courseToDelete == null)
            {
                return new ErrorResult("Course not found.");
            }

            _courseDal.Delete(courseToDelete);
            return new SuccessResult("Course deleted successfully.");
        }

        public List<TopCourseDto> GetTopRatedCourses()
        {
            return _courseDal.GetTopRatedCourses();
        }


        public IResult UpdateDiscount(int courseId, decimal discountPercentage)
        {
            var courseToUpdate = _courseDal.Get(c => c.CourseID == courseId);
            if (courseToUpdate == null)
            {
                return new ErrorResult("Course not found.");
            }

            if (discountPercentage < 0 || discountPercentage > 100)
            {
                return new ErrorResult("Invalid discount percentage. Must be between 0 and 100.");
            }

            courseToUpdate.Discount = discountPercentage;
            _courseDal.Update(courseToUpdate);

            return new SuccessResult("Discount updated successfully.");
        }


        public IResult EnrollCourse(int studentId, int courseId)
        {
            try
            {
                // 1. StudentCourses tablosuna kayıt ekle
                _studentCourseService.Add(new StudentCourse
                {
                    StudentId = studentId,
                    CourseID = courseId,
                    EnrollmentDate = DateTime.Now,
                    Progress = 0
                });

                // 2. Courses tablosundaki TotalStudentCount artır
                var course = _courseDal.Get(c => c.CourseID == courseId);
                if (course == null)
                {
                    return new ErrorResult("Course not found.");
                }
                course.TotalStudentCount++;
                _courseDal.Update(course);

                // 3. Authors tablosundaki StudentCount artır
                var author = _authorService.GetById(course.AuthorId);
                if (author == null)
                {
                    return new ErrorResult("Author not found.");
                }
                author.StudentCount++;
                _authorService.Update(author);

                return new SuccessResult("Student successfully enrolled in the course.");
            }
            catch (Exception ex)
            {
                return new ErrorResult($"An error occurred: {ex.Message}");
            }
        }
    }
}
