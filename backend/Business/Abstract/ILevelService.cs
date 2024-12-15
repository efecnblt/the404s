using Core.Utilities.Results;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface ILevelService
    {
        IDataResult<List<Level>> GetAll();
        IDataResult<Level> GetById(int levelId);
        IResult Add(Level level);
        IResult Update(Level level);
        IResult Delete(Level level);
    }

}
