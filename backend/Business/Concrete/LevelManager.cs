using Business.Abstract;
using Core.Utilities.Results;
using DataAccess.Abstract;
using DataAccess.Concrete.EntityFramework;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Concrete
{
    public class LevelManager : ILevelService
    {
        private readonly ILevelDal _levelDal;

        public LevelManager(ILevelDal levelDal)
        {
            _levelDal = levelDal;
        }

        public IDataResult<List<Level>> GetAll()
        {
            return new SuccessDataResult<List<Level>>(_levelDal.GetAll());
        }

        public IDataResult<Level> GetById(int levelId)
        {
            return new SuccessDataResult<Level>(_levelDal.Get(l => l.LevelId == levelId));
        }

        public IResult Add(Level level)
        {
            _levelDal.Add(level);
            return new SuccessResult("Level added successfully");
        }

        public IResult Update(Level level)
        {
            _levelDal.Update(level);
            return new SuccessResult("Level updated successfully");
        }

        public IResult Delete(Level level)
        {
            _levelDal.Delete(level);
            return new SuccessResult("Level deleted successfully");
        }
    }

}
