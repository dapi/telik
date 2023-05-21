# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Telegram
  module Commands
    # Команда /who
    #
    module Who
      def who!(*_args)
        if direct_client_message?
          # Пропускаем
        elsif topic_message?
          tell_about_visitor
        else
          Bugsnag.notify 'Не понятно откуда команда' do |b|
            b.meta_data = { payload: }
          end
        end
      end

      private

      #  payload
      # {"message_id"=>44,
      # "from"=>{"id"=>943084337, "is_bot"=>false, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "language_code"=>"en"},
      # "chat"=>{"id"=>-1001896739063, "title"=>"Группа nuichat.localhost", "is_forum"=>true, "type"=>"supergroup"},
      # "date"=>1684649530,
      # "message_thread_id"=>34,
      # "reply_to_message"=>
      # {"message_id"=>34,
      # "from"=>{"id"=>6177763867, "is_bot"=>true, "first_name"=>"LocalNuiChatBot", "username"=>"LocalNuiChatBot"},
      # "chat"=>{"id"=>-1001896739063, "title"=>"Группа nuichat.localhost", "is_forum"=>true, "type"=>"supergroup"},
      # "date"=>1684245454,
      # "message_thread_id"=>34,
      # "forum_topic_created"=>{"name"=>"#53 Danil Pismenny (/)", "icon_color"=>7322096},
      # "is_topic_message"=>true},
      # "text"=>"/who",
      # "entities"=>[{"offset"=>0, "length"=>4, "type"=>"bot_command"}],
      # "is_topic_message"=>true}

      # Говорит в треде о пользователе с которым общаемся
      #
      def tell_about_visitor
        if topic_visitor.present?
          presenter = VisitorPresenter.new(topic_visitor)
          visitor_fields = %i[username name created_at user_data last_visit_at first_visit_brief]
          visitor_fields << :last_visit_brief unless presenter.last_visit_brief == presenter.first_visit_brief

          text = visitor_fields.map do |field|
            value = presenter.send(field)
            [field, value].join(' ') if value.present?
          end

          reply_with :message, text: text.compact.join("\n")
        else
          reply_with :message, text: ':( Не найден посетитель по этому топику'
        end
      end

      def about_user
        { telegram_user:, visitor: }.inspect
      end
    end
  end
end
