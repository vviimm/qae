class QAEFormBuilder
  class TextareaQuestionValidator < QuestionValidator
    def errors
      result = super

      length = question.input_value && question.input_value.split(" ").length

      limit = question.delegate_obj.words_max

      if limit_with_buffer(limit) && length && length > limit_with_buffer(limit)
        result[question.hash_key] ||= ""
        result[question.hash_key] << " Exeeded #{limit} words limit."
      end

      result
    end
  end

  class TextareaQuestionBuilder < QuestionBuilder
    def rows(num)
      @q.rows = num
    end

    def words_max(num)
      @q.words_max = num
    end
  end

  class TextareaQuestion < Question
    attr_accessor :rows, :words_max
  end
end
