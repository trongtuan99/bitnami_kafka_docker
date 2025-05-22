# kafka_producer.rb
require 'kafka'
require 'connection_pool'

KAFKA_URL = ENV.fetch('KAFKA_URL', 'localhost:9092')
KAFKA = Kafka.new(KAFKA_URL, client_id: ENV.fetch('APP_NAME', 'my_app').downcase).freeze
PRODUCER_POOL = ConnectionPool.new(size: ENV.fetch('KAFKA_PRODUCER_POOL_SIZE', 10).to_i, timeout: ENV.fetch('KAFKA_PRODUCER_POOL_TIMEOUT', 5).to_i) {
KAFKA.producer(idempotent: true)
}

message = "Hello, Kafka!"
key = "my_key"
topic = "my_topic"
partition_key = "my_partition_key"

PRODUCER_POOL.with do |producer|
  producer.produce(message, key: key, topic: topic, partition_key: partition_key)
  producer.deliver_messages
end