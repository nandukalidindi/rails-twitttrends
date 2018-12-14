require "kafka"

kafka = Kafka.new(
  seed_brokers: ["localhost:9092"],
  client_id: "my-application"
)

kafka.deliver_message("Hello, World!", topic: "greetings")


require "kafka"

kafka = Kafka.new(
  seed_brokers: ["localhost:9092", "ec2-34-201-118-65.compute-1.amazonaws.com:9092"],
  client_id: "my-application"
)

kafka.deliver_message("Hello, World!", topic: "test")
