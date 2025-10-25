require 'rails_helper'

RSpec.describe "Diaries", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:diary) { create(:diary, user: user) }
  let(:other_diary) { create(:diary, user: other_user) }

  describe "Authentication" do
    it "requires authentication for index" do
      get diaries_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "requires authentication for show" do
      get diary_path(diary)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "requires authentication for new" do
      get new_diary_path
      expect(response).to redirect_to(new_user_session_path)
    end

    it "requires authentication for create" do
      post diaries_path, params: { diary: { title: "Test", content: "Test" } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "requires authentication for edit" do
      get edit_diary_path(diary)
      expect(response).to redirect_to(new_user_session_path)
    end

    it "requires authentication for update" do
      patch diary_path(diary), params: { diary: { title: "Updated" } }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "requires authentication for destroy" do
      delete diary_path(diary)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "Authorization" do
    before { sign_in user }

    it "allows access to own diary" do
      get diary_path(diary)
      expect(response).to have_http_status(:success)
    end

    it "denies access to other user's diary" do
      get diary_path(other_diary)
      expect(response).to redirect_to(diaries_path)
      expect(flash[:alert]).to eq("You are not authorized to access this diary.")
    end

    it "denies editing other user's diary" do
      get edit_diary_path(other_diary)
      expect(response).to redirect_to(diaries_path)
    end

    it "denies updating other user's diary" do
      patch diary_path(other_diary), params: { diary: { title: "Hacked" } }
      expect(response).to redirect_to(diaries_path)
    end

    it "denies deleting other user's diary" do
      delete diary_path(other_diary)
      expect(response).to redirect_to(diaries_path)
    end
  end

  describe "GET /diaries" do
    before do
      sign_in user
      create_list(:diary, 3, user: user)
      create_list(:diary, 2, user: other_user)
    end

    it "returns http success" do
      get diaries_path
      expect(response).to have_http_status(:success)
    end

    it "displays only current user's diaries" do
      get diaries_path
      expect(response.body).to include(user.diaries.first.title)
      expect(response.body).not_to include(other_user.diaries.first.title)
    end
  end

  describe "GET /diaries/:id" do
    before { sign_in user }

    it "returns http success" do
      get diary_path(diary)
      expect(response).to have_http_status(:success)
    end

    it "displays the diary" do
      get diary_path(diary)
      expect(response.body).to include(diary.title)
      expect(response.body).to include("<strong>sample</strong>")
    end
  end

  describe "GET /diaries/new" do
    before { sign_in user }

    it "returns http success" do
      get new_diary_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /diaries" do
    before { sign_in user }

    context "with valid parameters" do
      it "creates a new diary" do
        expect {
          post diaries_path, params: { diary: { title: "New Diary", content: "Content" } }
        }.to change(Diary, :count).by(1)
      end

      it "redirects to the created diary" do
        post diaries_path, params: { diary: { title: "New Diary", content: "Content" } }
        expect(response).to redirect_to(diary_path(Diary.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new diary" do
        expect {
          post diaries_path, params: { diary: { title: "", content: "" } }
        }.not_to change(Diary, :count)
      end

      it "renders the new template" do
        post diaries_path, params: { diary: { title: "", content: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /diaries/:id/edit" do
    before { sign_in user }

    it "returns http success" do
      get edit_diary_path(diary)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /diaries/:id" do
    before { sign_in user }

    context "with valid parameters" do
      it "updates the diary" do
        patch diary_path(diary), params: { diary: { title: "Updated Title" } }
        diary.reload
        expect(diary.title).to eq("Updated Title")
      end

      it "redirects to the diary" do
        patch diary_path(diary), params: { diary: { title: "Updated Title" } }
        expect(response).to redirect_to(diary_path(diary))
      end
    end

    context "with invalid parameters" do
      it "does not update the diary" do
        original_title = diary.title
        patch diary_path(diary), params: { diary: { title: "" } }
        diary.reload
        expect(diary.title).to eq(original_title)
      end

      it "renders the edit template" do
        patch diary_path(diary), params: { diary: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /diaries/:id" do
    before { sign_in user }

    it "destroys the diary" do
      diary_to_delete = create(:diary, user: user)
      expect {
        delete diary_path(diary_to_delete)
      }.to change(Diary, :count).by(-1)
    end

    it "redirects to diaries list" do
      delete diary_path(diary)
      expect(response).to redirect_to(diaries_path)
    end
  end
end
