class TweetsController < ApplicationController
  include ActionController::Live
  respond_to :json

  skip_before_filter  :verify_authenticity_token

  def create
    Rails.logger.info(request.raw_post)
    sns_message = JSON.parse(JSON.parse(request.raw_post)["Message"] || "{}")
    tweet = Tweet.new
    tweet_text = sns_message["text"] || ""
    tweet.text = sns_message["text"]
    tweet.location = [sns_message["longitude"].to_f, sns_message["latitude"].to_f]
    keywords = tweet_text.split(" ")
    hashtags = keywords.select { |x| x[0] == '#' }.map { |y| y[1..-1] }
    tweet.keywords = keywords
    tweet.hashtags = hashtags
    tweet.sentiment_type = sns_message["type"]
    tweet.sentiment_value = sns_message["score"]
    tweet.save!

    respond_with tweet, location: nil
  end

  def index
    response.headers['Content-Type'] = 'text/event-stream'

    twitter_app = ConnectedApp.where(name: 'twitter').first

    @client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = "BgB9gfhMrjtSb3ZAy4Zen6u1b"
      config.consumer_secret     = "4vMkasCv3xhs0mRkfEjVePrCQfqoBpxCpgXcGWGTEcE9xywqNR"
      config.access_token        = twitter_app.token
      config.access_token_secret = twitter_app.token_secret
    end

    # filter_tweets
    response.stream.close
  end
end
