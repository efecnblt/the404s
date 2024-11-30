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
    public class SectionManager : ISectionService
    {
        private readonly ISectionDal _sectionDal;

        public SectionManager(ISectionDal sectionDal)
        {
            _sectionDal = sectionDal;
        }

        public List<Section> GetSectionsByCourseId(int courseId)
        {
            return _sectionDal.GetSectionsByCourseId(courseId);
        }

        public void Add(Section section)
        {
            _sectionDal.Add(section);
        }

        public void Update(Section section)
        {
            _sectionDal.Update(section);
        }

        public void Delete(int sectionId)
        {
            var section = _sectionDal.Get(s => s.SectionID == sectionId);
            if (section != null)
            {
                _sectionDal.Delete(section);
            }
        }
    }
}
