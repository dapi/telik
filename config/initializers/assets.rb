# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.2-' + ENV.fetch('CDN_HOST', '')

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w[button-widget.js]

NonDigestAssets.asset_selectors += %w[button-widget.js]

Rails.application.config.action_controller.asset_host =
  Rails.application.config.asset_host =
  ENV.fetch('ASSET_HOST', ENV.fetch('CDN_HOST', 'https://' + ApplicationConfig.host))
