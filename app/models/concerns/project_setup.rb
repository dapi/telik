# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Коллекция методов по настройке проекта
#
module ProjectSetup
  def setup_errors
    @setup_errors ||= build_setup_errors
  end

  def bot_installed?
    (setup_errors - [:host_not_confirmed]).empty?
  end

  def widget_installed?
    host_confirmed?
  end

  private

  def build_setup_errors
    setup_errors = []
    setup_errors << :host_not_confirmed unless host_confirmed?
    if telegram_group_id.blank?
      setup_errors << :no_telegram_group
    else
      setup_errors << :not_supergroup unless telegram_group_type == 'supergroup' && telegram_group_is_forum

      if bot_status == 'administrator'
        setup_errors << :admin_cant_manage_topics unless bot_can_manage_topics?
      else
        setup_errors << :not_admin
      end
      setup_errors
    end
  end
end
