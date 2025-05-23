import http from 'k6/http';

export default function () {
  const url = 'http://10.20.14.111/api/analyze';
  const payload = JSON.stringify({ text: 'привет' });

  const params = {
    headers: { 'Content-Type': 'application/json' },
  };

  http.post(url, payload, params);
}
