require "rails_helper"
include Warden::Test::Helpers

describe "SIC Code selection", "
  As Admin
  I want to set up the SIC Code per application." do

  let!(:admin) { create(:admin) }
  let!(:form_answer) { create(:form_answer) }
  let(:selected) { "1623 - Manufacture of other builders' carpentry and joinery" }
  before do
    login_admin admin
    visit admin_form_answer_path(form_answer)
  end

  it "sets up the sic code per form" do
    find("#form_answer_sic_code").find(:xpath, "option[2]").select_option
    click_button "update_application"
    expect(page).to have_css("p", text: selected)
  end
end