# Project Challenges

This section documents the technical and operational challenges faced during the development and production deployment of WARGAMES.

## Creation Challenges

### Seamless Level Transitions
**The Problem:**
A key design goal was to allow users to progress to the next level without needing to manually exit the current container or SSH into a different user account, which is a common pattern in other CTF platforms. We wanted a smoother, more immersive experience.

**The Solution:**
We implemented a custom `move` script that is bind-mounted into the container.
- The script communicates with the host system using specific **exit codes**.
- When a level is completed, the container exits with a specific code.
- The host script captures this code and automatically spawns the container for the next level.

## Production Challenges

### DockerHub Rate Limiting
**The Problem:**
During a live workshop, we encountered severe issues with DockerHub's free tier rate limits. With multiple participants attempting to pull images simultaneously from the same IP address (or just high volume), the downloads were throttled or blocked, disrupting the event.

**The Solution:**
We migrated the container image hosting to **GitHub Container Registry (GHCR)**.
- GHCR provided higher rate limits and better reliability for concurrent pulls.
- This ensured that workshops and simultaneous deployments could proceed without infrastructure bottlenecks.
