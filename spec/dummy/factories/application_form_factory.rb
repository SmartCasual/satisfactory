FactoryBot.define do
  factory :application_form do
    candidate

    first_name { 'Griergory' }

    trait :submitted do
      submitted { true }
    end
  end
end
