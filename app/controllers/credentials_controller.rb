class CredentialsController < ApplicationController
  before_action :authenticate_user!

  # GET /credentials
  def index
    @credentials = current_user.credentials
  end

  # GET /credentials/new
  def new
    # チャレンジを生成してセッションに保存
    options = WebAuthn::Credential.options_for_create(
      user: {
        id: WebAuthn.generate_user_id,
        name: current_user.email,
        display_name: current_user.email
      },
      exclude: current_user.credentials.map { |c| c.external_id }
    )

    session[:creation_challenge] = options.challenge

    respond_to do |format|
      format.json { render json: options }
    end
  end

  # POST /credentials
  def create
    webauthn_credential = WebAuthn::Credential.from_create(params)

    begin
      webauthn_credential.verify(session[:creation_challenge])

      # 認証情報を保存
      credential = current_user.credentials.build(
        nickname: params[:nickname] || "Passkey #{current_user.credentials.count + 1}",
        external_id: Base64.strict_encode64(webauthn_credential.raw_id),
        public_key: webauthn_credential.public_key,
        sign_count: webauthn_credential.sign_count
      )

      if credential.save
        session.delete(:creation_challenge)
        render json: { success: true, message: "Passkey registered successfully" }
      else
        render json: { success: false, errors: credential.errors.full_messages }, status: :unprocessable_entity
      end
    rescue WebAuthn::Error => e
      render json: { success: false, error: e.message }, status: :unprocessable_entity
    end
  end

  # DELETE /credentials/:id
  def destroy
    credential = current_user.credentials.find(params[:id])
    credential.destroy
    redirect_to credentials_path, notice: "Passkey was successfully removed."
  end
end
