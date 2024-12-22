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

        public List<Video> GetVideosByCourseId(int courseId)
        {
            using (var context = new SWContext())
            {
                var videos = (from video in context.Videos
                              join section in context.Sections
                              on video.SectionID equals section.SectionID
                              where section.CourseID == courseId
                              select video).ToList();

                return videos;
            }
        }

    }
}
