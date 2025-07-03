const request = require('supertest');
const app = require('../src/api/index');
test('health check', async () => {
  const res = await request(app).get('/health');
  expect(res.text).toBe('OK');
});
