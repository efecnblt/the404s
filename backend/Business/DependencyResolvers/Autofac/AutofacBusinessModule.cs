using Autofac;
using Autofac.Extras.DynamicProxy;
using Business.Abstract;
using Business.Concrete;
using Castle.DynamicProxy;
using Core.Utilities.Interceptors;
using Core.Utilities.Security.JWT;
using DataAccess.Abstract;
using DataAccess.Concrete.EntityFramework;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Business.DependencyResolvers.Autofac
{
    public class AutofacBusinessModule : Module
    {
        protected override void Load(ContainerBuilder builder)
        {

            builder.RegisterType<CourseManager>().As<ICourseService>().SingleInstance();
            builder.RegisterType<EfCourseDal>().As<ICourseDal>().SingleInstance();

            builder.RegisterType<CategoryManager>().As<ICategoryService>().SingleInstance();
            builder.RegisterType<EfCategoryDal>().As<ICategoryDal>().SingleInstance();

            builder.RegisterType<OperationClaimManager>().As<IOperationClaimService>().SingleInstance();
            builder.RegisterType<EfOperationClaimDal>().As<IOperationClaimDal>().SingleInstance();

            builder.RegisterType<UserOperationClaimManager>().As<IUserOperationClaimService>().SingleInstance();
            builder.RegisterType<EfUserOperationClaimDal>().As<IUserOperationClaimDal>().SingleInstance();

            builder.RegisterType<LearningOutcomeManager>().As<ILearningOutcomeService>().SingleInstance();
            builder.RegisterType<EfLearningOutcomeDal>().As<ILearningOutcomeDal>().SingleInstance();

            builder.RegisterType<AuthorManager>().As<IAuthorService>().SingleInstance();
            builder.RegisterType<EfAuthorDal>().As<IAuthorDal>().SingleInstance();

            builder.RegisterType<DepartmentManager>().As<IDepartmentService>().SingleInstance();
            builder.RegisterType<EfDepartmentDal>().As<IDepartmentDal>().SingleInstance();

            builder.RegisterType<QuizManager>().As<IQuizService>().SingleInstance();
            builder.RegisterType<EfQuizDal>().As<IQuizDal>().SingleInstance();

            builder.RegisterType<StudentCourseManager>().As<IStudentCourseService>().SingleInstance();
            builder.RegisterType<EfStudentCourseDal>().As<IStudentCourseDal>().SingleInstance();

            builder.RegisterType<LevelManager>().As<ILevelService>().SingleInstance();
            builder.RegisterType<EfLevelDal>().As<ILevelDal>().SingleInstance();

            builder.RegisterType<StudentManager>().As<IStudentService>().SingleInstance();
            builder.RegisterType<EfStudentDal>().As<IStudentDal>().SingleInstance();

            builder.RegisterType<SectionManager>().As<ISectionService>().SingleInstance();
            builder.RegisterType<EfSectionDal>().As<ISectionDal>().SingleInstance();

            builder.RegisterType<VideoManager>().As<IVideoService>().SingleInstance();
            builder.RegisterType<EfVideoDal>().As<IVideoDal>().SingleInstance();

            builder.RegisterType<QuestionManager>().As<IQuestionService>().SingleInstance();
            builder.RegisterType<EfQuestionDal>().As<IQuestionDal>().SingleInstance();


            builder.RegisterType<ChoiceManager>().As<IChoiceService>().SingleInstance();
            builder.RegisterType<EfChoiceDal>().As<IChoiceDal>().SingleInstance();

            builder.RegisterType<StudentAnswerManager>().As<IStudentAnswerService>().SingleInstance();
            builder.RegisterType<EfStudentAnswerDal>().As<IStudentAnswerDal>().SingleInstance();
       

            builder.RegisterType<FavoriteCourseManager>().As<IFavoriteCourseService>().SingleInstance();
            builder.RegisterType<EfFavoriteCourseDal>().As<IFavoriteCourseDal>().SingleInstance();

            builder.RegisterType<UserManager>().As<IUserService>();
            builder.RegisterType<EfUserDal>().As<IUserDal>();


            builder.RegisterType<AuthManager>().As<IAuthService>();
            builder.RegisterType<JwtHelper>().As<ITokenHelper>();

            var assembly = System.Reflection.Assembly.GetExecutingAssembly();

            builder.RegisterAssemblyTypes(assembly).AsImplementedInterfaces()
                .EnableInterfaceInterceptors(new ProxyGenerationOptions()
                {
                    Selector = new AspectInterceptorSelector()
                }).SingleInstance();

        }
    }
}
