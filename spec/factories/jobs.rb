FactoryBot.define do
  factory :job do
    title { "Job Title" }
    description { "Job Description" }
    skills { "Skills List" }
    status { "open" }
    association :recruiter
  end
end
