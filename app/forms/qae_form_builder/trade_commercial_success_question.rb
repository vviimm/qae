class QAEFormBuilder
  class TradeCommercialSuccessQuestionValidator < OptionsQuestionValidator
  end

  class PlaceholderPreselectedCondition
    attr_accessor :question_key,
                  :question_suffix,
                  :parent_question_answer_key,
                  :answer_key,
                  :question_value,
                  :placeholder_text

    def initialize(question_key, options={})
      @question_key = question_key
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end
  end

  class TradeCommercialSuccessQuestion < OptionsQuestion
    attr_accessor :main_header,
                  :placeholder_preselected_conditions,
                  :options,
                  :question_key,
                  :default_option

    def after_create
      @placeholder_preselected_conditions = []
      @options = []
    end
  end

  class TradeCommercialSuccessQuestionBuilder < OptionsQuestionBuilder
    def main_header text
      @q.main_header = text
    end

    def placeholder_preselected_condition(q_key, options={})
      @q.question_key = q_key
      @q.placeholder_preselected_conditions << PlaceholderPreselectedCondition.new(q_key, options)
    end

    def default_option(option)
      @q.default_option = option
    end
  end

  class TradeCommercialSuccessQuestionDecorator < QuestionDecorator
    def linked_answers
      answers[delegate_obj.question_key.to_s] || []
    end

    def preselected_condition
      placeholder_preselected_conditions.detect do |c|
        linked_answers.any? do |a|
          a["category"] == "international_trade" &&
            a["year"].to_i > (AwardYear.current.year - 5)
        end && answers["queen_award_holder"] == "yes"
      end
    end

    def placeholder_preselected_conditions
      delegate_obj.placeholder_preselected_conditions
    end

    def preselected_condition_by_option(option)
      placeholder_preselected_conditions.detect do |condition|
        condition.question_value == option.value
      end
    end

    def depends_on
      delegate_obj.question_key.to_s
    end
  end
end
