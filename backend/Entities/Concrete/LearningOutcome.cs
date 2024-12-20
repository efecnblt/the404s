using Core.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{

    public class LearningOutcome : IEntity
    {
        [Key]
        public int OutcomeID { get; set; } // Primary Key
        
        public int CourseID { get; set; }  // Foreign Key
        public string OutcomeText { get; set; } // Öğrenme çıktısı metni
    }

}
