require "kafka"
require "twitter"
require "json"

@kafka = Kafka.new(
  seed_brokers: ["localhost:9092", "ec2-54-147-153-202.compute-1.amazonaws.com:9092"],
  client_id: "my-application"
)

@client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = "<CONSUMER KEY>"
  config.consumer_secret     = "<CONSUMER SECRET>"
  config.access_token        = "<ACCESS TOKEN>"
  config.access_token_secret = "<ACCESS TOKEN SECRET>"
end

def filter_tweets
  @client.filter(locations: "-180, -90, 180, 90", lang: "ja") do |object|
    if object.is_a?(Twitter::Tweet)
      unless object.geo.nil?
        location = [object.geo.longitude, object.geo.latitude]
        object_json = {text: object.text, latitude: object.geo.latitude, longitude: object.geo.longitude}
        p object_json
        @kafka.deliver_message(JSON.generate(object_json), topic: "tweets")
      end
    end
  end
rescue EOFError => e
  response.stream.write "RETRYING FOR CONNECTION. PLEASE WAIT ...\n\n\n\n\n\n"
  sleep 2
  retry
end

filter_tweets
