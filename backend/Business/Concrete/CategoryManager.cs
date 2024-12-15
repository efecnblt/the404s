using Business.Abstract;
using Core.Utilities.Results;
using DataAccess.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Concrete
{
    public class CategoryManager : ICategoryService
    {
        ICategoryDal _categoryDal;

        public CategoryManager(ICategoryDal categoryDal)
        {
            _categoryDal = categoryDal;
        }


        public IDataResult<List<Category>> GetAll()
        {
            return new SuccessDataResult<List<Category>> (_categoryDal.GetAll());
        }

        //select * from Categories where CategoryId=3
        public IDataResult<Category> GetById(int categoryId)
        {
            return new SuccessDataResult<Category> (_categoryDal.Get(c=>c.CategoryId == categoryId));
        }


        public IResult Add(Category category)
        {
            _categoryDal.Add(category); // Veritabanına kategori ekleniyor
            return new SuccessResult("Category added successfully.");
        }

        public IResult Update(Category category)
        {
            _categoryDal.Update(category);
            return new SuccessResult("Category updated successfully.");
        }

        public IResult Delete(Category category)
        {
            _categoryDal.Delete(category);
            return new SuccessResult("Category deleted successfully.");
        }
    }
}
