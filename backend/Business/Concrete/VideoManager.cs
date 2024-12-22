using Business.Abstract;
using DataAccess.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Concrete
{

    public class VideoManager : IVideoService
    {
        private readonly IVideoDal _videoDal;

        public VideoManager(IVideoDal videoDal)
        {
            _videoDal = videoDal;
        }

        public List<Video> GetVideosBySectionId(int sectionId)
        {
            return _videoDal.GetVideosBySectionId(sectionId);
        }

        public void Add(Video video)
        {
            _videoDal.Add(video);
        }

        public void Update(Video video)
        {
            _videoDal.Update(video);
        }

        public void Delete(int videoId)
        {
            var video = _videoDal.Get(v => v.VideoID == videoId);
            if (video != null)
            {
                _videoDal.Delete(video);
            }
        }

        public List<Video> GetVideosByCourseId(int courseId)
        {
            return _videoDal.GetVideosByCourseId(courseId);
        }


    }
}
