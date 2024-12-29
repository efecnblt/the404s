using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.DTOs
{
    public class StudentAnswerDto
    {
        public int AnswerID { get; set; }
        public int StudentID { get; set; }
        public int QuestionID { get; set; }
        public int ChoiceID { get; set; }
    }

}
