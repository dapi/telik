# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Изменяет тему и иконки топика по пользователю
#
class UpdateForumTopicJob < CreateForumTopicJob
  queue_as :default

  def perform(visitor)
    raise Error, "Visitor (#{visitor.id}) has no telegram_id" if visitor.telegram_id.nil?
    raise Error, "Visitor (#{visitor.id}) has no defined message_thread_id" if visitor.telegram_message_thread_id.nil?

    safe_perform do
      update_forum_topic_in_telegram!(visitor)
    end
  end

  private

  def update_forum_topic_in_telegram!(visitor)
    topic = Telegram.bots[:operator].edit_forum_topic(
      message_thread_id: visitor.telegram_message_thread_id,
      chat_id: visitor.project.telegram_group_id || raise("no telegram_group_id in project #{visitor.project.id}"),
      name: visitor.topic_title
      # icon_color: ,
      # icon_custom_emoji_id
    )
    # {"ok"=>true, "result"=>true}

    raise topic.to_json unless topic.fetch('ok') == true

    { 'name' => visitor.topic_title }
  end
end
