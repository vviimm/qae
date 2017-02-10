class QAEFormBuilder
  class StarsQuestionValidator < QuestionValidator
  end

  class StarsQuestionDecorator < QuestionDecorator
  end

  class StarsQuestionBuilder < QuestionBuilder
    def grade grade
      @q.grade = grade
    end
  end

  class StarsQuestion < Question
    attr_accessor :grade
  end
end
