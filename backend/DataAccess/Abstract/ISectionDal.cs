using Core.DataAccess;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Abstract
{
    public interface ISectionDal : IEntityRepository<Section>
    {
        List<Section> GetSectionsByCourseId(int courseId); // Özel bir metot
    }
}
