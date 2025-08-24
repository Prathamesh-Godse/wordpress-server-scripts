# WordPress Server Scripts

## ⚠️ Warning: Project Under Active Development

This project is **not yet complete** and should be considered pre-release software. The scripts are being actively developed and tested. Do not use this on a production server.

## 1. What is this for?

This project provides a set of automation scripts to provision and secure a Ubuntu server for hosting WordPress. It translates the detailed manual steps from the [Secure-WordPress-Server](https://github.com/Prathamesh-Godse/Secure-WordPress-Server) guide into executable Bash scripts.

## 2. Prerequisites

*   A **local machine** (Linux/macOS) with Bash and SSH.
*   A **fresh remote VPS** (Ubuntu 22.04/20.04) with root SSH access.
*   A domain name pointed to your VPS's IP address.

## 3. Quick Start

The automation is designed to be run from your **local machine**. The local controller script will securely connect to your remote server, transfer the necessary scripts, and execute them.

1.  **Clone this repo locally:**
    ```bash
    git clone https://github.com/Prathamesh-Godse/wordpress-server-scripts.git
    cd wordpress-server-scripts
    ```

2.  **Run the main local controller script:**
    This script will handle the entire deployment to the remote server.
    ```bash
    ./main.sh
    ```
    
## 4. Detailed Documentation

For a complete explanation of each security and optimization step performed by these scripts, please refer to the original manual guide:
**[Secure-WordPress-Server Repository](https://github.com/Prathamesh-Godse/Secure-WordPress-Server)**

## 5. Contributing

We welcome contributions! If you'd like to help complete this automation project, please read our guidelines first:
**[CONTRIBUTING.md](CONTRIBUTING.md)**

## 6. Disclaimer

These scripts are provided **AS IS**, without warranty of any kind. Use at your own risk. The authors are not responsible for any downtime, data loss, or security breaches resulting from the use of this software. Always test in a staging environment first.

## 7. License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
