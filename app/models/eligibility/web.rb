class Eligibility::Web < Eligibility
  AWARD_NAME = 'Web Development'

  property :was_on_market_for_five_years,
            boolean: true,
            label: "Did you play on WEB market at least five years?",
            accept: :true

  property :number_of_applications,
            values: ["less than 10", "10-20", "more than 30"],
            label: "How many WEB applications and services did you publish?",
            accept: :not_nil

  property :which_year_started,
           values: (AwardYear.current.year - 5..AwardYear.current.year - 1).to_a.reverse + ["before_#{AwardYear.current.year - 5}"],
           accept: :not_nil,
           label: "In which year did you start working in WEB?",
           allow_nil: true

  property :does_all_your_clients_happy,
            boolean: true,
            label: "Does all your clients are happy with your work?",
            accept: :true

  property :web_success,
            boolean: true,
            label: "Has the your work had a positive impact on your commercial success?",
            hint: "Commercial success means financial success in terms of savings or growth and might also include non-financial factors, e.g. reputation, employee relations.",
            accept: :true
end
