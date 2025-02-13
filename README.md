Setup Instructions
1. Prerequisites
Ensure the following are in place:
A working Zabbix Server (v7.0 or higher).
A Windows Server acting as an Active Directory Domain Controller.
Zabbix Agent installed on the domain controller.
2. Configure the Domain Controller
To enable monitoring of Active Directory events, follow these steps:
a) Enable Auditing Policies
Open gpedit.msc on the domain controller.
Navigate to:
```
Computer Configuration → Policies → Windows Settings → Security Settings → Advanced Audit Policy Configuration → Audit Policies → Account Management
```
Enable the following policies:
```
Audit User Account Management (Success/Failure).
Audit Security Group Management (Success/Failure).
```
Update Group Policy:
```
gpupdate /force
```
b) Grant Event Log Access to Zabbix Agent
Ensure the Zabbix Agent service runs under a domain account with access to Event Logs.
Add the service account to the Event Log Readers group:
```
net localgroup "Event Log Readers" /add <ZABBIX_AGENT_ACCOUNT>
```
Modify registry permissions for Security Event Logs:
```
reg add "HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security" /v RestrictGuestAccess /t REG_DWORD /d 0 /f
```
3. Install and Configure Zabbix Agent
Download and install the latest Zabbix Agent from Zabbix Downloads.
Update the zabbix_agent2.conf file with the following parameters:
```
Server=<ZABBIX_SERVER_IP>
ServerActive=<ZABBIX_SERVER_IP>:31051
Hostname=<DOMAIN_CONTROLLER_HOSTNAME>
HostMetadata=Windows_AD_Monitoring
```
Add custom UserParameters for PowerShell scripts:
```
UserParameter=ad.new_user.details,powershell -ExecutionPolicy Bypass -File "C:\zabbix_scripts\check_new_ad_user_details.ps1"
UserParameter=ad.password_change.details,powershell -ExecutionPolicy Bypass -File "C:\zabbix_scripts\check_password_change_details.ps1"
UserParameter=ad.group_membership.details,powershell -ExecutionPolicy Bypass -File "C:\zabbix_scripts\check_group_membership_change_details.ps1"
```
Restart the Zabbix Agent service:
```
net stop zabbix_agent2 && net start zabbix_agent2
```
4. Deploy PowerShell Scripts
Copy the PowerShell scripts from this repository (scripts/) to C:\zabbix_scripts on the domain controller.
Ensure the directory has appropriate permissions for the Zabbix Agent service account.
5. Import Template into Zabbix
Go to Configuration → Templates in your Zabbix web interface.
Click Import and upload templates/template_ad_events_monitoring.yaml.
Assign this template to your domain controller host.
6. Verify Setup
Trigger an event in Active Directory (e.g., create a test user).
Check if data appears in Monitoring → Latest Data for your host.
Ensure triggers are firing correctly in Monitoring → Problems.
