using Core.DataAccess.EntityFramework;
using DataAccess.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Concrete.EntityFramework
{
    public class EfSectionDal : EfEntityRepositoryBase<Section, SWContext>, ISectionDal
    {
        public List<Section> GetSectionsByCourseId(int courseId)
        {
            using (var context = new SWContext())
            {
                return context.Sections.Where(s => s.CourseID == courseId).OrderBy(s => s.Order).ToList();
            }
        }
    }
}
