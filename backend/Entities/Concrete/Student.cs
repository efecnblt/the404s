
using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Student:IEntity
    {
        public int Id { get; set; } // Primary Key
        public int UserId { get; set; } // Kullanıcı ID'si (Foreign Key)
        public int? CourseId { get; set; } // Kurs ID'si (Foreign Key)
        public DateTime EnrollmentDate { get; set; } // Kayıt tarihi
        public float Progress { get; set; } // İlerleme yüzdesi
    }

}
