class Users::AuditCertificateRequestMailer < ApplicationMailer
  def notify(user_id, form_answer_id)
    @form_answer = FormAnswer.find(form_answer_id).decorate
    @recipient = User.find(user_id).decorate
    @deadline = Settings.current.deadlines.where(kind: "audit_certificates").first
    @trigger_at = @deadline.trigger_at
    @deadline = @trigger_at.strftime("%d/%m/%Y")

    @deadline_time = @trigger_at.strftime("%-l:%M%P")
    @deadline_time = "midnight" if midnight?
    @deadline_time = "midday" if midday?

    @subject = "Queen's Awards for Enterprise: Reminder to submit your Verification of Commercial Figures"
    mail to: @recipient.email, subject: @subject
  end

  private

  def midday?
    @trigger_at == @trigger_at.midday
  end

  def midnight?
    @trigger_at == @trigger_at.midnight
  end
end
