require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:recruiter) }
    it { is_expected.to have_many(:submissions) }
  end

  describe 'validations' do
    let(:recruiter) { create(:recruiter) }

    subject { build(:job, recruiter: recruiter) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:recruiter_id) }
    it { is_expected.to validate_uniqueness_of(:title) }

    context 'when title is not unique' do
      before do
        create(:job, title: 'Unique Title', recruiter: recruiter)
      end

      it 'is not valid' do
        job = build(:job, title: 'Unique Title', recruiter: recruiter)
        expect(job).not_to be_valid
        expect(job.errors[:title]).to include('has already been taken')
      end
    end

    context 'when title is blank' do
      it 'is not valid' do
        job = build(:job, title: '', recruiter: recruiter)
        expect(job).not_to be_valid
        expect(job.errors[:title]).to include("can't be blank")
      end
    end

    context 'when description is blank' do
      it 'is not valid' do
        job = build(:job, description: '', recruiter: recruiter)
        expect(job).not_to be_valid
        expect(job.errors[:description]).to include("can't be blank")
      end
    end

    context 'when recruiter_id is blank' do
      it 'is not valid' do
        job = build(:job, recruiter_id: nil)
        expect(job).not_to be_valid
        expect(job.errors[:recruiter_id]).to include("can't be blank")
      end
    end
  end

  describe 'scopes' do
    let!(:job1) { create(:job, title: 'Developer', description: 'Rails Developer', skills: 'Ruby', status: 'open') }
    let!(:job2) { create(:job, title: 'Designer', description: 'UI Designer', skills: 'Sketch', status: 'closed') }
    let!(:job3) { create(:job, title: 'Manager', description: 'Project Manager', skills: 'Leadership', status: 'open') }

    describe '.search' do
      it 'returns all jobs when query is blank' do
        expect(Job.search('')).to match_array([job1, job2, job3])
      end

      it 'returns jobs matching the query in title' do
        expect(Job.search('Developer')).to match_array([job1])
      end

      it 'returns jobs matching the query in description' do
        expect(Job.search('UI Designer')).to match_array([job2])
      end

      it 'returns jobs matching the query in skills' do
        expect(Job.search('Leadership')).to match_array([job3])
      end

      it 'returns no jobs when query does not match' do
        expect(Job.search('Nonexistent')).to be_empty
      end
    end

    describe '.with_status_open' do
      it 'returns only jobs with status open' do
        expect(Job.with_status_open).to match_array([job1, job3])
      end

      it 'does not return jobs with other statuses' do
        expect(Job.with_status_open).not_to include(job2)
      end
    end
  end

  describe 'factory' do
    let(:recruiter) { create(:recruiter) }
    it 'creates a valid job' do
      job = build(:job, recruiter: recruiter)
      expect(job).to be_valid
    end
  end
end
