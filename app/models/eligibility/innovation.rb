class Eligibility::Innovation < Eligibility
  AWARD_NAME = 'The Innovation Award'

  validates :number_of_innovative_products, presence: true, numericality: { only_integer: true, greater_than_0: true, allow_nil: true }, if: :innovative_product?

  property :innovative_product, boolean: true, label: "Do you have an innovative product/service/initiative?", accept: :true
  property :number_of_innovative_products, positive_integer: true, label: "How many?", accept: :not_nil
  property :was_on_market_for_two_years, boolean: true, label: "Has it been released to the market for at least two years?", accept: :true
  property :had_impact_on_commercial_performace_over_two_years, boolean: true, lable: "Has the innovation had a measurable positive impact on your commercial performance over at least the last two years?", accept: :true
end