require "prawn/measurement_extensions"

class AuditCertificatePdf < Prawn::Document
  include PdfAuditCertificates::General::SharedElements
  include FormAnswersBasePointer

  attr_reader :audit_data,
              :form_answer,
              :award_type

  def initialize(form_answer)
    super()

    @form_answer = form_answer.decorate
    @award_type = form_answer.award_type.downcase
    @audit_data = FormFinancialPointer.new(form_answer).data

    generate!
  end

  def generate!
    render_content
  end

  def render_content
    render_first_page
    start_new_page
    render_second_page
  end

  def render_first_page
    render_main_header
    render_base_paragraph
    render_financial_table
    render_options_list
    render_user_filling_block
    render_footer_note
  end

  def render_second_page
    render_main_header
    render_revised_schedule
    render_financial_table
    render_explanation_of_the_changes
    render_additional_comments
  end
end