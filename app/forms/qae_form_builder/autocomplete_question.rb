class QAEFormBuilder
  class AutocompleteQuestionValidator < QuestionValidator
  end

  class AutocompleteQuestionDecorator < QuestionDecorator
    def entities
      @entities ||= (answers[delegate_obj.key.to_s] || [])
    end
  end

  class AutocompleteQuestionBuilder < QuestionBuilder
    def tags options
      @q.tags = options
    end
  end

  class AutocompleteQuestion < Question
    attr_accessor :tags
  end
end
