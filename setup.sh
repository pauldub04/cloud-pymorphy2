set -e -o nounset -o xtrace

cd backend

python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt

nohup uvicorn app.main:app --host 0.0.0.0 --port 8000 --log-level debug > server.log 2>&1 &
