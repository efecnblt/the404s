using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.DTOs
{
    public class QuizDto
    {
        public int QuizID { get; set; }
        public int SectionID { get; set; }
        public string Name { get; set; }
        public int TotalPoints { get; set; }
    }

}
