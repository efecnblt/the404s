using Core.DataAccess.EntityFramework;
using Core.Entities.Concrete;
using DataAccess.Abstract;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess.Concrete.EntityFramework
{
    public class EfUserOperationClaimDal : EfEntityRepositoryBase<UserOperationClaim, SWContext>, IUserOperationClaimDal
    {
        // İhtiyaç halinde ek metotlar ekleyebilirsiniz.
        public List<OperationClaim> GetClaimsByUserId(int userId)
        {
            using (var context = new SWContext())
            {
                var result = from userClaim in context.UserOperationClaims
                             join claim in context.OperationClaims
                             on userClaim.OperationClaimId equals claim.Id
                             where userClaim.UserId == userId
                             select new OperationClaim
                             {
                                 Id = claim.Id,
                                 Name = claim.Name
                             };
                return result.ToList();
            }
        }
    }

}
