﻿using Business.Abstract;
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

        public CourseManager(ICourseDal coursetDal, ICategoryService categoryService)
        {
            _courseDal = coursetDal;
            _categoryService = categoryService;
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
                courseToUpdate.Rating = course.Rating;
                courseToUpdate.RatingCount = course.RatingCount;

                _courseDal.Update(courseToUpdate); // Veri erişim katmanında güncelle
                return new SuccessResult("Course updated successfully.");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error during update: {ex.Message}");
                return new ErrorResult("An error occurred while updating the course.");
            }
        }


    }
}