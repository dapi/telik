class SetPrimaryKeyInTelegramUsers < ActiveRecord::Migration[7.0]
  def change
    execute 'ALTER TABLE telegram_users ADD PRIMARY KEY (id);'
  end
end
