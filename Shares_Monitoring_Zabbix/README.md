1. Overview

This project enables monitoring of unauthorized access to a shared folder of your choise on a Windows Server using Zabbix Agent 2 and openfiles command.
It detects when a user accesses the folder and sends an alert to Zabbix Server (v7.0 or higher).


2. Prerequisites

Ensure the following are in place:
✔ A working Zabbix Server (v7.0 or higher).
✔ A Windows Server with shared folders.
✔ Zabbix Agent 2 installed on the Windows Server.


3. Configure the Windows Server

a) Enable Open Files Feature (Required for openfiles /query)
  - Open Command Prompt as Administrator.
  - Run the following command to enable remote file tracking:
  ```
  openfiles /enable
  ```
  - Restart the server for changes to take effect.

b) Ensure Zabbix Agent Has Necessary Permissions
Zabbix Agent must run as Administrator to execute openfiles.

  - Open Services (services.msc).
  - Locate Zabbix Agent 2 service.
  - Right-click → Properties → Go to Log On tab.
  - Select This account and provide Administrator credentials.
  - Click Apply, then Restart the service.


4. Install and Configure Zabbix Agent

a) Update zabbix_agent2.conf.

b) Add shares_monitoring.conf from this repository to your plugins.d directory.


5. Deploy PowerShell Script

a) Copy the PowerShell script (monitor_openfiles.ps1) from this repository.

b) Ensure the script has execute permissions for Zabbix Agent.


6. Import Zabbix Template

a) Open Zabbix Web Interface.

b) Go to Configuration → Templates.

c) Click Import and select template_openfiles_monitoring.xml from this repository.

d) Assign this template to the monitored Windows Server host.  
