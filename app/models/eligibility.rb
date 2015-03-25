class Eligibility < ActiveRecord::Base
  extend Enumerize

  belongs_to :account
  belongs_to :form_answer
  after_update :trigger_eligibility_transition, if: :answers_changed?

  attr_accessor :current_step

  validate :current_step_validation

  def self.questions
    @questions.keys
  end

  def self.hint(name)
    @questions[name.to_sym][:hint]
  end

  def self.label(name)
    @questions[name.to_sym][:label]
  end

  def self.additional_label(name)
    @questions[name.to_sym][:additional_label] || label(name)
  end

  def self.boolean_question?(name)
    !!@questions[name.to_sym][:boolean]
  end

  def self.integer_question?(name)
    !!@questions[name.to_sym][:positive_integer]
  end

  def self.questions_storage
    @questions
  end

  def self.award_name
    const_get(:AWARD_NAME)
  end

  def self.property(name, options = {})
    @questions ||= {}

    values = options[:values]

    store_accessor :answers, name

    if values && values.any?
      enumerize name, in: values
    end

    if options[:boolean] || options[:acts_like_boolean]
      define_method "#{name}?" do
        ['1', 'true', 'yes', true].include?(public_send(name))
      end
    end

    if options[:positive_integer]
      validates name, numericality: { only_integer: true, greater_than_0: true, allow_nil: true }, if: proc { current_step == name }
    end

    @questions.merge!(name => options)
  end

  def eligible?
    questions.all? do |question|
      answer = answers && answers[question.to_s]
      answer_valid?(question, answer)
    end
  end

  def eligible_on_step?(step)
    current_step_index = questions.index(step) || questions.size - 1
    previous_questions = questions[0..current_step_index]

    answers.any? && answers.all? do |question, answer|
      if previous_questions.include?(question.to_sym)
        answer_valid?(question, answer)
      else
        true
      end
    end
  end

  def sorted_answers
    return {} unless answers

    @sorted_answers ||= begin
      sorted = {}

      self.class.questions.each do |question|
        if answers[question.to_s]
          sorted[question.to_s] = answers[question.to_s]
        end
      end

      sorted
    end
  end

  def questions
    questions_storage.keys
  end

  # legacy
  def skipped?
    false
  end

  def answer_valid?(question, answer)
    acceptance_criteria = self.class.questions_storage[question.to_sym][:accept].to_s
    validator = "Eligibility::Validation::#{acceptance_criteria.camelize}Validation".constantize.new(self, question, answer)
    validator.valid?
  end

  def pass!
    update_column(:passed, true)
  end

  private

  def questions_storage
    collection = {}

    self.class.questions_storage.each do |question, options|
      if options[:if]
        if instance_eval(&options[:if])
          collection.merge!(question => options)
        end
      else
        collection.merge!(question => options)
      end
    end

    collection
  end

  def current_step_validation
    if current_step && public_send(current_step).nil?
      errors.add(current_step, :blank)
    end
  end

  def trigger_eligibility_form_change
    form_answer.trigger_eligibility_transition
  end
end
