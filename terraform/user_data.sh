#!/bin/bash
set -e
exec > /var/log/user_data.log 2>&1

echo "=== Iniciando instalación ==="

# Actualizar e instalar dependencias
yum update -y
yum install -y python3 python3-pip git

echo "=== Clonando repositorio ==="
cd /home/ec2-user
git clone https://github.com/sergisss2003-boop/aws-infra-final.git
cd aws-infra-final/app

echo "=== Instalando dependencias Python ==="
pip3 install fastapi uvicorn sqlalchemy psycopg2-binary python-dotenv

echo "=== Creando archivo .env ==="
cat > .env << EOF
DATABASE_URL=postgresql://${db_username}:${db_password}@${db_host}:5432/${db_name}
EOF

echo "=== Creando servicio systemd ==="
cat > /etc/systemd/system/fastapi.service << EOF
[Unit]
Description=FastAPI Application
After=network.target

[Service]
User=root
WorkingDirectory=/home/ec2-user/aws-infra-final/app
ExecStart=/usr/local/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always
EnvironmentFile=/home/ec2-user/aws-infra-final/app/.env

[Install]
WantedBy=multi-user.target
EOF

echo "=== Iniciando servicio ==="
systemctl daemon-reload
systemctl enable fastapi
systemctl start fastapi

echo "=== Instalación completada ==="