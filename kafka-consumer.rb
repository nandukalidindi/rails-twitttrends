require "kafka"

kafka = Kafka.new(seed_brokers: ["localhost:9092"])

kafka.each_message(topic: "greetings") do |message|
  puts message.offset, message.key, message.value
end
