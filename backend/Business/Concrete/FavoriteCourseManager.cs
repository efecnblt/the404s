using Business.Abstract;
using DataAccess.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
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

        public void Delete(FavoriteCourse favoriteCourse)
        {
            _favoriteCourseDal.Delete(favoriteCourse);
        }

        public List<FavoriteCourse> GetAll(Expression<Func<FavoriteCourse, bool>> filter = null)
        {
            return _favoriteCourseDal.GetAll(filter);
        }

        public FavoriteCourse Get(Expression<Func<FavoriteCourse, bool>> filter)
        {
            return _favoriteCourseDal.Get(filter);
        }
    }


}
