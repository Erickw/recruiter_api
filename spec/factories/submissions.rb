FactoryBot.define do
  factory :submission do
    name { "John Doe" }
    email { "johndoe@example.com" }
    mobile_phone { "1234567890" }
    resume { "link_to_resume.pdf" }
    association :job
  end
end
