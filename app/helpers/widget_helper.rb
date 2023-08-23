# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module WidgetHelper
  def widget_namespace
    ApplicationConfig.app_title.downcase
  end

  def widget_window_object
    widget_namespace.camelize + 'Widget'
  end
end
