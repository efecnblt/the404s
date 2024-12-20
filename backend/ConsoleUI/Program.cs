// See https://aka.ms/new-console-template for more information

using Business.Concrete;
using DataAccess.Concrete.EntityFramework;

//Data Transformation Object
//SOLID
//Open Closed Principle mevcut koda dokunmadan yeni bir özellik eklemek
//ProductTest();
//CategoryTest();

static void ProductTest()
{
    //CourseManager productManager = new CourseManager(new EfCourseDal(), new CategoryManager(new EfCategoryDal()));

    //var result = productManager.GetCourseDetails();

    //if (result.Success == true)
    //{
    //    foreach (var product in result.Data)
    //    {
    //        Console.WriteLine();
    //    }
    //}
    //else
    //{ Console.WriteLine(result.Message); }


}

static void CategoryTest()
{
    CategoryManager categoryManager = new CategoryManager(new EfCategoryDal());
    foreach (var category in categoryManager.GetAll().Data)
    {
        Console.WriteLine(category.Name);
    }
}