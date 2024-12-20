using Business.Abstract;
using Core.Utilities.Results;
using DataAccess.Abstract;
using Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Concrete
{
    public class LearningOutcomeManager : ILearningOutcomeService
    {
        private readonly ILearningOutcomeDal _learningOutcomeDal;

        public LearningOutcomeManager(ILearningOutcomeDal learningOutcomeDal)
        {
            _learningOutcomeDal = learningOutcomeDal;
        }

        public IResult Add(LearningOutcome learningOutcome)
        {
            _learningOutcomeDal.Add(learningOutcome);
            return new SuccessResult("Learning outcome added successfully.");
        }

        public IDataResult<List<LearningOutcome>> GetByCourseId(int courseId)
        {
            var results = _learningOutcomeDal.GetAll(lo => lo.CourseID == courseId);
            return new SuccessDataResult<List<LearningOutcome>>(results);
        }
    }
}
