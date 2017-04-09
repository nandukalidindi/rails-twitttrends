require 'twitter'

@client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = "BgB9gfhMrjtSb3ZAy4Zen6u1b"
  config.consumer_secret     = "4vMkasCv3xhs0mRkfEjVePrCQfqoBpxCpgXcGWGTEcE9xywqNR"
  config.access_token        = "836117688741150720-mrNEVa2MjAhtxxW1mmEmoY2fQ4tVYRV"
  config.access_token_secret = "Cm58qJiV1TvyCZoGVDnnEU0MO49NehBBn81B7krf41AzW"
end

def filter_tweets
  @client.filter(locations: "-180, -90, 180, 90") do |object|
    if object.is_a?(Twitter::Tweet)
      unless object.geo.nil?
        location = [object.geo.longitude, object.geo.latitude]
        keywords = object.text.split(" ")
        hashtags = keywords.select { |x| x[0] == '#' }.map { |y| y[1..-1] }
        p "TEXT: #{object.text} -- LOCATION: #{location} -- KEYWORDS: #{keywords} -- HASHTAGS: #{hashtags}"
      end
    end
  end
rescue EOFError => e
  response.stream.write "RETRYING FOR CONNECTION. PLEASE WAIT ...\n\n\n\n\n\n"
  sleep 2
  retry
end

filter_tweets
