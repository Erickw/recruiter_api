require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:recruiter) }
    it { is_expected.to have_many(:submissions) }
  end

  describe 'validations' do
    let(:recruiter) { create(:recruiter) }

    subject { create(:job, recruiter: recruiter) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:recruiter_id) }
  end

  describe 'scopes' do
    let!(:job1) { create(:job, title: 'Developer', description: 'Rails Developer', skills: 'Ruby', status: 'open') }
    let!(:job2) { create(:job, title: 'Designer', description: 'UI Designer', skills: 'Sketch', status: 'closed') }

    describe '.search' do
      it 'returns all jobs when query is blank' do
        expect(Job.search('')).to match_array([job1, job2])
      end

      it 'returns jobs matching the query in title, description, or skills' do
        expect(Job.search('Rails')).to match_array([job1])
        expect(Job.search('Designer')).to match_array([job2])
        expect(Job.search('Ruby')).to match_array([job1])
      end
    end

    describe '.with_status_open' do
      it 'returns jobs with status open' do
        expect(Job.with_status_open).to match_array([job1])
      end
    end
  end
end
