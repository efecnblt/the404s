using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Order:IEntity
    {
        public int Id { get; set; }
        public int AuthID { get; set; }
        public string AuthName { get; set; }
        public string StudentID { get; set; }
        public string StudentName { get; set; }
        public DateTime OrderDate { get; set; }
        

    }
}
