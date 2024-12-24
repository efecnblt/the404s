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
    public class FavoriteCourseManager : IFavoriteCourseService
    {
        private readonly IFavoriteCourseDal _favoriteCourseDal;

        public FavoriteCourseManager(IFavoriteCourseDal favoriteCourseDal)
        {
            _favoriteCourseDal = favoriteCourseDal;
        }

        public void Add(FavoriteCourse favoriteCourse)
        {
            _favoriteCourseDal.Add(favoriteCourse);
        }

        public void Remove(FavoriteCourse favoriteCourse)
        {
            _favoriteCourseDal.Delete(favoriteCourse);
        }

        public List<FavoriteCourse> GetByStudentId(int studentId)
        {
            return _favoriteCourseDal.GetAll(fc => fc.StudentID == studentId);
        }
    }

}
