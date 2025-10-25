FactoryBot.define do
  factory :diary do
    sequence(:title) { |n| "Diary Entry #{n}" }
    content { "# My Diary\n\nThis is a **sample** diary entry with _markdown_." }
    association :user
  end
end
