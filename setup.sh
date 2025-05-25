#!/bin/bash
set -e -o pipefail

BACKEND_DIR="./backend"

cd "$BACKEND_DIR"
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

SERVICE_SRC="../systemd/pymorphy2-backend.service"
SERVICE_DST="/etc/systemd/system/pymorphy2-backend.service"
sudo cp "$SERVICE_SRC" "$SERVICE_DST"
sudo chown root:root "$SERVICE_DST"
sudo chmod 644 "$SERVICE_DST"

sudo systemctl daemon-reload
sudo systemctl enable pymorphy2-backend
sudo systemctl restart pymorphy2-backend

echo "PyMorphy2 backend service started"
echo "To see logs: sudo journalctl -u pymorphy2-backend -f"
