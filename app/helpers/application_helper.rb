# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module ApplicationHelper
  DIGEST_REGEXP = /(-{1}[a-z0-9]{32}*\.{1}){1}/
  def remove_asset_digest(path)
    path.sub(DIGEST_REGEXP, '.')
  end

  def link_to_bot(username)
    link_to '@' + username, ApplicationConfig::TELEGRAM_LINK_PREFIX + username, target: '_blank', rel: 'noopener'
  end

  def sort_column(column, title)
    return column unless defined? q

    sort_link q, column, title
  end

  def full_error_messages(form)
    return if form.object.errors.empty?

    content_tag :div, class: 'alert alert-danger' do
      form.object.errors.full_messages.to_sentence
    end
  end

  def hiden_columns
    []
  end

  def app_title
    '🛎 ' + ApplicationConfig.app_title
  end

  def back_link(url = nil)
    link_to "&larr; #{t('helpers.back')}".html_safe, url || root_path
  end

  def title_with_counter(title, count, hide_zero: true, css_class: nil)
    buffer = ''
    buffer += title

    buffer += ' '
    text = hide_zero && count.to_i.zero? ? '' : count.to_s
    buffer += content_tag(:span, "(#{text})", class: css_class, data: { title_counter: true, count: count.to_i }) if count.positive?

    buffer.html_safe
  end

  def controller_namespace
    return nil if controller.class.name.split('::').one?

    controller.class.name.split('::').first.underscore.to_sym
  end
end
