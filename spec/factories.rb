FactoryGirl.define do
  sequence(:name) { |n| "Name#{n}" }
  sequence(:email) { |n| "email#{n}@example.com" }

  factory(:user) do
    name
    email
  end

  factory(:masseur) do
    name
    email

    trait :enabled do
      status :enabled
    end

    trait :disabled do
      status :disabled
    end
  end

  factory(:massage) do
    user
    masseur
    timetable Time.zone.now

    trait :attended do
      status :attended
    end

    trait :cancelled do
      status :cancelled
    end

    trait :missed do
      status :missed
    end
  end
end
