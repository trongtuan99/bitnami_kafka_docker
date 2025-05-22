# bitnami_kafka_docker

# Kafka Local Cluster for Dev (Mac M2)

Cluster Kafka gồm 1 node Kafka chạy trên Docker, tích hợp Kafka UI để quản lý, xem message dễ dàng.

---

## Yêu cầu

- Docker & Docker Compose
- MacOS M2
- app kết nối Kafka dùng `host.docker.internal` hoặc `localhost:9092` nếu đã allow host

---

## Cấu hình dịch vụ

| Service  | Image                            | Port Host | Mô tả               |
| -------- | -------------------------------- | --------- | ------------------- |
| kafka1   | bitnami/kafka:3.5.1-debian-11-r0 | 9092      | Kafka broker node 1 |
| kafka-ui | provectuslabs/kafka-ui:0.23.0    | 8080      | UI Kafka trên web   |

---

## Cách dùng

1. Tạo file `.env` hoặc chỉnh sửa các biến bên dưới
   DATA_DIR=./data

2. Chạy command:

   ```bash
   docker-compose up -d
   ```

3: http://localhost:8080 Mở UI Kafka:

4: kafka = Kafka.new(
seed_brokers: [
"localhost:9092",
],
client_id: "rails-app"
)

5:Kafka data sẽ lưu ở:
${DATA_DIR:-./data}/kafka1

Câu lệnh hữu ích
docker-compose logs -f kafka1 — xem log kafka1

docker-compose ps — xem trạng thái container

docker-compose down -v — dừng và xóa container + volumes

Notes
Docker platform set linux/arm64 tương thích Mac M2.
Kafka UI version v0.7.2 ổn định, không dùng latest.
