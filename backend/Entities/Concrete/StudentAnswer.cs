using Core.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class StudentAnswer : IEntity
    {
        [Key]
        public int AnswerID { get; set; }
        public int StudentID { get; set; }
        public int QuestionID { get; set; }
        public int ChoiceID { get; set; }


        public Question Question { get; set; } // Question ile ilişki
        public Choice Choice { get; set; }     // Choice ile ilişki
    }
}
