# frozen_string_literal: true

DeviseTokenAuth.setup do |config|
  config.require_client_password_reset_token = true

  config.change_headers_on_each_request = true

  config.token_lifespan = 1.week

  config.token_cost = Rails.env.test? ? 4 : 10

  config.batch_request_buffer_throttle = 5.seconds
end
