# frozen_string_literal: true

# Находит или создает топик для посетителя
# и пишет туда оператору о визите
#
class FindOrCreateTopic < ApplicationService
  def initialize(visit)
    @visit = visit
    super
  end

  def perform
    find_or_create_topic!(@visit)
  end

  private

  def find_or_create_topic!(visit)
    return if visit.visitor.telegram_group_id.present?

    topic = create_topic! visit.visitor

    visit.visitor.update!(
      telegram_message_thread_id: topic.fetch('message_thread_id'),
      cached_telegram_topic_name: topic.fetch('name'),
      cached_telegram_topic_icon_color: topic.fetch('icon_color'),
      telegram_cached_at: Time.zone.now
    )
  end

  def create_topic!(visitor)
    topic = Telegram.bots[:operator].create_forum_topic(
      chat_id: visitor.project.telegram_group_id,
      name: visitor.topic_title
      # icon_color: ,
      # icon_custom_emoji_id
    )
    #  {"ok"=>true, "result"=>{"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}

    raise topic.to_json unless topic.fetch('ok') == true

    topic.fetch('result')
  end
end
