#  High‑Availability Architecture – AWS

---

##  Architecture Overview

- **Application Load Balancer (ALB)** – receives all incoming traffic  
- **Web servers (EC2)** – running in **two Availability Zones** (AZ‑a and AZ‑b)  
- **Database (RDS)** – Multi‑AZ deployment (primary in AZ‑a, standby in AZ‑b)  
- **Amazon S3** – stores static assets (images, CSS, etc.)

---

##  Why Two Availability Zones?

- An **Availability Zone** is a physically separate data centre inside an AWS region.  
- If we put everything in **one AZ**, a power outage, cooling failure, or network disruption could take down the **entire application**.  
- Using **two AZs** means that even a **catastrophic failure of one AZ** does **not** bring the app offline – the other AZ keeps serving users.  
- This is the foundation of **High Availability (HA)** and is a standard practice for production workloads.

---

##  What Happens If One AZ Fails?

###  AZ‑a goes down completely

1. **Load Balancer** – detects that EC2 instances in AZ‑a are not responding to health checks. It automatically **stops sending traffic** to those instances.  
2. **Web traffic** – all new requests are routed to the healthy EC2 instances in **AZ‑b**. Users may experience a few seconds of delay, but the app remains available.  
3. **Database (RDS)** – Multi‑AZ detects the failure and performs an **automatic failover**. The standby database in AZ‑b becomes the new primary.  
   - The connection string (CNAME) stays the same; the application does not need to change anything.  
   - Downtime during failover is typically **1–2 minutes**.  
4. **Static assets (S3)** – S3 is inherently **region‑resilient**; it is not affected by a single AZ failure.  

###  AZ‑a recovers later

- New EC2 instances can be launched and added back to the load balancer target group.  
- RDS will provision a new standby in the now‑healthy AZ automatically (if configured).

---

##  How Does the Load Balancer Handle It?

- The ALB **continuously sends health checks** to every registered EC2 instance (e.g., a request to `/health` every 30 seconds).  
- If an instance responds with `200 OK`, it’s considered **healthy** and receives traffic.  
- If an instance fails a configurable number of consecutive health checks (e.g., 3 times), the ALB **removes** that instance from its target group.  
- The ALB **only routes to healthy targets**. When an instance recovers, it’s automatically added back.  
- In the event of a **whole AZ outage**, all instances in that AZ become unhealthy, and traffic is instantly shifted to the remaining AZ.

---

##  Security (S3)

- S3 bucket policies and CloudFront can be added to serve static content securely and quickly.  
- All EC2 instances and the RDS database use **Security Groups** that follow the principle of least privilege.

---

> **“Design for failure – nothing will ever be 100% available, but we can build systems that survive almost anything.”**
