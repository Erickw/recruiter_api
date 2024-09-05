module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def valid_headers
    {
      "Authorization" => token_generator(recruiter.id),
      "Content-Type" => "application/json"
    }
  end

  def invalid_token
    {
      "Authorization" => ENV['INVALID_TOKEN'],
      "Content-Type" => "application/json"
    }
  end

  def expired_token
    {
      "Authorization" => ENV['EXPIRED_TOKEN'],
      "Content-Type" => "application/json"
    }
  end

  def token_generator(recruiter_id)
    expire_hours = ENV['JWT_EXPIRE_HOURS'].to_i
    expire_time = expire_hours.hours.from_now.to_i
    exp_payload = { data: { recruiter_id: recruiter_id }, exp: expire_time }

    JWT.encode exp_payload, ENV['SECRET_KEY_BASE']
  end
end
