# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

module Telegram
  module Commands
    # Команда /start
    #
    module Start
      def start!(visit_key = nil, *_args)
        respond_with :message, text: 'Поехали'
      end
    end
  end
end
