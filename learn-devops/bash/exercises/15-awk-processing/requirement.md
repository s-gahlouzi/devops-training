# Exercise 15: Data Processing with awk

## Goal

Use awk for column-based data processing and calculations.

## Requirements

Create `services.csv`:

```
service,port,status,memory_mb
api,3000,running,245
web,8080,running,512
worker,3001,stopped,0
cache,6379,running,128
database,5432,running,1024
```

Create `awk-exercises.sh` that:

1. Extracts only service names (first column)
2. Prints services with ports > 5000
3. Calculates total memory usage of running services
4. Counts running vs stopped services
5. Formats output: "Service: api (port 3000) - running"
6. Finds service with highest memory usage

Create `access.log`:

```
192.168.1.1 - - [04/Feb/2026:10:00:01] "GET /api/users" 200 1234
192.168.1.2 - - [04/Feb/2026:10:00:02] "POST /api/login" 200 567
192.168.1.1 - - [04/Feb/2026:10:00:03] "GET /api/posts" 404 89
192.168.1.3 - - [04/Feb/2026:10:00:04] "GET /api/users" 200 2345
```

Create `log-stats.sh` that:

1. Counts requests per IP
2. Counts requests per status code
3. Calculates average response size
4. Lists unique endpoints

## Expected Output

```bash
./awk-exercises.sh
=== Service Names ===
api
web
worker
cache
database

=== High Ports (>5000) ===
cache 6379
database 5432

=== Total Memory (running services) ===
1909 MB

=== Service Status Count ===
running: 4
stopped: 1

=== Formatted Output ===
Service: api (port 3000) - running
Service: web (port 8080) - running
...

=== Highest Memory ===
database: 1024 MB

./log-stats.sh
=== Requests per IP ===
192.168.1.1: 2
192.168.1.2: 1
192.168.1.3: 1

=== Status Codes ===
200: 3
404: 1

=== Average Response Size ===
1058 bytes

=== Unique Endpoints ===
/api/users
/api/login
/api/posts
```

## Success Criteria

- Correct field extraction
- Proper filtering conditions
- Calculations work correctly
- Formatted output
- Uses awk built-in variables and functions
