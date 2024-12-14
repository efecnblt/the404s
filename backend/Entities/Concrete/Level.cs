using Core.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.Concrete
{
    public class Level : IEntity
    {
        public int LevelId { get; set; } // Primary Key
        public string Name { get; set; } // Zorluk seviyesi ismi
    }
}
