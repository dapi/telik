# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

# Rails.application.configure do
# config.content_security_policy do |policy|
# policy.default_src :self, :https, :unsafe_inline, 'oauth.telegram.org'
# policy.font_src    :self, :https, :data
# policy.img_src     :self, :https, :data
# policy.object_src  :none
# policy.script_src  :self, :https, :unsafe_inline, 'oauth.telegram.org'
## policy.script_src :self, :unsafe_inline, '*.google-analytics.com', 'player.vimeo.com', '*.cloudflare.com'
## https://oauth.telegram.org/embed/telik_dev_operator_bot?origin=http%3A%2F%2F127.0.0.1%3A3000&return_to=http%3A%2F%2F127.0.0.1%3A3000%2F&size=large&request_access=write
# policy.style_src   :self, :https, :unsafe_inline, 'oauth.telegram.org'
## policy.frame_src   :self, :https, :unsafe_inline, 'oauth.telegram.org'
# policy.frame_src   :self, :unsafe_inline, 'oauth.telegram.org'
# policy.frame_ancestors :self, '*.telegram.org', 'http://nuichat.local', 'nuichat.local', 'https://oauth.telegram.org/'
## Specify URI for violation reports
# policy.report_uri '/csp-violation-report-endpoint'
# end

## Generate session nonces for permitted importmap and inline scripts
# config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
# config.content_security_policy_nonce_directives = %w[script-src]

## Report violations without enforcing the policy.
## config.content_security_policy_report_only = true
# end

Rails.application.config.content_security_policy_report_only = true
