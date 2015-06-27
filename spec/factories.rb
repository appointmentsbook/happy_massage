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
  end

  factory(:massage) do
    user
    masseur
    timetable Time.zone.now

  end
end