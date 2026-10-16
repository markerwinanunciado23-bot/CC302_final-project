import test, { afterEach } from 'node:test';
import assert from 'node:assert/strict';
import { createApiServer } from './server.js';

const servers = [];

afterEach(async () => {
  await Promise.all(servers.splice(0).map((server) => new Promise((resolve, reject) => {
    server.close((error) => error ? reject(error) : resolve());
  })));
});

async function startApi() {
  const server = await createApiServer({ databasePath: ':memory:' });
  servers.push(server);
  await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
  const { port } = server.address();
  return `http://127.0.0.1:${port}/api`;
}

async function request(baseUrl, path, method = 'GET', body) {
  const response = await fetch(`${baseUrl}${path}`, {
    method,
    headers: body ? { 'content-type': 'application/json' } : undefined,
    body: body ? JSON.stringify(body) : undefined,
  });
  return { status: response.status, body: await response.json() };
}

const busInput = {
  name: 'Test Shuttle',
  busNumber: 'TEST-1',
  from: 'Tagbilaran',
  to: 'Panglao',
  departure: '2:00 PM',
  arrival: '2:45 PM',
  fare: '₱50',
  driver: 'Test Driver',
  busType: 'Shuttle Bus',
  status: 'ON TIME',
  eta: '5 min',
  seats: 20,
  stops: ['Tagbilaran', 'Panglao'],
  features: ['Aircon'],
};

test('bus endpoints create, list, update, and delete a bus', async () => {
  const baseUrl = await startApi();
  const created = await request(baseUrl, '/buses', 'POST', busInput);
  assert.equal(created.status, 201);
  assert.equal(created.body.route, 'Tagbilaran → Panglao');

  const listed = await request(baseUrl, '/buses');
  assert.equal(listed.status, 200);
  assert.ok(listed.body.some((bus) => bus.id === created.body.id));

  const updated = await request(baseUrl, `/buses/${created.body.id}`, 'PATCH', {
    status: 'DELAYED',
  });
  assert.equal(updated.status, 200);
  assert.equal(updated.body.status, 'DELAYED');

  const deleted = await request(baseUrl, `/buses/${created.body.id}`, 'DELETE');
  assert.equal(deleted.status, 200);
  assert.equal((await request(baseUrl, `/buses/${created.body.id}`)).status, 404);
});

test('booking endpoints create, update, delete, and protect booked buses', async () => {
  const baseUrl = await startApi();
  const buses = await request(baseUrl, '/buses');
  const bus = buses.body[0];
  const input = {
    busId: bus.id,
    passenger: 'Test Passenger',
    phone: '09123456789',
    date: '10/20/2026',
    seat: 'Seat 1',
  };

  const created = await request(baseUrl, '/bookings', 'POST', input);
  assert.equal(created.status, 201);
  assert.equal(created.body.bus.id, bus.id);
  assert.match(created.body.reference, /^BW-[A-F0-9]{8}$/);

  const duplicate = await request(baseUrl, '/bookings', 'POST', input);
  assert.equal(duplicate.status, 409);

  const protectedDelete = await request(baseUrl, `/buses/${bus.id}`, 'DELETE');
  assert.equal(protectedDelete.status, 409);

  const updated = await request(baseUrl, `/bookings/${created.body.id}`, 'PATCH', {
    passenger: 'Updated Passenger',
  });
  assert.equal(updated.status, 200);
  assert.equal(updated.body.passenger, 'Updated Passenger');

  assert.equal((await request(baseUrl, '/bookings')).body.length, 1);
  assert.equal((await request(baseUrl, `/bookings/${created.body.id}`, 'DELETE')).status, 200);
  assert.equal((await request(baseUrl, '/bookings')).body.length, 0);
});

test('API validates input and reports missing resources', async () => {
  const baseUrl = await startApi();
  assert.equal((await request(baseUrl, '/buses', 'POST', {})).status, 400);
  assert.equal((await request(baseUrl, '/buses/missing')).status, 404);
  assert.equal((await request(baseUrl, '/health')).body.status, 'ok');
});
