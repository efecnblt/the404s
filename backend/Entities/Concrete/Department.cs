using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Department : IEntity
    {
        public int DepartmentID { get; set; }
        public string DepartmentName { get; set; }
        //public List<Author> Authors { get; set; } // Navigation Property
    }

}
