require "countries"

module FormAnswerHelper
  def application_flags(fa, subject = nil)
    comments = fa.comments

    c_size = comments.select do |c|
      main = c.main_for?(current_subject)
      (subject ? main : !main) && c.flagged?
    end.size

    current_user_class = current_subject.model_name.to_s.parameterize

    flag_type = if subject
      "icon-flag-#{current_user_class}"
    else
      current_user_class == "admin" ? "icon-flag-assessor" : "icon-flag-admin"
    end

    if c_size > 0
      content_tag :span, class: "icon-flagged #{flag_type}" do
        content_tag :span, class: "flag-count" do
          c_size.to_s
        end
      end
    end
  end

  def user_can_edit(form, item)
    policy(form).update_item?(item) && form.submitted_and_after_the_deadline?
  end

  def application_comments(comments)
    visible_comments = comments

    return unless visible_comments.present?

    output = "<span class='icon-comment'>Comments: <span class='comment-count'>"
    output += "#{visible_comments.size}"
    output += "</span></span>"
    output.html_safe
  end

  def award_types_collection
    FormAnswerDecorator::SELECT_BOX_LABELS.invert.to_a
  end

  def sic_code(form_answer)
    code = form_answer.sic_code
    code || "-"
  end

  def country_collection
    ([["United Kingdom", "GB"], ["United States", "US"]] + Country.all).uniq
  end

  def feedback_updated_by(form_answer)
    feedback = form_answer.feedback
    if feedback && feedback.authorable.present?
      "Updated by: #{feedback.authorable.decorate.full_name} - #{format_date(feedback.updated_at)}"
    end
  end

  def press_summary_updated_by(form_answer)
    ps = form_answer.press_summary
    if ps.present? && ps.authorable.present?
      "Updated by #{ps.authorable.decorate.full_name} - #{format_date(ps.updated_at)}"
    end
  end

  def assessors_collection_for_bulk
    assessors = Assessor.available_for(category_picker.current_award_type).map { |a| [a.full_name, a.id] }
    [["Not Assigned", "not assigned"]] + assessors
  end
end
