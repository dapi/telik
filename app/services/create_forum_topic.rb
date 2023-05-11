# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Находит или создает топик операторской группе по пользователю
#
class CreateForumTopic < ApplicationService
  Error = Class.new StandardError

  def initialize(visitor)
    @visitor = visitor
  end

  def perform
    raise Error, "Visitor (#{@visitor.id}) has no telegram_id" if @visitor.telegram_id.nil?

    @visitor.with_lock do
      update_visitor! @visitor, create_forum_topic_in_telegram!(@visitor)
    end
  rescue Telegram::Bot::Error => e
    logger.error e
    case e.message
    when 'Bad Request: Bad Request: chat not found'
      # TODO: Похоже у бота нет доступа к группе, надо уведомить оператора
      # Telegram.bots[:operator].username
    when 'Bad Request: Bad Request: not enough rights to create a topic'
      # TODO
    else
      Rails.logger.warn e
      # TODO
    end
  end

  private

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

  def create_forum_topic_in_telegram!(visitor)
    topic = Telegram.bots[:operator].create_forum_topic(
      chat_id: visitor.project.telegram_group_id || raise("no telegram_group_id in project #{visitor.project.id}"),
      name: visitor.topic_title
      # icon_color: ,
      # icon_custom_emoji_id
    )
    #  {"ok"=>true, "result"=>{"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}

    raise topic.to_json unless topic.fetch('ok') == true

    topic.fetch('result')
  end
end
