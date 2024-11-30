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
    public class EfOperationClaimDal : EfEntityRepositoryBase<OperationClaim, SWContext>, IOperationClaimDal
    {
        public OperationClaim GetByName(string name)
        {
            using (var context = new SWContext())
            {
                return context.OperationClaims.FirstOrDefault(c => c.Name == name);
            }
        }
    }

}
