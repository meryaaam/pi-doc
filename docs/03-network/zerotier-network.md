# ZeroTier Overlay Network

## Overview

The PI Cloud infrastructure uses a **ZeroTier Software-Defined Network (SDN)** to securely interconnect all infrastructure nodes across different physical locations.

The overlay network provides:

- Secure encrypted communication between nodes
- Simplified node discovery and routing
- Private Layer-2 virtual networking
- Stable static addressing for infrastructure services
- Simplified OpenStack multi-node deployment

---

## Network Architecture

```mermaid
graph TD

    ZT[ZeroTier Virtual Network<br/>10.113.163.0/24]

    CTRL[Controller<br/>10.113.163.27]

    C1[Compute1<br/>10.113.163.28]
    C2[Compute2<br/>10.113.163.232]
    C3[Compute3<br/>10.113.163.94]

    ST[Storage & Automation<br/>10.113.163.1]

    ZT --> CTRL

    CTRL -->|OpenStack APIs| C1
    CTRL -->|OpenStack APIs| C2
    CTRL -->|OpenStack APIs| C3

    CTRL -->|Ceph / Automation| ST

    C1 -. Storage Access .-> ST
    C2 -. Storage Access .-> ST
    C3 -. Storage Access .-> ST
```

---

## ZeroTier Network Information

| Parameter | Value |
|---|---|
| Network Technology | ZeroTier SDN |
| Network Type | Overlay Virtual Network |
| Address Space | `10.113.163.0/24` |
| Network ID | `633e31d8a20db0c2` |
| Connectivity | Peer-to-peer encrypted |
| Primary Usage | OpenStack & Kubernetes communication |

---

## Why ZeroTier?

!!! info "Design Choice"
    ZeroTier was selected because it allows all team members to connect their infrastructure nodes securely without requiring enterprise networking hardware or public IP exposure.

### Advantages

- End-to-end encryption
- NAT traversal support
- Simple installation and configuration
- Cross-platform compatibility
- Centralized network management
- Low operational overhead

---

## Node Communication Model

```mermaid
flowchart LR

    Controller --> Compute1
    Controller --> Compute2
    Controller --> Compute3

    Storage --> Controller

    Compute1 --> Storage
    Compute2 --> Storage
    Compute3 --> Storage
```

---

## Installation Procedure

### Install ZeroTier

```bash
curl -s https://install.zerotier.com | sudo bash
```

### Join Network

```bash
sudo zerotier-cli join 633e31d8a20db0c2
```

### Verify Connection

```bash
sudo zerotier-cli listnetworks
```

### Test Connectivity

```bash
ping -c 4 10.113.163.27
```

---

## Security Considerations

!!! warning "Access Control"
    Only authorized members are allowed to join the ZeroTier network.

### Security Measures

- Network membership approval required
- Encrypted peer-to-peer communication
- Static internal IP assignment
- Isolated infrastructure traffic
- No direct public exposure of nodes

---

## Expected Connectivity

Each node must be able to:

- Ping all other nodes
- Resolve hostnames through `/etc/hosts`
- Access OpenStack APIs
- Reach Kubernetes services
- Access shared storage resources

---

## Verification Checklist

- [ ] ZeroTier installed successfully
- [ ] Joined correct network
- [ ] Correct static IP assigned
- [ ] Controller reachable
- [ ] All peers visible
- [ ] Stable latency between nodes

---

## Related Pages

- [IP Assignment](ip-assignment.md)
- [Connectivity Matrix](connectivity-matrix.md)
- [High-Level Architecture](../02-architecture/high-level-architecture.md)