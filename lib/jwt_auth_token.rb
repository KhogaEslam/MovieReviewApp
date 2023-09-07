module JwtAuthToken
  RAILS_SECRET_KEY = Rails.application.secrets.secret_key_base

  # Generate Unique encoded JWT token
  def self.generate_token(payload = {})
    payload[:iat] = DateTime.now.in_time_zone("UTC").to_i
    JWT.encode(payload, RAILS_SECRET_KEY)
  end

  # Decode jwt token and check its validity,
  # returned value e.g [{"user_id"=>1}, {"typ"=>"JWT", "alg"=>"HS256"}]
  def self.valid?(token)
    JWT.decode(token, RAILS_SECRET_KEY)
  rescue
    false
  end

end
