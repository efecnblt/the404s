using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Author:IEntity
    {
        public int AuthorID { get; set; } // Primary Key
        public string Name { get; set; } // Adı ve Soyadı
        public double? Rating { get; set; } // Ortalama Puan
        public int? StudentCount { get; set; } // Toplam Öğrenci Sayısı
        public int? CourseCount { get; set; } // Toplam Kurs Sayısı
        public string? ImageURL { get; set; } // Profil Resmi URL'si

    }
}
