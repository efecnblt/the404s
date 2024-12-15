using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.DTOs
{
    public class CourseDetailDto : IDto
    {
        public int CourseId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string CategoryName { get; set; } // Category'den alınan isim
        public string LevelName { get; set; } // Level'den alınan isim
        public decimal? Price { get; set; }
        public string Image { get; set; }
    }

}
