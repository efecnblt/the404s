using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Video : IEntity
    {
        public int VideoID { get; set; }
        public int SectionID { get; set; }
        public int? Order { get; set; }
        public string Title { get; set; }
        public int Duration { get; set; }
        public string URL { get; set; }
    }
}
