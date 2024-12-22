using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface IVideoService
    {
        List<Video> GetVideosBySectionId(int sectionId);
        void Add(Video video);
        void Update(Video video);
        void Delete(int videoId);
         List<Video> GetVideosByCourseId(int courseId);
    }
}
