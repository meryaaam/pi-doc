# PI-Cloud 25-26 – MkDocs Documentation

[![MkDocs Version](https://img.shields.io/badge/MkDocs-1.6+-blue.svg)](https://www.mkdocs.org/)
[![Material Theme](https://img.shields.io/badge/Theme-Material-cyan.svg)](https://squidfunk.github.io/mkdocs-material/)
[![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED.svg)](https://www.docker.com/)
[![Make](https://img.shields.io/badge/Make-Ready-ff69b4.svg)](https://www.gnu.org/software/make/)

[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📖 About This Documentation

This is the **official technical documentation** for the **PI-Cloud 25-26** project. It serves as a comprehensive guide covering infrastructure design, deployment procedures, AI integration, and operational management of the private cloud solution aligned with the UN Sustainable Development Goals.

> *"Sustainable living means understanding how our lifestyle choices impact the world around us." – UN Environment Program*

---

## 🎯 Purpose of This Documentation

This MkDocs site provides:

- ✅ Complete project specifications and requirements
- ✅ Infrastructure architecture design and decisions
- ✅ Deployment guides for the private cloud environment
- ✅ AI integration strategies and model documentation
- ✅ Orchestration and automation workflows
- ✅ Monitoring and observability setup
- ✅ Backup/recovery or version upgrade procedures
- ✅ API references and application documentation
- ✅ Troubleshooting and maintenance guides

---

## 🚀 Quick Start (For Documentation Maintainers)

### Prerequisites

Ensure you have the following installed:

```bash
# Check Python 3.8+ and pip
python --version
pip --version

# Check Docker and Docker Compose
docker --version
docker-compose --version

# Check Make
make --version

## 🛠️ Available Make Commands

The project uses a Makefile to simplify documentation management and development workflows.

| Command | Description |
|---------|-------------|
| `make help` | Show all available commands |
| `make build` | Build Docker images |
| `make up` | Start the documentation server |
| `make open` | Open documentation in browser |
| `make lint` | Check markdown files |
| `make logs` | View real-time logs |
| `make down` | Stop the documentation server |
| `make restart` | Restart the server |
| `make status` | Check container status |
| `make clean` | Remove temporary files |

---

## ▶️ Running the Documentation Locally

### 1. Build Docker Images

```bash
make build
```

### 2. Start the Documentation Server

```bash
make up
```

### 3. Open the Documentation in Your Browser

```bash
make open
```

By default, the MkDocs server will be available at:

```text
http://localhost:8001
```

---

## 🔍 Development & Maintenance

### Validate Markdown Files

```bash
make lint
```

### Monitor Container Logs

```bash
make logs
```

### Check Running Services

```bash
make status
```

### Restart the Documentation Environment

```bash
make restart
```

### Stop All Services

```bash
make down
```

### Clean Temporary Files and Resources

```bash
make clean
```

---

## 📂 Project Structure

```text

pi-cloud-docs/
├── Dockerfile.mkdocs           # MkDocs with Python dependencies
├── Dockerfile.markdownlint     # markdownlint with Node.js
├── docker-compose.yml          # Docker services configuration
├── Makefile                    # Make commands
├── .dockerignore               # Files to exclude from builds
├── .markdownlint.json          # Linter rules configuration
├── mkdocs.yml                  # MkDocs site configuration
├── docs/
│   ├── index.md                # Home page
├── site/                       # Generated static site (ignored)
└── README.md                   # This file
```

---

## 🐳 Docker Support

This project is fully containerized for consistent local development and deployment.

Features include:

- Reproducible documentation environments
- Simplified onboarding for contributors
- Isolated dependency management
- Easy deployment to CI/CD pipelines

---

## 🤝 Contribution Guidelines

Contributions are welcome.

Before submitting changes:

1. Run markdown linting
2. Verify MkDocs builds successfully
3. Ensure documentation formatting remains consistent
4. Test Docker startup and Make commands

---

## 📄 License

This project is licensed under the MIT License.

See the [LICENSE](LICENSE) file for more information.