# Изменяет тему и иконки топика по пользователю
#
class UpdateForumTopicJob < CreateForumTopicJob
  queue_as :default

  def perform(visitor)
    raise Error, "Visitor (#{visitor.id}) has no telegram_id" if visitor.telegram_id.nil?
    raise Error, "Visitor (#{visitor.id}) has no defined message_thread_id" if visitor.telegram_message_thread_id.nil?

    safe_perform do
      update_visitor! visitor, update_forum_topic_in_telegram!(visitor)
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
    #  {"ok"=>true, "result"=>{"message_thread_id"=>11, "name"=>"94.232.57.6", "icon_color"=>7322096}}

    raise topic.to_json unless topic.fetch('ok') == true

    binding.pry
    topic.fetch('result')
  end
end
