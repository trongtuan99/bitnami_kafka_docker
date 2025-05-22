require 'kafka'
require 'json'
require 'ostruct'

class Consumer
  def initialize(group_id:)
    @group_name = get_topic_name(group_id, ENV.fetch('APP_NAME', 'my-app').downcase).dasherize

    @consumer = kafka_consumer.consumer(
      group_id:                @group_name,
      offset_commit_threshold: ENV.fetch('OFFSET_COMMIT_THRESHOLD', 10).to_i,
      session_timeout:         ENV.fetch('SESSION_TIMEOUT', 30).to_i,
      offset_commit_interval:  ENV.fetch('OFFSET_COMMIT_INTERVAL', 10).to_i,
      heartbeat_interval:      ENV.fetch('HEARTBEAT_INTERVAL', 10).to_i,
      offset_retention_time:   ENV['OFFSET_RETENTION_TIME']&.to_i,
      fetcher_max_queue_size:  ENV.fetch('FETCHER_MAX_QUEUE_SIZE', 100).to_i
    )
  end

  def start(topic_name)
    @consumer.subscribe(topic_name)

    @consumer.each_message(max_wait_time: 0.5) do |message|
      handle_event(message)
    end
  rescue => e
    puts "[Consumer] Error: #{e.message}"
    raise
  end

  private

  def kafka_consumer
    @kafka ||= Kafka.new(
      seed_brokers: [
        "localhost:9092",
      ],
      client_id: ENV.fetch('CLIENT_ID', 'my-app')
    )
  end

  def handle_event(event)
    puts "[Kafka][#{event.topic}][offset=#{event.offset}] Message received"

    data = JSON.parse(event.value)
    message = OpenStruct.new(data)

    # TODO: xử lý message ở đây
    p message
  rescue JSON::ParserError => e
    puts "[Kafka][ERROR] Invalid JSON: #{e.message}"
  rescue => e
    puts "[Kafka][ERROR] Unexpected error: #{e.message}"
    raise
  end

  def get_topic_name(group_id, app_name)
    "#{app_name}-#{group_id}"
  end
end
#Consumer.new(group_id: 'my-group').start('my-topic')
#bin/rails runner "Consumer.new(group_id: 'my-group').start('my-topic')"