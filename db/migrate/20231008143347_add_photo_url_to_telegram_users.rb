class AddPhotoUrlToTelegramUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :telegram_users, :photo_url, :string
  end
end
