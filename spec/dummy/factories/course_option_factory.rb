FactoryBot.define do
  factory :course_option do
    trait :part_time do
      part_time { true }
    end
  end
end
