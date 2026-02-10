# Exercise 09: Indexed Arrays

## Goal

Work with indexed arrays for managing lists of data.

## Requirements

Create `manage-services.sh` that:

1. Defines an array of service names: `["api", "web", "worker", "cache", "database"]`
2. Prints total number of services
3. Prints first and last service
4. Adds a new service "metrics" to the array
5. Removes "cache" from the array
6. Iterates and prints all services with index numbers
7. Checks if "web" exists in array

## Expected Output

```
Total services: 5
First service: api
Last service: database
After adding metrics: 6 services
After removing cache: 5 services
Services:
  [0] api
  [1] web
  [2] worker
  [3] database
  [4] metrics
Service 'web' exists: yes
Service 'redis' exists: no
```

## Success Criteria

- Array manipulation works correctly
- Proper iteration with indices
- Element addition/removal works
- Array search implemented
- Uses array-specific syntax
