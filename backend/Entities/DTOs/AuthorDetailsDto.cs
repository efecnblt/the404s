using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.DTOs
{
    public class AuthorDetailsDto : IDto
    {
        public int AuthorID { get; set; }
        public string Name { get; set; }
        public float? Rating { get; set; } // Nullable tanımlandı
        public int? StudentCount { get; set; } // Nullable tanımlandı
        public int? CourseCount { get; set; } // Nullable tanımlandı
        public string ImageURL { get; set; }
    }

}
