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
    public class EfVideoDal : EfEntityRepositoryBase<Video, SWContext>, IVideoDal
    {
        public List<Video> GetVideosBySectionId(int sectionId)
        {
            using (var context = new SWContext())
            {
                return context.Videos.Where(v => v.SectionID == sectionId).OrderBy(v => v.Order).ToList();
            }
        }
    }
}
