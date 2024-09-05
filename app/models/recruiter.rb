class Recruiter < ApplicationRecord
  has_secure_password
  has_many :jobs
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, :on => [:create, :update]

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
