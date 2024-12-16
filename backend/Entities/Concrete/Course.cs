using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Course : IEntity
    {
        public int CourseID { get; set; }
        public string Name { get; set; }
        public int CategoryId { get; set; }
        public string Description { get; set; }
        public int AuthorId {get;set;}
        public double? Rating { get; set; }
        public int? RatingCount { get; set; }
        public decimal? Price { get; set; }
        public decimal? Discount { get; set; }
        public int? TotalStudentCount { get; set; }
        public string Image { get; set; }
        public string Hashtags { get; set; }
        public int? LevelId { get; set; }
    }
}
