using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Section:IEntity
    {
        public int SectionID { get; set; }
        public int CourseID { get; set; }
        public int? Order { get; set; }
        public string Title { get; set; }

        //public List<Quiz> Quizzes { get; set; }
    }
}
