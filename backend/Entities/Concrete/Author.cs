using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Author : IEntity
    {
        public int AuthorID { get; set; }
        public string Name { get; set; }
        public string? Biography { get; set; }
        public int? DepartmentID { get; set; } // Yeni Eklenen
        public double? Rating { get; set; }
        public int? StudentCount { get; set; }
        public int? CourseCount { get; set; }
        public string? ImageURL { get; set; }
        
        
        //public Department Department { get; set; } // Navigation Property
    }

}
