# Component Interaction Design

## Table of Contents
1. [VM Creation Sequence](#1-vm-creation-sequence)
2. [VM Migration Flow](#2-vm-migration-flow)
3. [Auto-scaling Workflow](#3-auto-scaling-workflow)
4. [Authentication Flow](#4-authentication-flow)
5. [Volume Attachment Flow](#5-volume-attachment-flow)
6. [Network Packet Flow](#6-network-packet-flow)
7. [Component Dependencies](#7-component-dependencies)
8. [Error Handling Flows](#8-error-handling-flows)
9. [API Call Flow with Caching](#9-api-call-flow-with-caching)
10. [Interaction Summary Table](#10-interaction-summary-table)

---

## 1. VM Creation Sequence

This diagram shows the complete sequence of events when a user creates a new VM.

```mermaid
sequenceDiagram
    autonumber
    participant User as 👤 User/CLI
    participant Horizon as 🌐 Horizon Dashboard
    participant NovaAPI as 🔧 Nova API
    participant Keystone as 🔑 Keystone
    participant NovaSched as 📊 Nova Scheduler
    participant NovaComp as 💻 Nova Compute
    participant Neutron as 🌍 Neutron Server
    participant NeutronAgent as 🔌 Neutron Agent
    participant Cinder as 💾 Cinder API
    participant CinderVol as 📀 Cinder Volume
    participant Glance as 🖼️ Glance
    participant KVM as ⚡ KVM Hypervisor
    participant MySQL as 🗄️ MariaDB
    
    Note over User,MySQL: VM Creation Request Flow
    
    User->>Horizon: POST /server (create VM)
    activate Horizon
    
    Horizon->>NovaAPI: boot instance request
    activate NovaAPI
    
    NovaAPI->>Keystone: validate token
    activate Keystone
    Keystone->>MySQL: lookup token
    MySQL-->>Keystone: token data
    Keystone-->>NovaAPI: token valid
    deactivate Keystone
    
    NovaAPI->>MySQL: log request
    NovaAPI->>NovaSched: select host
    activate NovaSched
    
    NovaSched->>MySQL: read compute node stats
    MySQL-->>NovaSched: resource availability
    NovaSched-->>NovaAPI: select compute2 (least loaded)
    deactivate NovaSched
    
    NovaAPI->>Glance: GET /images/{image_id}
    activate Glance
    Glance-->>NovaAPI: image metadata + location
    deactivate Glance
    
    NovaAPI->>Neutron: create ports (network interfaces)
    activate Neutron
    Neutron->>MySQL: allocate IP from pool
    MySQL-->>Neutron: IP address assigned
    Neutron-->>NovaAPI: port created with MAC/IP
    deactivate Neutron
    
    alt Volume requested
        NovaAPI->>Cinder: create volume
        activate Cinder
        Cinder->>CinderVol: provision LVM volume
        activate CinderVol
        CinderVol-->>Cinder: volume ready (iSCSI target)
        deactivate CinderVol
        Cinder-->>NovaAPI: volume ID and connection info
        deactivate Cinder
    end
    
    NovaAPI->>NovaComp: spawn instance on compute2
    activate NovaComp
    
    NovaComp->>NeutronAgent: setup networking for VM
    activate NeutronAgent
    NeutronAgent->>Neutron: get network configuration
    Neutron-->>NeutronAgent: VLAN/VXLAN config
    NeutronAgent->>NeutronAgent: create OVS port
    NeutronAgent-->>NovaComp: network ready (tap device)
    deactivate NeutronAgent
    
    NovaComp->>KVM: define VM (libvirt XML)
    activate KVM
    
    KVM->>Glance: download/cache image
    Glance-->>KVM: image stream
    KVM->>KVM: convert to raw if needed
    
    opt Volume attachment
        KVM->>Cinder: attach volume via iSCSI
        Cinder-->>KVM: volume attached as /dev/vdb
    end
    
    KVM->>KVM: create VM disk
    KVM->>KVM: start VM execution
    KVM-->>NovaComp: VM running (vCPU assigned)
    deactivate KVM
    
    NovaComp-->>NovaAPI: instance ID and console URL
    deactivate NovaComp
    
    NovaAPI->>MySQL: update instance status to "ACTIVE"
    NovaAPI-->>Horizon: success response with VM details
    deactivate NovaAPI
    
    Horizon-->>User: VM is running (console link)
    deactivate Horizon
    
    Note over User,MySQL: VM Creation Complete - Total Time ~25 seconds

```