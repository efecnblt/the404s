using Entities.Concrete;
using FluentValidation;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.ValidationRules.FluentValidation
{
    public class CourseValidator : AbstractValidator<Course>
    {
        public CourseValidator()
        {
            RuleFor(p => p.Name).MinimumLength(2);
            RuleFor(p => p.Name).NotEmpty();
           // RuleFor(p => p.UnitPrice).NotEmpty();
           // RuleFor(p => p.UnitPrice).GreaterThan(0);
            //RuleFor(p => p.UnitPrice).GreaterThanOrEqualTo(10).When(p => p.CategoryId == 1);
           // RuleFor(p => p.Name).Must(StartWithA).WithMessage("Product Name must start with A");


        }

        private bool StartWithA(string arg)
        {
            return arg.StartsWith("A");
        }
    }
}
