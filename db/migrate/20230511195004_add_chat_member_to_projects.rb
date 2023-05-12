class AddChatMemberToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :chat_member, :jsonb
    add_column :projects, :chat_member_updated_at, :timestamp
  end
end
