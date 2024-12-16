using Core.Entities.Concrete;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.Abstract
{
    public interface IUserOperationClaimService
    {
        void Add(UserOperationClaim userOperationClaim);
        void Update(UserOperationClaim userOperationClaim);
        void Delete(UserOperationClaim userOperationClaim);
        List<OperationClaim> GetClaimsByUserId(int userId);
    }

}
