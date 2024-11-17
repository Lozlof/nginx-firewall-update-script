# Loz Nginx Simple Firewall Update  Script      
``loznfwu.sh``    
### How to configure Loz Nginx Simple Firewall Update Script      
#### 1. Create the configuration file.       
The IP's listed in this file will be given allow statements in the location / block(s) of the listed Nginx configuration file(s).        
**Example: config.conf**   
```  
192.168.0.96  
192.168.0.97  
/etc/nginx/sites-available/siteone.com.conf  
/etc/nginx/sites-available/sitetwo.com.conf  
```   
#### 2. Add configuration file path to the script   
``CONFIG_FILE="/your/path/config.conf"``   
#### 3. (Optional) Remove sudo.   
Depending on how you are executing the script, leave sudo in or take it out.    
### Loz Nginx Simple Firewall Update Script Logic    
- Backup original Nginx configuration in the same directory.   
- Remove existing allow rules.    
- Keeps existing deny rule(s) or writes new deny rule(s).    
- Inserts the IP's with allow statements above the deny all line.     
- Executes above for each Nginx configuration file.    
- Reloads Nginx to apply the changes.     
## Contact: lozlofcyber@gmail.com    
