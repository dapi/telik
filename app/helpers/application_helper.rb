# frozen_string_literal: true

module ApplicationHelper
  def telegram_link
    link_to '#' do
      image_tag 'telegram_logo.png', class: 'img-responsive', width: 50, height: 50, style: 'position:fixed;bottom:0;margin:1em;background:none;z-index:9999', skip_pipeline: true
    end
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
    t 'application.app_title'
  end

  def back_link(url = nil)
    link_to "&larr; #{t('helpers.back')}".html_safe, url || root_path
  end

  def title_with_counter(title, count, hide_zero: true, css_class: nil)
    buffer = ''
    buffer += title

    buffer += ' '
    text = hide_zero && count.to_i.zero? ? '' : count.to_s
    if count.positive?
      buffer += content_tag(:span, "(#{text})", class: css_class, data: { title_counter: true, count: count.to_i })
    end

    buffer.html_safe
  end

  def controller_namespace
    nil if controller.class.name.split('::').one?
    controller.class.name.split('::').first.underscore.to_sym
  end
end
