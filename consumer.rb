require "kafka"
require "aws-sdk"
require "alchemy_api"
require "json"

AlchemyAPI.key = "95832f7a3c1ace795f69b37a83c2b1de3407f897"

kafka = Kafka.new(seed_brokers: ["localhost:9092", "ec2-54-147-153-202.compute-1.amazonaws.com:9092"])

Aws.config.update({region: 'us-west-2',credentials:
Aws::Credentials.new('<aws_access_key_id>', '<aws_secret_access_key>')})

c = Aws::SNS::Client.new(region: 'us-west-2')

kafka.each_message(topic: "tweets") do |message|
  message_json = JSON.parse(message.value)
  response = AlchemyAPI.search(:sentiment_analysis, text: message_json["text"])
  if message_json && response
    message_json["type"] = response["type"]
    message_json["score"] = response["score"]
    p  message_json
    resp = c.publish({
      topic_arn: "<TWEET ARN>",
      message: JSON.generate(message_json),
      subject: "Tweet",
      message_structure: "raw"
    })
  end
end
