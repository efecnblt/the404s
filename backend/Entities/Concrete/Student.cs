
using Core.Entities;
using Core.Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Student:IEntity
    {
        public int StudentId { get; set; } // Primary Key
        public int UserId { get; set; } // Kullanıcı ID'si (Foreign Key)
       
        public DateTime EnrollmentDate { get; set; } // Kayıt tarihi
        

       
    }

}
