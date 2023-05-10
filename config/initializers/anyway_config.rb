# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Anyway.loaders.delete :env if Rails.env.test?
