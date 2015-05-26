class CurrentAwardTypePicker
  # If Assessor is a lead in at least one category
  # and is a lead or assigned as regular to another category
  # he sees the tabs with these categories displayed

  attr_reader :params, :current_subject

  def initialize(current_subject, params)
    @current_subject = current_subject
    @params = params
  end

  def current_award_type
    lead_categories = current_subject.categories_as_lead
    return nil if lead_categories.blank?
    regular_categories = current_subject.applications_scope.pluck(:award_type).uniq
    categories = lead_categories + regular_categories
    if params[:award_type].present?
      params[:award_type] if categories.include?(params[:award_type])
    else
      categories.first
    end
  end

  def visible_categories
    lead_categories = current_subject.categories_as_lead
    regular_categories = current_subject.applications_scope.pluck(:award_type).uniq
    (lead_categories + regular_categories).uniq
  end

  def show_award_tabs_for_assessor?
    if current_subject.categories_as_lead.size > 0
      return true if visible_categories.size > 1
    end
  end
end