class TweetsController < ApplicationController
  include ActionController::Live
  respond_to :json

  skip_before_filter  :verify_authenticity_token

  def create
    Rails.logger.info "PARAMS ARE -->>> #{params}"
    respond_with Tweet.first, location: nil
  end

  def index
    response.headers['Content-Type'] = 'text/event-stream'

    twitter_app = ConnectedApp.where(name: 'twitter').first
    binding.pry

    @client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = "BgB9gfhMrjtSb3ZAy4Zen6u1b"
      config.consumer_secret     = "4vMkasCv3xhs0mRkfEjVePrCQfqoBpxCpgXcGWGTEcE9xywqNR"
      config.access_token        = twitter_app.token
      config.access_token_secret = twitter_app.token_secret
    end

    # filter_tweets
    response.stream.close
  end

  def filter_tweets
    @client.filter(locations: "-180, -90, 180, 90") do |object|
      if object.is_a?(Twitter::Tweet)
        unless object.geo.nil?
          location = [object.geo.longitude, object.geo.latitude]
          keywords = object.text.split(" ")
          hashtags = keywords.select { |x| x[0] == '#' }.map { |y| y[1..-1] }
          Tweet.create(text: object.text, location: location, keywords: keywords, hashtags: hashtags)
          response.stream.write "Tweeted #{object.text} at location #{location}. COUNT: #{Tweet.all.count}\n\n"
          sleep 0.5
        end
      end
    end
  rescue EOFError => e
    response.stream.write "RETRYING FOR CONNECTION. PLEASE WAIT ...\n\n\n\n\n\n"
    sleep 2
    retry
  end

end
