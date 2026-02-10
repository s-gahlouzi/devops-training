# Exercise 21: Process Management

## Goal

Manage background processes, job control, and parallel execution.

## Requirements

Create `parallel-downloads.sh` that:

1. Defines array of 5 URLs to download (simulate with sleep)
2. Downloads all URLs in parallel using background jobs
3. Collects all PIDs
4. Waits for all to complete
5. Reports success/failure for each
6. Fails if any download failed

Create `timeout-command.sh` that:

1. Takes command and timeout as arguments
2. Runs command in background
3. Waits for timeout duration
4. Kills command if still running
5. Returns appropriate exit code

Create `worker-pool.sh` that:

1. Processes items from a list
2. Runs max 3 workers concurrently
3. Starts new worker when one finishes
4. Waits for all workers to complete
5. Shows progress

Create `health-check.sh` that:

1. Starts a service in background
2. Waits for it to be healthy (poll endpoint)
3. Times out after 30 seconds
4. Kills service if unhealthy
5. Uses trap to cleanup process

## Expected Output

```bash
./parallel-downloads.sh
Starting 5 downloads in parallel...
Download 1 (PID 1234): started
Download 2 (PID 1235): started
Download 3 (PID 1236): started
Download 4 (PID 1237): started
Download 5 (PID 1238): started

Waiting for downloads to complete...
Download 1: SUCCESS
Download 2: SUCCESS
Download 3: FAILED
Download 4: SUCCESS
Download 5: SUCCESS

4/5 downloads successful
Exit code: 1

./timeout-command.sh "sleep 10" 5
Command timed out after 5 seconds
Killed process 5678
Exit code: 124

./timeout-command.sh "sleep 2" 5
Command completed successfully
Exit code: 0

./worker-pool.sh items.txt
Processing 10 items with 3 workers...
Worker 1: Processing item1
Worker 2: Processing item2
Worker 3: Processing item3
Worker 1: Processing item4
Worker 2: Processing item5
...
All items processed!

./health-check.sh
Starting service...
Service PID: 9876
Waiting for health check...
Attempt 1/30: not ready
Attempt 2/30: not ready
Attempt 3/30: ready!
Service is healthy
```

## Success Criteria

- Background jobs work correctly
- PID tracking and management
- Wait for specific and all processes
- Timeout implementation
- Worker pool pattern
- Proper cleanup on exit
