FactoryGirl.define do
  sequence(:name) { |n| "Name#{n}" }
  sequence(:email) { |n| "email#{n}@example.com" }

  factory(:user) do
    name
    email
  end
end