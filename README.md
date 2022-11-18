# Powershell-VistA-CPRS

Powershell script to download, extract, install and configure VistA CPRS client application

# Execution

Open VSCode Studio and and open a new folder.

Select a **Clone Git Repository...** and enter **https://github.com/RamSailopal/Powershell-VistA-CPRS.git**

Once cloned, type "Powershell" on the search bar (bottom right of desktop) Select **Run as administrator**

    Set-Location <location of cloned directory>
    
    .\install.ps1
    
# Additional paramters

When running the command as above, the IP address **127.0.0.1** will be used along with the port of **9430**

To run with specific a specific IP address and port, run with:

    .\install.ps1 -ip 192.168.240.21 -port 5987

