using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class StudentCourse : IEntity
    {
        public int StudentCourseID { get; set; }
        public int StudentId { get; set; }
        public int CourseID { get; set; }
        public DateTime EnrollmentDate { get; set; }
        public int CompletedVideos { get; set; }
        public float Progress { get; set; }

    }
}
