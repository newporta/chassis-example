twilio_account_sid = ENV.fetch 'TWILIO_ACCOUNT_SID'
twilio_auth_token = ENV.fetch 'TWILIO_AUTH_TOKEN'
twilio_number = ENV.fetch 'TWILIO_NUMBER'

SmsService.backend = SmsService::Twilio.new twilio_account_sid, twilio_auth_token, twilio_number

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDISCLOUD_URL'), namespace: 'sidekiq' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDISCLOUD_URL'), namespace: 'sidekiq' }
end

connection_pool = ConnectionPool::Wrapper.new(size: ENV.fetch('PUMA_MAX_THREADS')) do
  Redis::Namepsace.new 'repo', Redis.new(url: ENV.fetch('REDISCLOUD_URL'))
end
Repo.backend = RedisAdapter.new connection_pool
