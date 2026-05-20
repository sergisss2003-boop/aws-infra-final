import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 10 },  // Sube a 10 usuarios
    { duration: '1m', target: 50 },   // Sube a 50 usuarios
    { duration: '30s', target: 100 }, // Sube a 100 usuarios
    { duration: '30s', target: 0 },   // Baja a 0
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% de requests bajo 500ms
    http_req_failed: ['rate<0.05'],   // Menos del 5% de errores
  },
};

const BASE_URL = __ENV.BASE_URL || 'http://localhost:8000';

export default function () {
  // Test health endpoint
  const healthRes = http.get(`${BASE_URL}/health`);
  check(healthRes, {
    'health status 200': (r) => r.status === 200,
    'health response ok': (r) => r.json('status') === 'ok',
  });

  sleep(0.5);

  // Test api/test endpoint
  const apiRes = http.get(`${BASE_URL}/api/test`);
  check(apiRes, {
    'api status 200': (r) => r.status === 200,
  });

  sleep(0.5);

  // Test items endpoint
  const itemsRes = http.get(`${BASE_URL}/items`);
  check(itemsRes, {
    'items status 200': (r) => r.status === 200,
  });

  sleep(1);
}