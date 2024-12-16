using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.DTOs
{
    public class AuthorProfileDto : IDto
    {
        public int AuthorID { get; set; }
        public string Name { get; set; }
        public double Rating { get; set; }
        public int StudentCount { get; set; }
        public int CourseCount { get; set; }
        public string ImageURL { get; set; }
        public List<CourseDto> Courses { get; set; } // Yazarın kursları
    }

    public class CourseDto : IDto
    {
        public int CourseID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public double? Rating { get; set; }
        public decimal? Price { get; set; }
        public int TotalStudentCount { get; set; }
    }
}
