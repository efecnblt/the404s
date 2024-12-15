using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.DTOs
{
    public class TopCourseDto : IDto
    {
        public int CourseID { get; set; }
        public string Name { get; set; }
        public double Rating { get; set; }
        public int RatingCount { get; set; }
        public int TotalStudentCount { get; set; }
    }

}
