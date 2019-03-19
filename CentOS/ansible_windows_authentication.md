# Windows Authentication
[Source](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#authentication-options)

## Setup
```yaml
- Ansible Controller:
  server: awx.domainlocal
  
- Client:
  server: win2019.domainlocal
  admin: Administrator
  password: Guac-doge42!
```


## Authenticate by Certificate
### (Windows) Allow certificate sign in
```powershell
Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
```

### (Windows) Generate Certificate on windows client
```powershell
# set the name of the local user that will have the key mapped
$username = "Administrator"
$output_path = "C:\temp"
if(!(Test-Path $output_path)){
    New-Item -Path $output_path -ItemType Directory
}

# instead of generating a file, the cert will be added to the personal
# LocalComputer folder in the certificate store
$cert = New-SelfSignedCertificate -Type Custom `
    -Subject "CN=$username" `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2","2.5.29.17={text}upn=$username@localhost") `
    -KeyUsage DigitalSignature,KeyEncipherment `
    -KeyAlgorithm RSA `
    -KeyLength 2048

# export the public key
$pem_output = @()
$pem_output += "-----BEGIN CERTIFICATE-----"
$pem_output += [System.Convert]::ToBase64String($cert.RawData) -replace ".{64}", "$&`n"
$pem_output += "-----END CERTIFICATE-----"
[System.IO.File]::WriteAllLines("$output_path\cert.pem", $pem_output)

# export the private key in a PFX file
[System.IO.File]::WriteAllBytes("$output_path\cert.pfx", $cert.Export("Pfx"))
```

### (Windows) Import the generated Certificate as Trusted Root Certification Authority
```powershell
$cert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2
$cert.Import("C:\temp\cert.pem")

$store_name = [System.Security.Cryptography.X509Certificates.StoreName]::Root
$store_location = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
$store = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $store_name, $store_location
$store.Open("MaxAllowed")
$store.Add($cert)
$store.Close()
```

### (Windows) Import the generated Certificate as Trusted Person
```powershell
$cert = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2
$cert.Import("C:\temp\cert.pem")

$store_name = [System.Security.Cryptography.X509Certificates.StoreName]::TrustedPeople
$store_location = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
$store = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $store_name, $store_location
$store.Open("MaxAllowed")
$store.Add($cert)
$store.Close()
```

The certificate will be added under LocalMachine/TrustedPeople.

### (Windows) Map certificate to user
> The Ansible documentation points to the wrong cert folder!
```powershell
$username = "Administrator"
$password = ConvertTo-SecureString -String "Guac-doge42!" -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $password

# this is the issuer thumbprint which in the case of a self generated cert
# is the public key thumbprint, additional logic may be required for other
# scenarios
$thumbprint = (Get-ChildItem -Path cert:\LocalMachine\root | Where-Object { $_.Subject -eq "CN=$username" }).Thumbprint

New-Item -Path WSMan:\localhost\ClientCertificate `
    -Subject "$username@localhost" `
    -URI * `
    -Issuer $thumbprint `
    -Credential $credential `
    -Force
```

### (Ansible) Extract the private key
- Copy the .pfx and .pem files over from the Windows machine to the Ansible server (to ~/Downloads)
- Create a private key file (cert_key.pem)
  ```bash
  cd ~/Downloads
  openssl pkcs12 -in cert.pfx -nocerts -nodes -out cert_key.pem -passin pass: -passout pass:
  ```
  
### Edit the connection variables to point to public and private key
```bash
cd /etc/ansible/group_vars/windows/
sudo vi vars
```
Change the contents to this:
```yaml
---
ansible_connection: winrm
ansible_winrm_cert_pem: /home/<user>/Downloads/cert.pem
ansible_winrm_cert_key_pem: /home/<user>/Downloads/cert_key.pem
ansible_winrm_transport: certificate
ansible_winrm_server_cert_validation: ignore
```

### Test:
```bash
ansible windows -m win_ping --ask-vault-pass
```

## Kerberos Authentication
[Source](https://docs.ansible.com/ansible/latest/user_guide/windows_winrm.html#id9)

### Setup
The setup is the same as the main setup, only from hereon I'll have ADDS installed on the Windows machine, and promoted it to the sole DC for `dwrolvink.com` domain. I then made a new user, `dorus@dwrolvink.com` and gave it administrative access.

### (Windows) Setup DNS Reverse Lookup
I noticed that reverse lookup zones are not automatically installed, but we need this for Kerberos to work.

- Open DNS Manager
- Rightclick Reverse Lookup Zones > New Zone
- Use default settings, except for `Network ID: 192.168.178` (the IP of my win2019 machine is 192.168.178.107)
- Open the newly created reverse lookup zone, and add a PTR record: `Host Ip Address: 192.168.178.107; Hostname: win2019.dwrolvink.com`

### (Ansible) Test reverse lookup zone
Do `nslookup 192.168.178.107`. Before I set up the reverse lookup zone the result was `win2019.[router dns zone]`. After setting up the reverse lookup zone it returned the correct value: `win2019.dwrolvink.com`.

### (Ansible) Install Krb5 support
```bash
sudo yum -y install python-devel krb5-devel krb5-libs krb5-workstation
sudo yum -y install gcc
sudo pip install pywinrm[kerberos]
```

### (Ansible) Setup Krb configuration
Open `/etc/ansible/windows/vars` And change the contents to something like this:
```yaml
---
ansible_user: dorus@DWROLVINK.COM
ansible_password: Felixsk#3
ansible_connection: winrm
ansible_winrm_transport: kerberos
ansible_winrm_server_cert_validation: ignore
```
> Note: Proper Capitalization is a pretty big deal

Open `/etc/krb5.conf` and under `[realm]`, make sure it looks like the following:
```ini
[realms]
 DWROLVINK.COM = {
  kdc = win2019.dwrolvink.com
  admin_server = win2019.dwrolvink.com
 }

[domain_realm]
 .dwrolvink.com = DWROLVINK.COM
```
