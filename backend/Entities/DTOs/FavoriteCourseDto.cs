using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.DTOs
{
    public class FavoriteCourseDto
    {
        public int CourseID { get; set; }
        public string CourseName { get; set; }
        public double Rating { get; set; }
        public decimal Price { get; set; }
        public string ImageURL { get; set; }
    }




}
