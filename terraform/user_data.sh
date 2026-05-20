#!/bin/bash
yum update -y
yum install -y python3 python3-pip git

# Clonar el repositorio
cd /home/ec2-user
git clone https://github.com/TU_USUARIO/aws-infra-final.git
cd aws-infra-final/app

# Instalar dependencias
pip3 install -r requirements.txt

# Crear archivo de variables de entorno
cat > .env << EOF
DATABASE_URL=postgresql://${db_username}:${db_password}@${db_host}:5432/${db_name}
EOF

# Crear servicio systemd
cat > /etc/systemd/system/fastapi.service << EOF
[Unit]
Description=FastAPI Application
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/aws-infra-final/app
ExecStart=/usr/local/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=always
EnvironmentFile=/home/ec2-user/aws-infra-final/app/.env

[Install]
WantedBy=multi-user.target
EOF

# Iniciar el servicio
systemctl daemon-reload
systemctl enable fastapi
systemctl start fastapi