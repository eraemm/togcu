#!/bin/bash

# Discord Webhook URL
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1328727445997879357/EKwM6ThwPYi8OqWdLOqoZcskpjEubJDquWYgBgMuNjV5HZr5ENNIV1-lWQK8d9h_nLI8"

# Kullanıcıdan bağlı mail adresini al
read -p "Sunucunun bağlı olduğu mail adresini girin: " SERVER_MAIL

# Sunucu IP adresini al
SERVER_IP=$(hostname -I | awk '{print $1}')

# Kontrol edilecek IP veya hostname
SERVER_ADDRESS="bench.tigpool.com"

# Mesaj gönderme fonksiyonu
send_discord_message() {
  local message=$1
  curl -H "Content-Type: application/json" \
       -d "{\"content\": \"$message\"}" \
       "$DISCORD_WEBHOOK_URL"
}

# Sunucu kontrolü
check_server_status() {
  if ping -c 1 "$SERVER_ADDRESS" &> /dev/null; then
    send_discord_message "✅ Sunucu $SERVER_ADDRESS aktif. Bağlı mail: $SERVER_MAIL. IP: $SERVER_IP"
  else
    send_discord_message "❌ Sunucu $SERVER_ADDRESS erişilemez! Bağlı mail: $SERVER_MAIL. IP: $SERVER_IP"
  fi
}

# Durum kontrolü her saat
while true; do
  check_server_status
  sleep 3600 # 1 saat bekleme
done
