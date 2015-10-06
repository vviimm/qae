class AssessmentSubmissionService
  attr_reader :resource, :current_subject

  def initialize(assignment, current_subject)
    @resource = assignment
    @current_subject = current_subject
  end

  def perform
    return if resource.submitted?
    if submit_assessment
      populate_case_summary
    end

    if resource.moderated?
      resource.form_answer.state_machine.assign_lead_verdict(resource.verdict_rate, current_subject)
    end
  end

  delegate :as_json, to: :resource

  private

  def submit_assessment
    resource.update(submitted_at: DateTime.now)
  end

  def populate_case_summary
    if resource.moderated?
      case_summary = record(AssessorAssignment.positions[:case_summary])
      primary_assessment = record(AssessorAssignment.positions[:primary])
      moderated_assessment = record(AssessorAssignment.positions[:moderated])

      document = primary_assessment.document.merge(
        "verdict_rate" => moderated_assessment.document["verdict_rate"]
      )

      case_summary.document = document
      case_summary.save
    end
  end

  def primary_and_lead_is_the_same_person?
    # possibly some logic can be reviewed
    primary = resource.form_answer.assessors.primary
    Assessor.leads_for(resource.form_answer.award_type).include?(primary)
  end

  def record(position)
    AssessorAssignment.where(
      form_answer_id: resource.form_answer_id, position: position
    ).first_or_create
  end
end
