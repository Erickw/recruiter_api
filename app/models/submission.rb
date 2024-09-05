class Submission < ApplicationRecord
  belongs_to :job

  validates :name, presence: true
  validates :email, presence: true
  validates :mobile_phone, presence: true
  validates :resume, presence: true
  validates :job_id, presence: true
  validates :email, uniqueness: { scope: :job_id, message: "has already been submitted for this job" }
end
