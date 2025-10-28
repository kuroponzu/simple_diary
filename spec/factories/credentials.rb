FactoryBot.define do
  factory :credential do
    user { nil }
    external_id { "MyString" }
    public_key { "MyText" }
    sign_count { 1 }
    nickname { "MyString" }
  end
end
