using Business.Abstract;
using Core.Entities.Concrete;
using DataAccess.Abstract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Concrete
{
    public class UserOperationClaimManager : IUserOperationClaimService
    {
        private readonly IUserOperationClaimDal _userOperationClaimDal;

        public UserOperationClaimManager(IUserOperationClaimDal userOperationClaimDal)
        {
            _userOperationClaimDal = userOperationClaimDal;
        }

        public void Add(UserOperationClaim userOperationClaim)
        {
            _userOperationClaimDal.Add(userOperationClaim);
        }

        public void Update(UserOperationClaim userOperationClaim)
        {
            _userOperationClaimDal.Update(userOperationClaim);
        }

        public void Delete(UserOperationClaim userOperationClaim)
        {
            _userOperationClaimDal.Delete(userOperationClaim);
        }

        public List<OperationClaim> GetClaimsByUserId(int userId)
        {
            return _userOperationClaimDal.GetClaimsByUserId(userId);
        }
    }

}
