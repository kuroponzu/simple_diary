require 'rails_helper'

RSpec.describe Diary, type: :model do
  describe "associations" do
    it "belongs to user" do
      association = Diary.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe "validations" do
    let(:diary) { build(:diary) }

    it "is valid with valid attributes" do
      expect(diary).to be_valid
    end

    it "is not valid without a title" do
      diary.title = nil
      expect(diary).not_to be_valid
    end

    it "is not valid without content" do
      diary.content = nil
      expect(diary).not_to be_valid
    end

    it "is not valid without a user" do
      diary.user = nil
      expect(diary).not_to be_valid
    end
  end
end
