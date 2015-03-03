class Account < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :form_answers, dependent: :nullify

  has_many :eligibilities, dependent: :destroy
  has_many :basic_eligibilities, class_name: 'Eligibility::Basic'
  has_many :trade_eligibilities, class_name: 'Eligibility::Trade'
  has_many :innovation_eligibilities, class_name: 'Eligibility::Innovation'
  has_many :development_eligibilities, class_name: 'Eligibility::Development'
  has_many :promotion_eligibilities, class_name: 'Eligibility::Promotion'

  belongs_to :owner, class_name: 'User', autosave: false, inverse_of: :owned_account
  validates :owner, presence: true

  def basic_eligibility
    basic_eligibilities.first
  end

  def collaborators_without(user)
    users.excluding(user).by_email
  end

  def has_trade_award_in_this_year?
    form_answers.for_year(Date.today.year + 1).
                 for_award_type(:trade).
                 present?
  end
end
