class SetPrimaryKeyInTelegramUsers < ActiveRecord::Migration[7.0]
  def change
    data = TelegramUser.pluck(:id, :first_name, :last_name, :username).select { |a| a.first > 0 }.uniq
    TelegramUser.delete_all
    data.each do |tg|
      id, first_name, last_name, username = tg
      TelegramUser.create! id: id, first_name: first_name, last_name: last_name, username: username
    end
    execute 'ALTER TABLE telegram_users ADD PRIMARY KEY (id);'
  end
end
