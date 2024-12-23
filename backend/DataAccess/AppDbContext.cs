using Microsoft.EntityFrameworkCore;
using Entities.Concrete;
using Core.Entities.Concrete;


namespace DataAccess.Concrete.EntityFramework
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Author> Authors { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<Course> Courses { get; set; }
        public DbSet<Section> Sections { get; set; }
        public DbSet<Video> Videos { get; set; }
        public DbSet<Level> Levels { get; set; }
        public DbSet<LearningOutcome> LearningOutcomes { get; set; }
        public DbSet<Quiz> Quizzes { get; set; }
        public DbSet<Student> Students { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<Favorite> Favorites { get; set; }
        public DbSet<StudentQuizResult> StudentQuizResults { get; set; }
        public DbSet<OperationClaim> OperationClaims { get; set; }
        public DbSet<UserOperationClaim> UserOperationClaims { get; set; }
    }
}