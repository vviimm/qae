require "rails_helper"

describe "Submission of SupportLetter", %{
As a Supporter
I want to be able to fill and submit support letter
So that I can support my nominator
} do
  let!(:user) { create(:user) }
  let!(:form_answer) { create(:form_answer, user: user) }
  let!(:supporter) do
    create :supporter, form_answer: form_answer,
                       user: user
  end
  let(:access_key) { supporter.access_key }
  let(:support_letter) do
    SupportLetter.last
  end

  describe "Show" do
    it "should reject supporter with wrong access key" do
      visit support_letter_url(access_key: "foobar")
      expect(page.status_code).to eq(404)
    end

    it "should allow to access to letter with proper access_key" do
      visit support_letter_url(access_key: supporter.access_key)

      expect(page.status_code).to eq(200)
      expect_to_see supporter.form_answer.user.decorate.general_info
    end

    describe "Already submitted letter" do
      let!(:support_letter) do
        create :support_letter, form_answer: form_answer,
                                user: user,
                                supporter: supporter
      end

      before do
        support_letter
        visit support_letter_url(access_key: supporter.access_key)
      end

      it "should not allow to update already submitted letter" do
        expect_to_see "Support Letter already submitted!"
        expect(current_path).to be_eql root_path
      end
    end
  end

  describe "Submission" do
    before do
      visit support_letter_url(access_key: supporter.access_key)
    end

    describe "validations" do
      it "should not allow to submit empty letter" do
        # Clear prefilled supporter data
        fill_in "First name", with: ""
        fill_in "Surname", with: ""
        fill_in "support_letter_relationship_to_nominee", with: ""

        expect do
          click_on "Save"
        end.not_to change {
          SupportLetter.count
        }

        expect_to_see "This field cannot be blank"
      end
    end

    it "should allow to submit proper letter" do
      fill_in "First name", with: "Test"
      fill_in "Surname", with: "Test"
      fill_in "support_letter_relationship_to_nominee", with: "Friend"

      expect do
        click_on "Save"
      end.to change {
        SupportLetter.count
      }.by(1)

      expect_to_see "Support letter was successfully created"

      expect(support_letter.supporter_id).to be_eql supporter.id
      expect(support_letter.form_answer_id).to be_eql form_answer.id
      expect(support_letter.user_id).to be_eql user.id
    end
  end
end
