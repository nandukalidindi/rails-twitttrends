class AddFieldsToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :text, :string
    add_column :tweets, :latitude, :string
    add_column :tweets, :longitude, :string
  end
end
