FactoryBot.define do
  factory :application_choice do
    application_form
    course_option

    trait :rejected do
      rejected { true }
    end
  end
end
