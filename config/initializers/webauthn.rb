# WebAuthn configuration
WebAuthn.configure do |config|
  # Allowed origins for WebAuthn operations
  config.allowed_origins = if Rails.env.production?
    [ "https://your-production-domain.com" ] # 本番環境のドメインに変更
  else
    [ "http://localhost:3000" ]
  end

  # Relying Party name for display
  config.rp_name = "Simple Diary"

  # Relying Party ID (domain)
  # 本番環境では実際のドメインに変更
  # config.rp_id = "your-domain.com"

  # Optional: Set timeout for credential creation and authentication
  # config.credential_options_timeout = 120_000

  # Optional: Set algorithms (default is ES256, PS256, RS256)
  # config.algorithms = ["ES256", "PS256", "RS256"]
end
