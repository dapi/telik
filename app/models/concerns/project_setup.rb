# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Коллекция методов по настройке проекта
#
module ProjectSetup
  LEFT_STATUSES = %w[left kicked]
  WIDGET_ERRORS = %i[host_not_confirmed]

  def setup_errors
    @setup_errors ||= build_setup_errors
  end

  def bot_setup_errors
    setup_errors - WIDGET_ERRORS
  end

  def bot_installed?
    telegram_supergroup? && bot_admin? && bot_can_manage_topics?

    # Альтерантивный вариант:
    # (setup_errors - [:host_not_confirmed]).empty?
  end

  def bot_added?
    bot_status.present? && !LEFT_STATUSES.include?(bot_status)
  end

  def widget_installed?
    host_confirmed?
  end

  def telegram_supergroup?
    telegram_group_id.present? && telegram_group_type == 'supergroup' && telegram_group_is_forum
  end

  def bot_admin?
    bot_status == 'administrator'
  end

  private

  def build_setup_errors
    setup_errors = []
    setup_errors << :host_not_confirmed unless host_confirmed?
    setup_errors << :no_telegram_group unless telegram_group_id?
    setup_errors << :not_supergroup unless telegram_supergroup?
    setup_errors << :not_admin unless bot_admin?
    setup_errors << :admin_cant_manage_topics unless bot_can_manage_topics?
    setup_errors
  end
end