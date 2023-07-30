# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'test_helper'

class TelegramActionsMessageTest < ActiveSupport::TestCase
  setup do
    @object = Class.new
    @object.extend Telegram::Actions::Message
  end

  test 'client_message with sticket' do
    message = { 'message_id' => 61,
                'from' => { 'id' => 943_084_337, 'is_bot' => false, 'first_name' => 'Danil', 'last_name' => 'Pismenny', 'username' => 'pismenny', 'language_code' => 'en' },
                'chat' => { 'id' => 943_084_337, 'first_name' => 'Danil', 'last_name' => 'Pismenny', 'username' => 'pismenny', 'type' => 'private' },
                'date' => 1_690_742_590,
                'sticker' =>
      { 'width' => 512,
        'height' => 512,
        'emoji' => '😘',
        'set_name' => 'SweetyStrawberry',
        'is_animated' => true,
        'is_video' => false,
        'type' => 'regular',
        'thumbnail' => { 'file_id' => 'AAMCAgADGQEAAz1kxq8-nR67p0Hdare7U9p5AbBZEwACWAEAAhZCawr58l8Xq0rOmQEAB20AAy8E', 'file_unique_id' => 'AQADWAEAAhZCawpy', 'file_size' => 4508, 'width' => 128, 'height' => 128 },
        'thumb' => { 'file_id' => 'AAMCAgADGQEAAz1kxq8-nR67p0Hdare7U9p5AbBZEwACWAEAAhZCawr58l8Xq0rOmQEAB20AAy8E', 'file_unique_id' => 'AQADWAEAAhZCawpy', 'file_size' => 4508, 'width' => 128, 'height' => 128 },
        'file_id' => 'CAACAgIAAxkBAAM9ZMavPp0eu6dB3Wq3u1PaeQGwWRMAAlgBAAIWQmsK-fJfF6tKzpkvBA',
        'file_unique_id' => 'AgADWAEAAhZCawo',
        'file_size' => 21_072 } }
    assert message
  end

  test 'client_message with photo' do
    # Бывают сообщения без текста, например картинками:
    message = {
      update_id: 124_132_752,
      message: {
        message_id: 374,
        from: {
          id: 485_039_391,
          is_bot: false,
          first_name: 'Артём',
          username: 'Temas_95',
          language_code: 'ru'
        },
        chat: {
          id: 485_039_391,
          first_name: 'Артём',
          username: 'Temas_95',
          type: 'private'
        },
        date: 1_690_281_922,
        photo: [
          {
            file_id: 'AgACAgIAAxkBAAIBdmS_p8LgpkLBOtEc3pPwxgtwuw1qAAJJzDEbf4n4SWcIpD2MOKAyAQADAgADcwADLwQ',
            file_unique_id: 'AQADScwxG3-J-El4',
            file_size: 1176,
            width: 40,
            height: 90
          },
          {
            file_id: 'AgACAgIAAxkBAAIBdmS_p8LgpkLBOtEc3pPwxgtwuw1qAAJJzDEbf4n4SWcIpD2MOKAyAQADAgADbQADLwQ',
            file_unique_id: 'AQADScwxG3-J-Ely',
            file_size: 17_570,
            width: 144,
            height: 320
          },
          {
            file_id: 'AgACAgIAAxkBAAIBdmS_p8LgpkLBOtEc3pPwxgtwuw1qAAJJzDEbf4n4SWcIpD2MOKAyAQADAgADeAADLwQ',
            file_unique_id: 'AQADScwxG3-J-El9',
            file_size: 77_161,
            width: 360,
            height: 800
          },
          {
            file_id: 'AgACAgIAAxkBAAIBdmS_p8LgpkLBOtEc3pPwxgtwuw1qAAJJzDEbf4n4SWcIpD2MOKAyAQADAgADeQADLwQ',
            file_unique_id: 'AQADScwxG3-J-El-',
            file_size: 137_475,
            width: 576,
            height: 1280
          }
        ]
      }
    }

    # @object.send :client_message, message
    assert message
  end
end
