using Business.Abstract;
using DataAccess.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Concrete
{
    public class ChoiceManager : IChoiceService
    {
        private readonly IChoiceDal _choiceDal;

        public ChoiceManager(IChoiceDal choiceDal)
        {
            _choiceDal = choiceDal;
        }

        public void Add(Choice choice)
        {
            _choiceDal.Add(choice);
        }

        public void Update(Choice choice)
        {
            _choiceDal.Update(choice);
        }

        public void Delete(int choiceId)
        {
            var choice = _choiceDal.Get(c => c.ChoiceID == choiceId);
            if (choice != null)
            {
                _choiceDal.Delete(choice);
            }
        }

        public Choice GetById(int choiceId)
        {
            return _choiceDal.Get(c => c.ChoiceID == choiceId);
        }
    }
}
