using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Entities.DTOs
{
    public class QuizWithQuestionsDto
    {
        public int SectionID { get; set; }
        public string Name { get; set; }
        public int TotalPoints { get; set; }
        public List<QuestionDto> Questions { get; set; }
    }

    public class QuestionDto
    {
        public string QuestionText { get; set; } // Doğru isim
        public List<ChoiceDto> Choices { get; set; }
    }

    public class ChoiceDto
    {
        public string ChoiceText { get; set; } // Doğru isim
        public bool IsCorrect { get; set; }
    }

}


