#
# obj = ManualUpdaters::GetStats.new.run
#
# obj.submitted_data
#
# obj.not_submitted_data
#

module ManualUpdaters
  class GetStats

    attr_accessor :submitted_data,
                  :not_submitted_data

    def initialize
      @submitted_data = []
      @not_submitted_data = []
    end

    def run
      award_year = AwardYear.current

      User.includes(:form_answers).find_each do |user|

        apps_count = user.form_answers.where(award_year_id: award_year.id).count
        apps_account_count = user.account.form_answers.where(award_year_id: award_year.id).count

        if apps_count > 0 || apps_account_count > 0

          submitted_apps_count = user.form_answers.where(award_year_id: award_year.id).submitted.count
          submitted_account_apps_count = user.account.form_answers.where(award_year_id: award_year.id).submitted.count

          user_data = [user.email, user.first_name, user.last_name]

          if submitted_apps_count > 0 || submitted_account_apps_count > 0
            @submitted_data << user_data
          else
            @not_submitted_data << user_data
          end
        end
      end

      self
    end
  end
end
