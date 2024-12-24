using Core.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
   
        public class StudentQuizResult : IEntity
        {
            [Key]
            public int ResultID { get; set; }
            public int StudentID { get; set; }
            public int QuizID { get; set; }
            public int Score { get; set; }
            public int TotalPoints { get; set; }
            public float Percentage { get; set; }
            public DateTime CompletedDate { get; set; }
        }
    
}
