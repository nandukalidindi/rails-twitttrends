class AddSentimentTypeValueToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :sentiment_type, :string
    add_column :tweets, :sentiment_value, :float
  end
end
