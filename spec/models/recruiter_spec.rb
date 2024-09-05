require 'rails_helper'

RSpec.describe Recruiter, type: :model do
  let(:recruiter) { build(:recruiter) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(recruiter).to be_valid
    end

    it "is not valid without an email" do
      recruiter.email = nil
      expect(recruiter).to_not be_valid
    end

    it "is not valid with an invalid email format" do
      recruiter.email = "invalid_email"
      expect(recruiter).to_not be_valid
    end

    it "is not valid with a short password" do
      recruiter.password = "short"
      expect(recruiter).to_not be_valid
    end

    it "ensures the email is unique" do
      create(:recruiter, email: recruiter.email)
      expect(recruiter).to_not be_valid
    end
  end

  describe "email downcasing" do
    it "downcases the email before saving" do
      recruiter.email = "EXAMPLE@EMAIL.COM"
      recruiter.save
      expect(recruiter.email).to eq("example@email.com")
    end
  end
end
