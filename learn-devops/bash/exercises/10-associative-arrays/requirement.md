# Exercise 10: Associative Arrays

## Goal

Use associative arrays (hash maps) for key-value configuration.

## Requirements

Create `config-manager.sh` that:

1. Declares an associative array for service ports:

   - api: 3000
   - web: 8080
   - database: 5432
   - cache: 6379

2. Implements functions:

   - `get_port(service)` - Returns port for service
   - `set_port(service, port)` - Sets port for service
   - `list_services()` - Lists all services and ports
   - `has_service(service)` - Checks if service exists

3. Test script that:
   - Lists all services
   - Gets port for "api"
   - Sets new port for "web"
   - Checks if "metrics" exists
   - Adds new service "metrics" with port 9090

## Expected Output

```
Services:
  api: 3000
  web: 8080
  database: 5432
  cache: 6379

Port for 'api': 3000
Updated 'web' port to 3001
Service 'metrics' exists: no
Added service 'metrics' on port 9090

All services:
  api: 3000
  web: 3001
  database: 5432
  cache: 6379
  metrics: 9090
```

## Success Criteria

- Associative array declared correctly
- Key-value operations work
- Iteration over keys works
- Lookup and existence checks work
