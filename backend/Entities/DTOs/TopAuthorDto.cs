using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.DTOs
{
    public class TopAuthorDto : IDto
    {
        public int AuthorID { get; set; }
        public string Name { get; set; }
        public double Rating { get; set; }
        public int StudentCount { get; set; }
        public int CourseCount { get; set; }
    }

}
