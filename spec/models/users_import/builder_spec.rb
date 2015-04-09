require "rails_helper"

describe UsersImport::Builder do
  subject { described_class.new("#{Rails.root}/spec/fixtures/users.csv") }

  describe "#process" do
    it "imports the users" do
      subject.process
      row = User.where(email: "user1@example.com").first
      expect(row.first_name).to eq("First name1")
      expect(row.last_name).to eq("Last name1")
      expect(row.mobile_number).to eq("234324237")
      expect(row.created_at).to eq(Date.new(2014, 8, 4))
    end
  end
end