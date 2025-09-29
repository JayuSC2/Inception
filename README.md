# Inception

A **42 School** project about using **Docker** to virtualize multiple services and set up a small infrastructure.  
The goal is to build a mini cluster with containers, following strict rules (no pre-built images, no shortcuts).

---

## Project Overview
- Setup of a complete infrastructure using Docker Compose.
- Each service runs in its own container.
- Images are built from scratch using Dockerfile.
- System follows a strict directory structure to ensure modularity and clarity.

---

## Services
- **NGINX** (with TLS support)
- **WordPress** (with PHP-FPM)
- **MariaDB**

---

## Usage
### 1. Clone the repository

```bash
git clone https://github.com/your-username/inception.git
cd inception
```

### 2. Setup

- Fill in your environment variables inside .env (database credentials, domain name, etc.).
- make up (docker compose up --build -d)
- make down (stop containers)


