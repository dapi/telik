class AddWelcomeMessageToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :welcome_message, :string
  end
end
