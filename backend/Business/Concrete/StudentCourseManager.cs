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
    public class StudentCourseManager : IStudentCourseService
    {
        private readonly IStudentCourseDal _studentCourseDal;
        private  IVideoService _videoService;

        public StudentCourseManager(IStudentCourseDal studentCourseDal, IVideoService videoService)
        {
            _studentCourseDal = studentCourseDal;
            _videoService = videoService;
        }

        public void Add(StudentCourse studentCourse)
        {
            _studentCourseDal.Add(studentCourse);
        }

        public List<StudentCourse> GetAll()
        {
            return _studentCourseDal.GetAll();
        }

        public List<StudentCourse> GetByStudentId(int studentId)
        {
            return _studentCourseDal.GetAll(sc => sc.StudentId == studentId);
        }

        public List<StudentCourse> GetByCourseId(int courseId)
        {
            return _studentCourseDal.GetAll(sc => sc.CourseID == courseId);
        }


        public List<Student> GetStudentsByCourse(int courseId)
        {
            return _studentCourseDal.GetStudentsByCourseId(courseId);
        }


        public void UpdateProgress(int studentId, int courseId)
        {
            // Öğrencinin tamamladığı video sayısını getir
            var studentCourse = _studentCourseDal.Get(sc => sc.StudentId == studentId && sc.CourseID == courseId);
            if (studentCourse == null) throw new Exception("Course enrollment not found.");

            // Kursun toplam video sayısını getir
            var totalVideos = _videoService.GetVideosByCourseId(courseId).Count;

            // Progress yüzdesini hesapla
            studentCourse.Progress = totalVideos > 0
                ? (float)studentCourse.CompletedVideos / totalVideos * 100
                : 0;

            // Güncelle
            _studentCourseDal.Update(studentCourse);
        }

        public void MarkVideoAsCompleted(int studentId, int courseId, int videoId)
        {
            // Videoyu tamamlandı olarak işaretle
            var studentCourse = _studentCourseDal.Get(sc => sc.StudentId == studentId && sc.CourseID == courseId);
            if (studentCourse == null) throw new Exception("Course enrollment not found.");

            studentCourse.CompletedVideos++;
            UpdateProgress(studentId, courseId);
        }

    }
}
