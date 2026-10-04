BÀI TẬP 4: CẤU HÌNH TƯỜNG LỬA BẢO VỆ MÁY CHỦ (UFW & CLOUD FIREWALL INTEGRATION)

1. MỤC TIÊU
- Thiết lập tường lửa UFW (Uncomplicated Firewall) trên Ubuntu Server để kiểm soát và lọc các gói tin mạng ở tầng hệ điều hành (Host-based Firewall).
- Kết hợp tường lửa DigitalOcean Cloud Firewall ở tầng hạ tầng đám mây (Network-based Firewall) tạo kiến trúc bảo vệ đa lớp (Defense in Depth).
- Chỉ cho phép lưu lượng truy cập qua hai cổng thiết yếu: Cổng 22 (SSH) và Cổng 80 (HTTP). Chặn toàn bộ các cổng còn lại.

2. CÁC BƯỚC THỰC HIỆN

2.1. Cấu hình Tường lửa tầng OS (UFW)
Chạy các lệnh thiết lập chính sách mặc định và mở cổng:
```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw --force enable
```

2.2. Cấu hình DigitalOcean Cloud Firewall (Tầng hạ tầng)
- Bước 1: Truy cập DigitalOcean Console -> "Networking" -> "Firewalls".
- Bước 2: Chọn "Create Firewall" và đặt tên (ví dụ: fw-ptit-devops).
- Bước 3: Cấu hình Inbound Rules:
  - SSH: Protocol TCP, Port 22, Sources: All IPv4, All IPv6 (hoặc giới hạn theo IP cá nhân).
  - HTTP: Protocol TCP, Port 80, Sources: All IPv4, All IPv6.
- Bước 4: Cấu hình Outbound Rules:
  - All TCP, All UDP, All ICMP to All IPv4, All IPv6 (cho phép server tải gói/cập nhật hệ thống).
- Bước 5: Tại mục "Apply to Droplets", tìm và chọn Droplet "ptit-devops-server", sau đó nhấn "Create Firewall".

3. KẾT QUẢ KIỂM TRA VÀ LOG TERMINAL

3.1. Kiểm tra trạng thái UFW trên Server
Chạy lệnh kiểm tra:
```bash
sudo ufw status verbose
```

Đầu ra Terminal:
```text
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
80/tcp (v6)                ALLOW IN    Anywhere (v6)
```

3.2. Kiểm tra kết nối mạng từ máy cá nhân
- Kiểm tra SSH:
```bash
ssh -i ~/.ssh/id_ed25519_do devops@159.223.45.67
```
Kết quả: Đăng nhập thành công qua port 22.

- Kiểm tra HTTP:
```bash
curl -I http://159.223.45.67
```
Kết quả: HTTP/1.1 200 OK.

- Kiểm tra cổng chưa mở (ví dụ: MySQL 3306):
```bash
nc -zv -w3 159.223.45.67 3306
```
Kết quả: Connection timed out (bị chặn hoàn toàn bởi Cloud Firewall và UFW).

4. KẾT LUẬN
- Tường lửa 2 lớp (UFW và Cloud Firewall) đã được kích hoạt và hoạt động đồng bộ.
- Droplet được bảo vệ an toàn khỏi các cuộc quét cổng và tấn công mạng trên các cổng dịch vụ không sử dụng.
