
# Находит или создает топик для посетителя
# и пишет туда оператору о визите
#
class FindOrCreateTopic < ApplicationCommand
  def initialize(visit)
    @visit = visit
  end

  def perform
    find_or_create_topic!(@visit)
  end

  private

  def find_or_create_topic!(visit)
    unless visit.visitor.telegram_group_id.present?
      topic = create_topic! visit

      visit.visitor.update!(
        telegram_message_thread_id: topic.fetch('message_thread_id'),
        cached_telegram_topic_name: topic.fetch('name'),
        cached_telegram_topic_icon_color: topic.fetch('icon_color'),
        telegram_cached_at: Time.zone.now
      )
    end

  end

  def create_topic!(visit)
    topic = Telegram.bots[:operator].create_forum_topic(
      chat_id: @visit.project.telegram_group_id,
      name: @visit.topic_title,
      # icon_color: ,
      # icon_custom_emoji_id
    )
    #  {"ok"=>true, "result"=>{"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}

    raise topic.to_json unless topic.fetch('ok') == true

    return topic.fetch('result')
  end
end
