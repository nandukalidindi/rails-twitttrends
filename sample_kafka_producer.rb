require "kafka"

kafka = Kafka.new(
  seed_brokers: ["localhost:9092"],
  client_id: "my-application"
)

kafka.deliver_message("Hello, World!", topic: "greetings")
