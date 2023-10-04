class SetupOpenbill < ActiveRecord::Migration[7.0]
  OPENBILL_DIR = Rails.root.join('vendor/openbill')
  MIGRATION_DIR = OPENBILL_DIR.join('migrations')
  def change
    Dir[ MIGRATION_DIR.join('V*.sql') ].
      select{|f| File.file? f }.
      sort.
      each do |file|
        say_with_time "Migrate with #{file}" do
          execute File.read file
        end
      end
    Dir[ MIGRATION_DIR.join('R*.sql') ].
      select{|f| File.file? f }.
      sort.
      each do |file|
        say_with_time "Migrate with #{file}" do
          execute File.read file
        end
      end

    add_column :openbill_accounts, :reference_type, :string
    add_column :openbill_accounts, :reference_id, :integer
  end
end
