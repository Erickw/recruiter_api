class Job < ApplicationRecord
  belongs_to :recruiter
  has_many :submissions

  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validates :recruiter_id, presence: true

  scope :search, -> (query) {
    ap 'query eg'
    ap query
    return all if query.blank?

    where('title ILIKE ? OR description ILIKE ? OR skills ILIKE ?', "%#{query}%", "%#{query}%", "%#{query}%")
  }

  scope :with_status_open, -> { where(status: "open") }
end
