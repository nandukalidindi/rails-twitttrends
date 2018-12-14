require "kafka"

kafka = Kafka.new(seed_brokers: ["localhost:9092"])

kafka.each_message(topic: "greetings") do |message|
  puts message.offset, message.key, message.value
end

require "kafka"

kafka = Kafka.new(seed_brokers: ["localhost:9092", "ec2-34-201-118-65.compute-1.amazonaws.com:9092"])

kafka.each_message(topic: "test") do |message|
  puts message.offset, message.key, message.value
end
