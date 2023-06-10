# Rclone
### _Personal configuration_ 

[![N|Solid](https://avatars.githubusercontent.com/u/24937341?s=200&v=4=100x100)](https://rclone.org/)

[Rclone website](https://rclone.org/)

**Note**: this setup was done in June 2023, maybe the configuration changed a bit since

## Introduction

### About rclone

Rclone is a command-line program to manage files on cloud storage. It is a feature-rich alternative to cloud vendors' web storage interfaces. Over 40 cloud storage products support rclone, including S3 object stores, business & consumer file storage services, as well as standard transfer protocols.

### What can rclone do for you?

Rclone helps you:

- Backup (and encrypt) files to cloud storage
- Restore (and decrypt) files from cloud storage
- Mirror cloud data to other cloud services or locally
- Migrate data to the cloud or between cloud storage vendors
- Mount multiple, encrypted, cached or diverse cloud storage as a disk
- Analyze and account for data held on cloud storage using lsf, ljson, size, ncdu
- Union file systems together to present multiple local and/or cloud file systems as one

## Download & Installation
[Docs](https://rclone.org/downloads/)
```
sudo -v ; curl https://rclone.org/install.sh | sudo bash
```

## Configuration

General logic:
```sh
rclone config
```
* Click "n) New remote"
    * name> onedrive # whatever name you want to give it
* Choose a number from below, or type in your own value
    * 31 (whatever cloud you are trying to set up)

It will then request different information based on whatever number you have selected. Every cloud storage might need some kind of pre-configuration. Below I add the ones I use:

### OneDrive

[configuration](https://rclone.org/onedrive/)

**[Azure App Registration](https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade)**

1. Go to [myApps](https://account.live.com/consent/Manage?fn=email)
2. Click New registration
3. Name: rclone
4. Select: Accounts in any organizational directory (Any Azure AD directory - Multitenant) and personal Microsoft accounts (e.g. Skype, Xbox)
5. Select a platform: Web -> http://localhost:53682/
6. At this poin you should have the client secret and id. Put those two values (client id and client secret) in the terminal when prompted to do so
7. Select "1 Microsoft Cloud Global \ (global)"
8. Then select the defaults: (first No and Yes)
9. Select "1 OneDrive Personal or Business \ (onedrive)"
10. When prompted "Choose a number from below, or type in your own string value." press ENTER
11. Press "1 /  (personal) \ (fbf51fef41b55155)" then “Yes” (y)
 
At this point you should see **“Configuration complete.”**. Then it will ask you "Keep this "onedrive" remote?" press "y) Yes, this is OK (default)". After this, you can quit by pressing "q"

Go back to the API (myApps) site and give the necessary permissions:
1. Under manage select API permissions, click Add a permission and select Microsoft Graph then select delegated permissions.
2. Search and select the following permissions: Files.Read, Files.ReadWrite, Files.Read.All, Files.ReadWrite.All, offline_access, User.Read and Sites.Read.All (if custom access scopes are configured, select the permissions accordingly). Once selected click Add permissions at the bottom.

![OneDrive](https://github.com/DSJourney/configurations/blob/main/1.%20rclone/img/0.%20OneDrive%20API%20Permissions.png?raw=true)

To check if it has connected correctly write this in the terminal
```
rclone lsd "onedrive:" # lsd is for listing directories, ls for files
```

### Google Drive
How to make your own Google Drive Client ID for rclone – [steps](https://rclone.org/drive/#making-your-own-client-id)

1. New Project (rclone-388507)
2. Go to ENABLE APIS AND SERVICES
![GD](https://github.com/DSJourney/configurations/blob/main/1.%20rclone/img/1.%20GD%20Enable%20APIS%20and%20Services.png?raw=true)
3. Select Google Drive API and Enable it
![GD](https://github.com/DSJourney/configurations/blob/main/1.%20rclone/img/2.%20GD%20API.png?raw=true)
4. Click "Credentials" in the left-side panel (not "Create credentials", which opens the wizard), then "Create credentials"
5. If you already configured an "Oauth Consent Screen", then skip to the next step; if not, click on "CONFIGURE CONSENT SCREEN" button (near the top right corner of the right panel), then select "External" and click on "CREATE"; on the next screen, enter an "Application name" ("rclone" is OK);
![GD](https://github.com/DSJourney/configurations/blob/main/1.%20rclone/img/3.%20GD%20Auth%20Consent.png?raw=true)
6. Add your app name: “rclone” and email address (personal one)
7. Add scope, [here](https://developers.google.com/drive/api/guides/api-specific-auth) is a list. The ones I added are:

| Category          | Selection                   | Description                                                            |
| ----------------- | --------------------------- | ---------------------------------------------------------------------- |
| Google Drive API  | .../auth/drive.appdata      | See, create and delete its own configuration data in your Google Drive  |
| Google Drive API  | .../auth/drive.file         | See, edit, create and delete only the specific Google Drive files that you use with this app |
| Google Drive API  | .../auth/drive.install      | Connect itself to your Google Drive                                    |
| Google Drive API  | .../auth/docs               | See, edit, create and delete all of your Google Drive files             |
| Google Drive API  | .../auth/drive              | See, edit, create and delete all of your Google Drive files             |
| Google Drive API  | .../auth/drive.metadata.readonly | See information about your Google Drive files                      |

8. Be sure to add your own account to the test users. Once you've added yourself as a test user and saved the changes, click again on "Credentials" on the left panel to go back to the "Credentials" screen.
9. Click on the "+ CREATE CREDENTIALS" button at the top of the screen, then select "OAuth client ID".
10. Choose an application type of "Desktop app" and click "Create". (the default name is fine)
11.	Go to "Oauth consent screen" and then click "PUBLISH APP" button and confirm. You will also want to add yourself as a test user.
12.	Provide the noted client ID and client secret to rclone. In the terminal then press
    * 1 / Full access all files, excluding Application Data Folder. \ (drive)
    * service_account_file (leave empty)
    * Edit advanced config? No
    * Use web browser to automatically authenticate rclone with remote? [code]Yes. **Important** Here you will be told that “Google hasn’t verified this app”. Press “advanced” and accept the risk using rclone.
    * Configure this as a Shared Drive (Team Drive)? No (not sure about this)
    * Keep this "gdrive" remote? Yes

At this point it should be ready. To check if it worked well do like with OneDrive

```
rclone lsd “gdrive:”
```
### DropBox
Pending

### Synology
We will do the same we did for our local computer but from the shell of the Synology NAS. However, there are some necessary
pre-configuration steps we need to take:
1. [Allow SSH on your Synology](https://mariushosting.com/how-to-ssh-into-a-synology-nas/#:~:text=Or%2C%20if%20you%20are%20a,port%2022%20then%20click%20Apply.) (change the port to something between 49152 and 65535.)

![NAS](https://github.com/DSJourney/configurations/blob/main/1.%20rclone/img/4.%20NAS%20enable%20SSH.png?raw=true)

2. [Find your IP address](https://www.youtube.com/watch?v=i4xpYLASZ9U) in the control panel

![NAS](https://github.com/DSJourney/configurations/blob/main/1.%20rclone/img/5.%20NAS%20IP%20address.png?raw=true)

3. Enable user home service (then hit apply)

![NAS](https://github.com/DSJourney/configurations/blob/main/1.%20rclone/img/6.%20NAS%20enable%20home%20service.png?raw=true)

4. Install Nano (enable Synology Inc and Trusted Publishers)

![NAS](https://github.com/DSJourney/configurations/blob/main/1.%20rclone/img/7.%20NAS%20Packages%20Trusted%20Publishers.png?raw=true)

5. Install Syno Community

![NAS](https://github.com/DSJourney/configurations/blob/main/1.%20rclone/img/8.%20NAS%20Syno%20Community.png?raw=true)

6. Install SynoCli File Tools 

The next steps I found them here [Spanish Tutorial](https://bitnarios.com/guia-definitiva-rclone-como-instalar-configurar-y-sincronizarlo-con-google-drive-en-synology/) and [English tutorial](https://github.com/ravem/synology-pcloud-and-rclone)

1. Connect to your NAS with SSH
```
ssh loseycaves@myNASip -p22 (or whatever port number)
```
2. Gain admin rights
```
sudo -i # Then add the password
```
3. Download rclone
```
wget https://rclone.org/install.sh
```
4. Set permissions to make the file executable
```
chmod +x install.sh
```
5. Install rclone
```
./install.sh
```
6. Exit root user
```
exit
```
