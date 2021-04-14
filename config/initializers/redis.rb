$redis = Redis.new

url = ENV["REDISCLOUD_URL"]

if url
  Sidekiq.configure_server do |config|
    config.redis = { url: url, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: url, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
  end
  $redis = Redis.new(url: url, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE })
end
