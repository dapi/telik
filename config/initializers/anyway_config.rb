# frozen_string_literal: true

Anyway.loaders.delete :env if Rails.env.test?
