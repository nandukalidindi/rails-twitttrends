class AddConnectedAppsTable < ActiveRecord::Migration
  def change
    create_table :connected_apps do |t|
      t.string :name
      t.string :token
      t.string :token_secret

      t.timestamps null: false
    end
  end
end
