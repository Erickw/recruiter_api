require 'rails_helper'

RSpec.describe Submission, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:job) }
  end

  describe 'validations' do
    let(:job) { create(:job) }

    subject { build(:submission, job: job) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:mobile_phone) }
    it { is_expected.to validate_presence_of(:resume) }
    it { is_expected.to validate_presence_of(:job_id) }

    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:job_id).with_message("has already been submitted for this job") }

    context 'when email is already taken for the same job' do
      before do
        create(:submission, email: 'duplicate@example.com', job: job)
      end

      it 'is not valid' do
        submission = build(:submission, email: 'duplicate@example.com', job: job)
        expect(submission).not_to be_valid
        expect(submission.errors[:email]).to include("has already been submitted for this job")
      end
    end

    context 'when email is not unique for a different job' do
      let(:another_job) { create(:job) }

      it 'is valid' do
        submission = build(:submission, email: 'unique@example.com', job: another_job)
        expect(submission).to be_valid
      end
    end
  end

  describe 'factory' do
    let(:job) { create(:job) }
    it 'creates a valid submission' do
      submission = build(:submission, job: job)
      expect(submission).to be_valid
    end
  end
end
