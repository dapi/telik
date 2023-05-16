# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Находит или создает топик операторской группе по пользователю
#
class CreateForumTopicJob < ApplicationJob
  queue_as :default

  Error = Class.new StandardError

  def perform(visitor, visit = nil)
    raise Error, "Visitor (#{visitor.id}) has no telegram_user_id" if visitor.telegram_user_id.nil?

    safe_perform visitor.project.owner.telegram_user_id do
      visitor.with_lock do
        update_visitor! visitor, create_forum_topic_in_telegram!(visitor, build_topic_title(visitor, visit))
      end
    end
    TopicMessageJob.perform_later visitor, "Контакт с #{visit.referrer}" if visit.present? && visitor.telegram_message_thread_id.present?
  end

  private

  def safe_perform(owner_telegram_user_id)
    yield
  rescue Telegram::Bot::Error => e
    Bugsnag.notify e
    Rails.logger.error e
    case e.message
    when 'Bad Request: Bad Request: chat not found'
      OperatorMessageJob.perform_later(owner_telegram_user_id, 'У меня нет доступа к группе')
    when 'Bad Request: Bad Request: not enough rights to create a topic'
      OperatorMessageJob.perform_later(owner_telegram_user_id, 'У меня нет прав создавать топики')
    when 'Bad Request: Bad Request: TOPIC_NOT_MODIFIED'
      # Do nothing
    else
      Rails.logger.warn e
      Bugsnag.notify e do |b|
        b.meta_data = { visitor: visitor.as_json }
      end
      OperatorMessageJob.perform_later(owner_telegram_user_id, e.message)
    end
  end

  def build_topic_title(visitor, visit = nil)
    visit ||= visitor.last_visit

    # TODO: Добавлять опционально @#{username}
    ["##{visitor.id} #{visitor.name}", visit.try(:from)].join(' ')
  end

  # @param topic {"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}
  #
  def update_visitor!(visitor, topic)
    visitor.update!(
      telegram_message_thread_id: topic.fetch('message_thread_id'),
      telegram_cached_at: Time.zone.now,
      topic_data: topic
      # {"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}
    )
  end

  def create_forum_topic_in_telegram!(visitor, topic_title)
    topic = Telegram.bot.create_forum_topic(
      chat_id: visitor.project.telegram_group_id || raise("no telegram_group_id in project #{visitor.project.id}"),
      name: topic_title
      # icon_color: ,
      # icon_custom_emoji_id
    )
    #  {"ok"=>true, "result"=>{"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}

    raise topic.to_json unless topic.fetch('ok') == true

    topic.fetch('result')
  end
end
