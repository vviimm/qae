class QAEFormBuilder

  class QuestionDecorator < QAEDecorator
    def input_name options = {}
      if options[:index]
        suffix = options.fetch(:suffix)
        "#{form_name}[#{delegate_obj.key}][#{options[:index]}][#{suffix}]"
      else
        "#{form_name}[#{hash_key(options)}]"
      end
    end

    def input_value options = {}
      result = if options[:index]
        suffix = options.fetch(:suffix)  
      ## TODO: maybe we switch to JSON from hstore?
        json = JSON.parse(answers[delegate_obj.key] || {})
        json[options[:index]][suffix]
      else
        answers[hash_key(options)]
      end

      if options[:json]
        JSON.parse(result || '{}')
      else
        result
      end
    end

    def required_suffixes
      []
    end

    def array_answer
      false
    end

    def answers
      @decorator_options.fetch(:answers)
    end

    def form_name
      @decorator_options[:form_name] || 'form'
    end

    def hash_key options = {}
      options[:suffix] ? "#{delegate_obj.key}_#{options[:suffix]}" : delegate_obj.key
    end

    def fieldset_classes
      result = ["question-block",
       "js-conditional-answer"]
      result << delegate_obj.classes if delegate_obj.classes
      result << 'question-required' if delegate_obj.required
      result << 'js-conditional-drop-answer' if delegate_obj.drop_condition
      result
    end

    def fieldset_data_hash
      result = {answer: delegate_obj.parameterized_title}
      result['drop-question'] = delegate_obj.form[delegate_obj.drop_condition].parameterized_title if delegate_obj.drop_condition
      result
    end

    def required_visible?
      delegate_obj.required &&
        delegate_obj.conditions.
        all?{|condition|
          step.form[condition.question_key].input_value == condition.question_value
        } ? true : false
    end

    def required_visible_filled?
      return false unless required_visible?

      required_suffixes.blank? ? !input_value.blank? :
        required_suffixes.all?{|s| !input_value(suffix: s).blank?}
    end

  end

  class QuestionBuilder
    def initialize q
      @q = q
    end

    def context text
      @q.context = text
    end

    def classes text
      @q.classes = text
    end

    def ref id
      @q.ref = id
    end

    def required
      @q.required = true
    end

    def help title, text
      @q.help << QuestionHelp.new(title, text)
    end

    def conditional key, value
      @q.conditions << QuestionCondition.new(key, value)
    end

    def drop_conditional key
      @q.drop_condition = key.to_s.to_sym
    end

    def header header
      @q.header = header
    end

    def header_context header_context
      @q.header_context = header_context
    end
  end

  QuestionCondition = Struct.new(:question_key, :question_value)

  QuestionHelp = Struct.new(:title, :text)

  class Question
    attr_accessor :step, :key,  :title, :context, :opts,
      :required, :help, :ref, :conditions, :header, :header_context, :classes, :drop_condition

    def initialize step, key, title, opts={}
      @step = step
      @key = key
      @title = title
      @opts = opts
      @required = false
      @help = []
      @conditions = []
      self.after_create if self.respond_to?(:after_create)
    end

    def decorate options = {}
      kls_name = self.class.name.split('::').last
      kls = QAEFormBuilder.const_get "#{kls_name}Decorator" rescue nil
      (kls || QuestionDecorator).new self, options
    end


    def form
      step.form
    end

    def parameterized_title
      key.to_s + "-" + title.parameterize
    end

  end

end

