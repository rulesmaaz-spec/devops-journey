#  Day 33 – EC2 User Data Script for Task Manager Deployment

> **Author:** Mohammad Maaz  
> **Purpose:** Automate Docker + Task Manager deployment on a fresh EC2 instance

---

##  What This Script Does

This is a **bash user-data script** that runs automatically when an EC2 instance launches for the first time. 

What it do:
1. Updates system packages (`apt update && apt upgrade`)
2. Installs:
   - `docker.io` – Docker Engine (from Ubuntu repos)
   - `docker-compose-plugin` – modern Docker Compose v2
   - `git` – version control
3. Clones the **Task Manager Docker** repository from GitHub
4. Navigates into the project folder
5. Starts the application with `docker compose up -d`
6. Enables Docker to start on boot

After the script completes, the instance is ready to serve the task manager app **without any manual SSH intervention**.

---

##  Why this matters in AWS

### Real‑World deployment pattern

In production, you never SSH into a server and type commands manually. Instead:

- You **launch an EC2 instance** with this script in the **User Data** field
- AWS runs the script **automatically** during first boot
- The instance **provisions itself** (installs Docker, clones code, starts containers)
- This is called **bootstrap automation** and is the foundation of **Infrastructure as Code (IaC)**

### where it fits
Launch EC2
            ↓
User Data Script Executes (this file)
            ↓
Docker + Compose Installed
            ↓
Application Cloned & Started
            ↓
Instance Ready for Traffic 

### How to use this in AWS

    Open the EC2 Dashboard → Launch Instance

    In Advanced details → User data, paste this script

    Choose an Ubuntu 24.04 AMI, a key pair, and a security group with ports 22 and 5000 open

    Launch the instance

    Wait 2–3 minutes, then access:
      (http://<public-ip>:5000)

    The Task Manager app will be live

### Security Notes

    The script runs as root during first boot only

    No secrets are hard‑coded (real projects use AWS Secrets Manager or environment variables)

    The Security Group should be locked down to your IP

    Docker runs with default root privileges – in production, use a dedicated non‑root user (as shown in my Dockerfiles)

### What I Learned

    How to write EC2 user-data scripts

    Package managers and their conflicts in cloud environments

    The importance of official repositories vs distro packages

    How to automate server provisioning without manual SSH

    The difference between “install Docker” and “configure Docker securely”
What I Learned

    How to write EC2 user-data scripts

    Package managers and their conflicts in cloud environments

    The importance of official repositories vs distro packages

    How to automate server provisioning without manual SSH

    The difference between “install Docker” and “configure Docker securely”
