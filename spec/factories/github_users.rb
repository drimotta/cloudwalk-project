FactoryBot.define do
  factory :github_user do
    sequence(:name) { |n| "gh-user-#{n}" }
  end
end
