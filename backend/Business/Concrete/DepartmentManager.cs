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
    public class DepartmentManager : IDepartmentService
    {
        private readonly IDepartmentDal _departmentDal;

        public DepartmentManager(IDepartmentDal departmentDal)
        {
            _departmentDal = departmentDal;
        }

        public void Add(Department department)
        {
            _departmentDal.Add(department);
        }

        public void Update(Department department)
        {
            _departmentDal.Update(department);
        }

        public void Delete(int departmentId)
        {
            var department = _departmentDal.Get(d => d.DepartmentID == departmentId);
            if (department != null)
            {
                _departmentDal.Delete(department);
            }
        }

        public List<Department> GetAll()
        {
            return _departmentDal.GetAll();
        }

        public Department GetById(int departmentId)
        {
            return _departmentDal.Get(d => d.DepartmentID == departmentId);
        }
    }

}
