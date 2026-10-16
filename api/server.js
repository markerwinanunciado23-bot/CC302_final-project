import { createServer } from 'node:http';
import { randomUUID } from 'node:crypto';
import { DatabaseSync } from 'node:sqlite';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { mkdir } from 'node:fs/promises';

const defaultDatabasePath = resolve(dirname(fileURLToPath(import.meta.url)), 'blueway.sqlite');

export const seedBuses = [
  {
    id: 'bus-101',
    name: 'Blue Way Bohol Express',
    busNumber: 'BW-101',
    route: 'Tagbilaran → Tubigon',
    from: 'Tagbilaran',
    to: 'Tubigon',
    departure: '6:30 AM',
    arrival: '8:00 AM',
    fare: '₱85',
    driver: 'Rogelio Santos',
    busType: 'Air-Conditioned Bus',
    status: 'ON TIME',
    eta: '12 min',
    seats: 18,
    stops: ['Tagbilaran Terminal', 'Cortes', 'Calape', 'Clarin', 'Tubigon Terminal'],
    features: ['Aircon', 'USB Charging', 'Reclining Seats', 'Luggage Space'],
  },
  {
    id: 'bus-102',
    name: 'Blue Way Provincial',
    busNumber: 'BW-102',
    route: 'Tagbilaran → Carmen',
    from: 'Tagbilaran',
    to: 'Carmen',
    departure: '7:15 AM',
    arrival: '8:30 AM',
    fare: '₱70',
    driver: 'Jose Dela Cruz',
    busType: 'Provincial Bus',
    status: 'BOARDING',
    eta: '5 min',
    seats: 24,
    stops: ['Tagbilaran Terminal', 'Dao', 'Batuan Junction', 'Carmen Terminal'],
    features: ['Aircon', 'Comfortable Seats', 'Luggage Space'],
  },
  {
    id: 'bus-103',
    name: 'Blue Way Island Transport',
    busNumber: 'BW-103',
    route: 'Tagbilaran → Loboc',
    from: 'Tagbilaran',
    to: 'Loboc',
    departure: '8:00 AM',
    arrival: '9:00 AM',
    fare: '₱60',
    driver: 'Pedro Garcia',
    busType: 'Island Transport Bus',
    status: 'ON TIME',
    eta: '20 min',
    seats: 14,
    stops: ['Tagbilaran Terminal', 'Corella', 'Loboc Junction', 'Loboc Terminal'],
    features: ['Aircon', 'Comfortable Seats', 'Luggage Space'],
  },
  {
    id: 'bus-104',
    name: 'Blue Way Transit',
    busNumber: 'BW-104',
    route: 'Tubigon → Tagbilaran',
    from: 'Tubigon',
    to: 'Tagbilaran',
    departure: '9:00 AM',
    arrival: '10:30 AM',
    fare: '₱85',
    driver: 'Michael Cruz',
    busType: 'Transit Bus',
    status: 'ON TIME',
    eta: '25 min',
    seats: 20,
    stops: ['Tubigon Terminal', 'Clarin', 'Calape', 'Cortes', 'Tagbilaran Terminal'],
    features: ['Aircon', 'USB Charging', 'Reclining Seats'],
  },
  {
    id: 'bus-105',
    name: 'Blue Way Express',
    busNumber: 'BW-105',
    route: 'Tagbilaran → Jagna',
    from: 'Tagbilaran',
    to: 'Jagna',
    departure: '10:00 AM',
    arrival: '12:00 PM',
    fare: '₱100',
    driver: 'Carlos Mendoza',
    busType: 'Express Bus',
    status: 'ON TIME',
    eta: '35 min',
    seats: 16,
    stops: ['Tagbilaran Terminal', 'Baclayon', 'Alburquerque', 'Dimiao', 'Jagna Terminal'],
    features: ['Aircon', 'USB Charging', 'Reclining Seats', 'Wi-Fi'],
  },
  {
    id: 'bus-106',
    name: 'Blue Way Shuttle',
    busNumber: 'BW-106',
    route: 'Tagbilaran → Panglao',
    from: 'Tagbilaran',
    to: 'Panglao',
    departure: '11:00 AM',
    arrival: '11:45 AM',
    fare: '₱50',
    driver: 'Ramon Reyes',
    busType: 'Shuttle Bus',
    status: 'BOARDING',
    eta: '8 min',
    seats: 22,
    stops: ['Tagbilaran Terminal', 'Bool', 'Dauis', 'Panglao'],
    features: ['Aircon', 'Comfortable Seats', 'Fast Boarding'],
  },
  {
    id: 'bus-107',
    name: 'Blue Way Bus Service',
    busNumber: 'BW-107',
    route: 'Tagbilaran → Ubay',
    from: 'Tagbilaran',
    to: 'Ubay',
    departure: '1:00 PM',
    arrival: '3:30 PM',
    fare: '₱120',
    driver: 'Fernando Lim',
    busType: 'Provincial Bus Service',
    status: 'DELAYED',
    eta: '45 min',
    seats: 19,
    stops: ['Tagbilaran Terminal', 'Carmen', 'Trinidad', 'Talibon', 'Ubay Terminal'],
    features: ['Aircon', 'USB Charging', 'Luggage Space', 'Reclining Seats'],
  },
];

class ApiError extends Error {
  constructor(status, message) {
    super(message);
    this.status = status;
  }
}

function sendJson(response, status, body) {
  response.writeHead(status, {
    'access-control-allow-origin': '*',
    'access-control-allow-methods': 'GET, POST, PATCH, DELETE, OPTIONS',
    'access-control-allow-headers': 'content-type',
    'content-type': 'application/json; charset=utf-8',
  });
  response.end(JSON.stringify(body));
}

async function readJson(request) {
  let body = '';
  for await (const chunk of request) {
    body += chunk;
    if (body.length > 1024 * 1024) {
      throw new ApiError(413, 'Request body is too large.');
    }
  }

  try {
    return JSON.parse(body);
  } catch {
    throw new ApiError(400, 'Request body must be valid JSON.');
  }
}

function requiredString(value, field, maxLength = 200) {
  if (typeof value !== 'string' || value.trim().length === 0) {
    throw new ApiError(400, `${field} is required.`);
  }
  if (value.trim().length > maxLength) {
    throw new ApiError(400, `${field} must be ${maxLength} characters or fewer.`);
  }
  return value.trim();
}

function stringList(value, field) {
  if (!Array.isArray(value) || value.some((item) => typeof item !== 'string')) {
    throw new ApiError(400, `${field} must be a list of strings.`);
  }
  return value.map((item) => requiredString(item, field, 100));
}

function validateBus(input) {
  const bus = {
    name: requiredString(input.name, 'name'),
    busNumber: requiredString(input.busNumber, 'busNumber', 32),
    from: requiredString(input.from, 'from', 100),
    to: requiredString(input.to, 'to', 100),
    departure: requiredString(input.departure, 'departure', 32),
    arrival: requiredString(input.arrival, 'arrival', 32),
    fare: requiredString(input.fare, 'fare', 32),
    driver: requiredString(input.driver, 'driver', 100),
    busType: requiredString(input.busType, 'busType', 100),
    status: requiredString(input.status, 'status', 32),
    eta: requiredString(input.eta, 'eta', 32),
    seats: Number(input.seats),
    stops: stringList(input.stops, 'stops'),
    features: stringList(input.features, 'features'),
  };
  if (!Number.isInteger(bus.seats) || bus.seats < 1 || bus.seats > 500) {
    throw new ApiError(400, 'seats must be an integer from 1 to 500.');
  }
  bus.route = `${bus.from} → ${bus.to}`;
  return bus;
}

function validateBooking(input) {
  return {
    busId: requiredString(input.busId, 'busId', 64),
    passenger: requiredString(input.passenger, 'passenger', 120),
    phone: requiredString(input.phone, 'phone', 40),
    date: requiredString(input.date, 'date', 32),
    seat: requiredString(input.seat, 'seat', 32),
  };
}

function mapBus(row) {
  if (!row) return null;
  return {
    id: row.id,
    name: row.name,
    busNumber: row.bus_number,
    route: row.route,
    from: row.from_location,
    to: row.to_location,
    departure: row.departure,
    arrival: row.arrival,
    fare: row.fare,
    driver: row.driver,
    busType: row.bus_type,
    status: row.status,
    eta: row.eta,
    seats: row.seats,
    stops: JSON.parse(row.stops),
    features: JSON.parse(row.features),
  };
}

function mapBooking(row) {
  if (!row) return null;
  return {
    id: row.booking_id,
    reference: row.reference,
    passenger: row.passenger,
    phone: row.phone,
    date: row.date,
    seat: row.seat,
    bus: {
      id: row.bus_id,
      name: row.bus_name,
      busNumber: row.bus_number,
      route: row.route,
      from: row.from_location,
      to: row.to_location,
      departure: row.departure,
      arrival: row.arrival,
      fare: row.fare,
      driver: row.driver,
      busType: row.bus_type,
      status: row.status,
      eta: row.eta,
      seats: row.seats,
      stops: JSON.parse(row.stops),
      features: JSON.parse(row.features),
    },
  };
}

function createDatabase(database) {
  database.exec(`
    PRAGMA foreign_keys = ON;
    CREATE TABLE IF NOT EXISTS buses (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      bus_number TEXT NOT NULL UNIQUE,
      route TEXT NOT NULL,
      from_location TEXT NOT NULL,
      to_location TEXT NOT NULL,
      departure TEXT NOT NULL,
      arrival TEXT NOT NULL,
      fare TEXT NOT NULL,
      driver TEXT NOT NULL,
      bus_type TEXT NOT NULL,
      status TEXT NOT NULL,
      eta TEXT NOT NULL,
      seats INTEGER NOT NULL CHECK (seats > 0),
      stops TEXT NOT NULL,
      features TEXT NOT NULL
    );
    CREATE TABLE IF NOT EXISTS bookings (
      id TEXT PRIMARY KEY,
      reference TEXT NOT NULL UNIQUE,
      bus_id TEXT NOT NULL REFERENCES buses(id) ON DELETE RESTRICT,
      passenger TEXT NOT NULL,
      phone TEXT NOT NULL,
      date TEXT NOT NULL,
      seat TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      UNIQUE (bus_id, date, seat)
    );
  `);

  const count = database.prepare('SELECT COUNT(*) AS count FROM buses').get().count;
  if (count === 0) {
    const insert = database.prepare(`
      INSERT INTO buses (
        id, name, bus_number, route, from_location, to_location, departure, arrival,
        fare, driver, bus_type, status, eta, seats, stops, features
      ) VALUES (
        @id, @name, @busNumber, @route, @from, @to, @departure, @arrival,
        @fare, @driver, @busType, @status, @eta, @seats, @stops, @features
      )
    `);
    database.exec('BEGIN IMMEDIATE');
    try {
      for (const bus of seedBuses) {
        insert.run({ ...bus, stops: JSON.stringify(bus.stops), features: JSON.stringify(bus.features) });
      }
      database.exec('COMMIT');
    } catch (error) {
      database.exec('ROLLBACK');
      throw error;
    }
  }
}

const busSelect = 'SELECT * FROM buses';
const bookingSelect = `
  SELECT bookings.id AS booking_id, bookings.reference, bookings.passenger,
    bookings.phone, bookings.date, bookings.seat, bookings.bus_id,
    buses.name AS bus_name, buses.bus_number, buses.route, buses.from_location,
    buses.to_location, buses.departure, buses.arrival, buses.fare, buses.driver,
    buses.bus_type, buses.status, buses.eta, buses.seats, buses.stops, buses.features
  FROM bookings JOIN buses ON buses.id = bookings.bus_id
`;

export async function createApiServer({ databasePath = defaultDatabasePath } = {}) {
  if (databasePath !== ':memory:') {
    await mkdir(dirname(databasePath), { recursive: true });
  }
  const database = new DatabaseSync(databasePath);
  createDatabase(database);

  const server = createServer(async (request, response) => {
    if (request.method === 'OPTIONS') {
      response.writeHead(204, {
        'access-control-allow-origin': '*',
        'access-control-allow-methods': 'GET, POST, PATCH, DELETE, OPTIONS',
        'access-control-allow-headers': 'content-type',
      });
      response.end();
      return;
    }

    try {
      const url = new URL(request.url, 'http://localhost');
      const path = url.pathname.replace(/\/+$/, '') || '/';
      const busMatch = path.match(/^\/api\/buses\/([^/]+)$/);
      const bookingMatch = path.match(/^\/api\/bookings\/([^/]+)$/);

      if (request.method === 'GET' && path === '/api/health') {
        sendJson(response, 200, { status: 'ok' });
        return;
      }

      if (request.method === 'GET' && path === '/api/buses') {
        sendJson(response, 200, database.prepare(`${busSelect} ORDER BY bus_number`).all().map(mapBus));
        return;
      }
      if (request.method === 'GET' && busMatch) {
        const bus = mapBus(database.prepare(`${busSelect} WHERE id = ?`).get(decodeURIComponent(busMatch[1])));
        if (!bus) throw new ApiError(404, 'Bus not found.');
        sendJson(response, 200, bus);
        return;
      }
      if (request.method === 'POST' && path === '/api/buses') {
        const input = await readJson(request);
        const bus = validateBus(input);
        const id = randomUUID();
        database.prepare(`
          INSERT INTO buses (
            id, name, bus_number, route, from_location, to_location, departure, arrival,
            fare, driver, bus_type, status, eta, seats, stops, features
          ) VALUES (
            @id, @name, @busNumber, @route, @from, @to, @departure, @arrival,
            @fare, @driver, @busType, @status, @eta, @seats, @stops, @features
          )
        `).run({ ...bus, id, stops: JSON.stringify(bus.stops), features: JSON.stringify(bus.features) });
        sendJson(response, 201, mapBus(database.prepare(`${busSelect} WHERE id = ?`).get(id)));
        return;
      }
      if (request.method === 'PATCH' && busMatch) {
        const id = decodeURIComponent(busMatch[1]);
        const existing = mapBus(database.prepare(`${busSelect} WHERE id = ?`).get(id));
        if (!existing) throw new ApiError(404, 'Bus not found.');
        const bus = validateBus({ ...existing, ...(await readJson(request)) });
        database.prepare(`
          UPDATE buses SET
            name=@name, bus_number=@busNumber, route=@route, from_location=@from,
            to_location=@to, departure=@departure, arrival=@arrival, fare=@fare,
            driver=@driver, bus_type=@busType, status=@status, eta=@eta, seats=@seats,
            stops=@stops, features=@features
          WHERE id=@id
        `).run({ ...bus, id, stops: JSON.stringify(bus.stops), features: JSON.stringify(bus.features) });
        sendJson(response, 200, mapBus(database.prepare(`${busSelect} WHERE id = ?`).get(id)));
        return;
      }
      if (request.method === 'DELETE' && busMatch) {
        const result = database.prepare('DELETE FROM buses WHERE id = ?').run(decodeURIComponent(busMatch[1]));
        if (result.changes === 0) throw new ApiError(404, 'Bus not found.');
        sendJson(response, 200, { deleted: true });
        return;
      }

      if (request.method === 'GET' && path === '/api/bookings') {
        sendJson(response, 200, database.prepare(`${bookingSelect} ORDER BY bookings.created_at DESC`).all().map(mapBooking));
        return;
      }
      if (request.method === 'GET' && bookingMatch) {
        const booking = mapBooking(database.prepare(`${bookingSelect} WHERE bookings.id = ?`).get(decodeURIComponent(bookingMatch[1])));
        if (!booking) throw new ApiError(404, 'Booking not found.');
        sendJson(response, 200, booking);
        return;
      }
      if (request.method === 'POST' && path === '/api/bookings') {
        const input = validateBooking(await readJson(request));
        if (!database.prepare('SELECT id FROM buses WHERE id = ?').get(input.busId)) {
          throw new ApiError(404, 'Bus not found.');
        }
        const id = randomUUID();
        const now = new Date().toISOString();
        const reference = `BW-${randomUUID().replaceAll('-', '').slice(0, 8).toUpperCase()}`;
        database.prepare(`
          INSERT INTO bookings (id, reference, bus_id, passenger, phone, date, seat, created_at, updated_at)
          VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `).run(id, reference, input.busId, input.passenger, input.phone, input.date, input.seat, now, now);
        const booking = mapBooking(database.prepare(`${bookingSelect} WHERE bookings.id = ?`).get(id));
        sendJson(response, 201, booking);
        return;
      }
      if (request.method === 'PATCH' && bookingMatch) {
        const id = decodeURIComponent(bookingMatch[1]);
        const existing = mapBooking(database.prepare(`${bookingSelect} WHERE bookings.id = ?`).get(id));
        if (!existing) throw new ApiError(404, 'Booking not found.');
        const input = validateBooking({
          busId: existing.bus.id,
          passenger: existing.passenger,
          phone: existing.phone,
          date: existing.date,
          seat: existing.seat,
          ...(await readJson(request)),
        });
        if (!database.prepare('SELECT id FROM buses WHERE id = ?').get(input.busId)) {
          throw new ApiError(404, 'Bus not found.');
        }
        database.prepare(`
          UPDATE bookings
          SET bus_id=?, passenger=?, phone=?, date=?, seat=?, updated_at=?
          WHERE id=?
        `).run(input.busId, input.passenger, input.phone, input.date, input.seat, new Date().toISOString(), id);
        sendJson(response, 200, mapBooking(database.prepare(`${bookingSelect} WHERE bookings.id = ?`).get(id)));
        return;
      }
      if (request.method === 'DELETE' && bookingMatch) {
        const result = database.prepare('DELETE FROM bookings WHERE id = ?').run(decodeURIComponent(bookingMatch[1]));
        if (result.changes === 0) throw new ApiError(404, 'Booking not found.');
        sendJson(response, 200, { deleted: true });
        return;
      }

      throw new ApiError(404, 'Endpoint not found.');
    } catch (error) {
      if (error instanceof ApiError) {
        sendJson(response, error.status, { error: error.message });
        return;
      }
      if (error?.errcode === 2067 || error?.errcode === 1555) {
        sendJson(response, 409, { error: 'A bus with that number or a booking for that seat already exists.' });
        return;
      }
      if (error?.errcode === 787 || error?.message?.includes('FOREIGN KEY constraint failed')) {
        sendJson(response, 409, { error: 'Delete this bus’s bookings before deleting the bus.' });
        return;
      }
      console.error('API request failed:', error);
      sendJson(response, 500, { error: 'The server could not complete the request.' });
    }
  });

  server.on('close', () => database.close());
  return server;
}

if (process.argv[1] && resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const host = process.env.HOST ?? '0.0.0.0';
  const port = Number(process.env.PORT ?? 3000);
  let alreadyRunning = false;

  try {
    const response = await fetch(`http://127.0.0.1:${port}/api/health`, {
      signal: AbortSignal.timeout(500),
    });
    if (response.ok && (await response.json()).status === 'ok') {
      alreadyRunning = true;
    }
  } catch {
    // No healthy API is listening, so start one below.
  }

  if (alreadyRunning) {
    console.log(`Blue Way API listening on http://localhost:${port} (already running)`);
    process.exit(0);
  }

  const server = await createApiServer();
  server.listen(port, host, () => {
    console.log(`Blue Way API listening on http://${host}:${port}`);
    console.log(`SQLite database: ${process.env.DATABASE_PATH ?? defaultDatabasePath}`);
  });
}
