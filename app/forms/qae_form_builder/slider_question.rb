class QAEFormBuilder
  class SliderQuestionValidator < QuestionValidator
  end

  class SliderQuestionDecorator < QuestionDecorator
    def entities
      @entities ||= (answers[delegate_obj.key.to_s] || "")
    end
  end

  class SliderQuestionBuilder < QuestionBuilder
    def min v
      @q.min = v
    end

    def max v
      @q.max = v
    end
  end

  class SliderQuestion < Question
    attr_accessor :min, :max
  end
end
