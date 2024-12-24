using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface IFavoriteCourseService
    {
        void Add(FavoriteCourse favoriteCourse);
        void Delete(FavoriteCourse favoriteCourse);
        List<FavoriteCourse> GetAll(Expression<Func<FavoriteCourse, bool>> filter = null);
        FavoriteCourse Get(Expression<Func<FavoriteCourse, bool>> filter);


    }

}
