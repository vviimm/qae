class Users::UnsuccessfulFeedbackMailer < ApplicationMailer
  def notify(form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @user = @form_answer.user.decorate

    subject = "Queen's Award for Enterprise: Application Feedback"
    mail to: @user.email, subject: subject
  end
end
