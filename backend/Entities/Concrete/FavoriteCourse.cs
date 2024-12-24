using Core.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class FavoriteCourse : IEntity
    {
        [Key]
        public int FavoriteID { get; set; }
        public int StudentID { get; set; }
        public int CourseID { get; set; }

        //public Course Course { get; set; }
    }

}
