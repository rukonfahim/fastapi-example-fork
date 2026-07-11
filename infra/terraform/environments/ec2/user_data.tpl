#!/bin/bash
set -euo pipefail

apt-get update -y
apt-get install -y docker.io awscli
systemctl enable docker
systemctl start docker

mkdir -p /opt/fastapi
cat > /opt/fastapi/.env <<'EOF'
%{ for key, value in app_env ~}
${key}=${value}
%{ endfor ~}
EOF

docker pull ${container_image}
docker run -d --name fastapi \
  --restart unless-stopped \
  -p 80:8000 \
  --env-file /opt/fastapi/.env \
  --log-driver=awslogs \
  --log-opt awslogs-region=${region} \
  --log-opt awslogs-group=${log_group_name} \
  ${container_image}
