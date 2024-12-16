using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class LearningOutcome : IEntity
    {
        public int OutcomeID { get; set; }
        public int CourseID { get; set; }
        public string OutcomeText { get; set; }
    }
}
