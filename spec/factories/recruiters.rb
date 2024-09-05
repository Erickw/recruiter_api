FactoryBot.define do
  factory :recruiter do
    name { "John Doe" }
    email { Faker::Internet.email }
    password { "password123" }
  end
end
