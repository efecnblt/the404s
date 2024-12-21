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
        public int AuthorID { get; set; } // Tablo ile uyumlu
        public string Name { get; set; } // Tablo ile uyumlu
        public string? Biography { get; set; } // Biography nullable olduğu için '?' var
        public int? DepartmentID { get; set; } // DepartmentID nullable olduğu için '?' var
        public double Rating { get; set; } // Tablo ile uyumlu
        public int StudentCount { get; set; } // Tablo ile uyumlu
        public int CourseCount { get; set; } // Tablo ile uyumlu
        public string? ImageURL { get; set; } // ImageURL nullable olduğu için '?' var
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
