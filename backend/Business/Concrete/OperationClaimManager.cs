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
    public class OperationClaimManager : IOperationClaimService
    {
        private readonly IOperationClaimDal _operationClaimDal;

        public OperationClaimManager(IOperationClaimDal operationClaimDal)
        {
            _operationClaimDal = operationClaimDal;
        }

        public OperationClaim GetByName(string roleName)
        {
            return _operationClaimDal.Get(c => c.Name == roleName);
        }
    }

}
