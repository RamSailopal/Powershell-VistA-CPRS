# Powershell-VistA-CPRS

![Alt text](CPRS.JPG?raw=true "view")

Powershell script to download, extract, install and configure VistA CPRS client application as well as downloading Docker Desktop for Windows and pulling/running the VistA EHR image

# Docker Desktop/VistA EHR containers install

## Execution

Open VSCode Studio and and open a new folder.

Select a **Clone Git Repository...** and enter **https://github.com/RamSailopal/Powershell-VistA-CPRS.git**

Once cloned, type "Powershell" on the Windows search bar (bottom right of desktop) Select **Run as administrator** Once the shell is opened, enter:

    Set-Location <location of cloned directory>
    
    .\VistA-docker.ps1
    
With no parameters/flags added, the script will attempt to install the neccesary dependancies and run the VistA EHR container
    
## Additional parameters

The **action** flag will allow the docker container to be created, destroyed. recreated, as well as attaining the status

Accepted values:

**start** - Create the container

**stop** - Destroy the container

**restart** - Recreate the container

**status** - Attain the status of the container

**install** - Install the neccesary dependancies and run the VistA EHR container (default option)

**noint-install** - None interactive install

e.g.

    .\VistA-docker.ps1 -action restart

# Client CPRS install

## Execution

Open VSCode Studio and and open a new folder.

Select a **Clone Git Repository...** and enter **https://github.com/RamSailopal/Powershell-VistA-CPRS.git**

Once cloned, type "Powershell" on the Windows search bar (bottom right of desktop) Select **Run as administrator** Once the shell is opened, enter:

    Set-Location <location of cloned directory>
    
    .\cprs-install.ps1
    
## Additional paramters

When running the command as above, the IP address **127.0.0.1** will be used along with the port of **9430**

To run with specific a specific IP address and port, run with:

    .\cprs-install.ps1 -ip 192.168.240.21 -port 5987


# References

https://en.wikipedia.org/wiki/VistA
