# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Изменяет тему и иконки топика по пользователю
#
class UpdateForumTopicJob < CreateForumTopicJob
  queue_as :default

  def self.update_all
    Visitor.where.not(telegram_message_thread_id: nil).find_each do |v|
      UpdateForumTopicJob.perform_later v
    end
  end

  def perform(visitor)
    raise Error, "Visitor (#{visitor.id}) has no telegram_user_id" if visitor.telegram_user_id.nil?
    raise Error, "Visitor (#{visitor.id}) has no defined message_thread_id" if visitor.telegram_message_thread_id.nil?

    safe_perform visitor.project do
      edit_forum_topic(visitor)
    end
  end

  private

  def edit_forum_topic(visitor)
    topic = visitor.project.bot.edit_forum_topic(
      message_thread_id: visitor.telegram_message_thread_id,
      chat_id: visitor.project.telegram_group_id || raise("no telegram_group_id in project #{visitor.project.id}"),
      name: build_topic_title(visitor, visitor.last_visit)
    )
    # {"ok"=>true, "result"=>true}

    raise topic.to_json unless topic.fetch('ok') == true
  end
end
