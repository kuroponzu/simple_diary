class WebauthnSessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /webauthn_session/new
  def new
    # ログインチャレンジを生成
    options = WebAuthn::Credential.options_for_get

    session[:authentication_challenge] = options.challenge

    respond_to do |format|
      format.html
      format.json { render json: options }
    end
  end

  # POST /webauthn_session
  def create
    webauthn_credential = WebAuthn::Credential.from_get(params)

    # 認証情報を検索
    credential = Credential.find_by(external_id: Base64.strict_encode64(webauthn_credential.raw_id))

    if credential.nil?
      render json: { success: false, error: "Credential not found" }, status: :unauthorized
      return
    end

    begin
      webauthn_credential.verify(
        session[:authentication_challenge],
        public_key: credential.public_key,
        sign_count: credential.sign_count
      )

      # サインカウントを更新（リプレイ攻撃防止）
      credential.update!(sign_count: webauthn_credential.sign_count)

      # ユーザーをログイン
      sign_in(credential.user)
      session.delete(:authentication_challenge)

      render json: { success: true, redirect_url: diaries_path }
    rescue WebAuthn::SignCountVerificationError => e
      # サインカウントの不整合（セキュリティ上の問題）
      render json: { success: false, error: "Credential appears to be cloned" }, status: :unauthorized
    rescue WebAuthn::Error => e
      render json: { success: false, error: e.message }, status: :unauthorized
    end
  end
end
