using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Choice : IEntity
    {
        public int ChoiceID { get; set; } 
        public int QuestionID { get; set; } 
        public string ChoiceText { get; set; } 
        public bool IsCorrect { get; set; } 
    }


}
