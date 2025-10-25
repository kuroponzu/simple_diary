require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it "has many diaries" do
      association = User.reflect_on_association(:diaries)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe "validations" do
    let(:user) { build(:user) }

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user.email = nil
      expect(user).not_to be_valid
    end

    it "is not valid with a duplicate email" do
      create(:user, email: "test@example.com")
      user.email = "test@example.com"
      expect(user).not_to be_valid
    end

    it "is not valid without a password" do
      user.password = nil
      expect(user).not_to be_valid
    end
  end
end
