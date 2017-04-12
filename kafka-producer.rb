require "kafka"

kafka = Kafka.new(
  # At least one of these nodes must be available:
  seed_brokers: ["localhost:9092"],

  # Set an optional client id in order to identify the client to Kafka:
  client_id: "my-application",
)

kafka.deliver_message("Hello, World!", topic: "greetings")
