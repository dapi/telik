# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Обработка события my_chat_member
#
module Telegram::Actions::MyChatMember
  # Удалили чат и бота выкинуло из чата
  # {"chat"=>{"id"=>-1001828619257, "title"=>"Tesy3", "is_forum"=>true, "type"=>"supergroup"},
  # "from"=>{"id"=>1087968824, "is_bot"=>true, "first_name"=>"Group", "username"=>"GroupAnonymousBot"},
  # "date"=>1692964419,
  # "old_chat_member"=>
  # {"user"=>{"id"=>6177763867, "is_bot"=>true, "first_name"=>"LocalNuiChatBot", "username"=>"LocalNuiChatBot"},
  # "status"=>"administrator",
  # "can_be_edited"=>false,
  # "can_manage_chat"=>true,
  # "can_change_info"=>true,
  # "can_delete_messages"=>true,
  # "can_invite_users"=>true,
  # "can_restrict_members"=>true,
  # "can_pin_messages"=>true,
  # "can_manage_topics"=>true,
  # "can_promote_members"=>false,
  # "can_manage_video_chats"=>true,
  # "is_anonymous"=>false,
  # "can_manage_voice_chats"=>true},
  # "new_chat_member"=>{"user"=>{"id"=>6177763867, "is_bot"=>true, "first_name"=>"LocalNuiChatBot", "username"=>"LocalNuiChatBot"}, "status"=>"left"}}

  def my_chat_member(data)
    # Кого-то другого добавили, не нас
    # TODO Может лучше проверять по ID?
    # TODO По какому боту проект нашли, с таким проектом дальше и работать
    users_ids = [data.dig('new_chat_member', 'user', 'id'), data.dig('old_chat_member', 'user', 'id')].compact

    if users_ids.include? ApplicationConfig.bot_id
      perform_my_chat_member(data)
      # Отлично, пропускаем
    elsif (project = Project.with_bots.find_by_bot_id(current_bot_id))
      perform_my_chat_member(data, project)
    else
      Bugsnag.notify 'my_chat_member от неизвестного бота' do |b|
        b.metadata = { payload:, current_bot_id: }
      end
    end
  end

  private

  def perform_my_chat_member(data, project = nil)
    user = User.find_or_create_by_telegram_data!(from)

    chat_member = data.fetch('new_chat_member')

    if %w[kicked left].include? data.dig('new_chat_member', 'status')
      chat_project&.update_bot_member!(chat_member:, chat:)
    elsif chat.fetch('type') == 'supergroup'
      attrs = {
        chat_member_updated_at: Time.zone.now,
        chat_member:,
        telegram_group_name: chat.fetch('title'),
        name: chat.fetch('title'),
        tariff: Tariff.free!
      }
      project ||= Project
        .create_with(attrs.merge(owner: user))
        .create_or_find_by!(telegram_group_id: chat.fetch('id'))

      project.assign_attributes attrs.merge(telegram_group_id: chat.fetch('id'))
      project.save! if project.changed?

      update_project_bot_member!(project:, chat_member:, user:)
    else
      respond_with :message,
                   text: "Привет!\nГруппа уже есть, мы на пол пути!\nДалее включите в группе 'Темы', чтобы я мог заводить отдельную тему для каждого обращения клиента."
    end
  end
end
