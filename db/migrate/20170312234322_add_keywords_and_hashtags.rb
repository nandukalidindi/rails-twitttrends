class AddKeywordsAndHashtags < ActiveRecord::Migration
  def change
    add_column :tweets, :keywords, :string, array: true, default: []
    add_column :tweets, :hashtags, :string, array: true, default: []
  end
end
