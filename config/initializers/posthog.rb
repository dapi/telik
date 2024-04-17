$posthog = PostHog::Client.new({
  api_key: ENV.fetch('POSTHOG_API_KEY'),
    host: "https://eu.posthog.com",
    on_error: Proc.new { |status, msg| print msg }
}) if ENV.key? 'POSTHOG_API_KEY'
