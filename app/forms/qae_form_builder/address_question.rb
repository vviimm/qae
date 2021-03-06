class QAEFormBuilder
  class AddressQuestionValidator < QuestionValidator
    NO_VALIDATION_SUB_FIELDS = [:street, :county]
    def errors
      result = super

      if question.required?
        question.required_sub_fields.each do |sub_field|
          suffix = sub_field.keys[0]
          if !question.input_value(suffix: suffix).present? && NO_VALIDATION_SUB_FIELDS.exclude?(suffix)
            result[question.hash_key(suffix: suffix)] ||= ""
            result[question.hash_key(suffix: suffix)] << " Can't be blank."
          end
        end
      end

      # need to add question-has-errors class
      result[question.hash_key] ||= "" if result.any?

      result
    end
  end

  class AddressQuestionDecorator < QuestionDecorator
    REGIONS = [
      "East",
      "East Midlands",
      "West Midlands",
      "London",
      "North East",
      "North West",
      "South East",
      "South West",
      "Yorkshire and the Humber",
      "Channel Islands",
      "Isle of Man",
      "Northern Ireland",
      "Scotland",
      "Wales"
    ]

    def required_sub_fields
      if sub_fields.present?
        sub_fields
      else
        [
          { building: "Building" },
          { street: "Street", ignore_validation: true },
          { city: "Town or city" },
          { country: "Country" },
          { postcode: "Postcode" },
          { region: "Region" }
        ]
      end
    end

    def regions
      REGIONS
    end

    def rendering_sub_fields
      # We are rejecting :street, because :building and :street
      # are rendering together in same block
      # and the :building is the first one
      required_sub_fields.reject do |f|
        f.keys.include?(:street)
      end.map do |f|
        [f.keys.first, f.values.first]
      end
    end
  end

  class AddressQuestionBuilder < QuestionBuilder
    def countries countries
      @q.countries = countries
    end

    def sub_fields fields
      @q.sub_fields = fields
    end
  end

  class AddressQuestion < Question
    attr_accessor :countries, :sub_fields
  end
end
