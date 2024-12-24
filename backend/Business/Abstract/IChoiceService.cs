using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface IChoiceService
    {
        void Add(Choice choice);
        void Update(Choice choice);
        void Delete(int choiceId);
        Choice GetById(int choiceId);
    }
}
