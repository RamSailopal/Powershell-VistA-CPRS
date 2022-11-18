#
#   Check to see if Docker is installed. If not, download and install Docker Desktop for Windows. Then pull and run VistA EHR image in container
#
try {
    docker version
    Write-Host -ForegroundColor green "Docker Desktop already installed"
    $ans=Read-Host -Prompt "Would you like to run VistA EHR in Docker? (Y/N)"
    if ($ans.ToUpper() -eq "Y") {
        if (docker ps -a | Select-String "wv") {
            $ans2=Read-Host -Prompt "Would you like to remove the existing and recreate a container running VistA EHR? (Y/N)"
            if ( $ans2.ToUpper() -eq "Y") {
                docker ps -a | ForEach-Object { 
                    $bits=$_.split(" ")
                    if ($bits[0] -notmatch "CONTAINER") { 
                        $contid = $bits[0] 
                    } 
                }
                docker rm -f $contid
                docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr
                Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
                exit
            }
        }
        docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr
        Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
    }
}
catch {
    $resp = Read-Host "Docker Desktop is not installed. Initiate download and install now? (Y/N)"
    If ( $resp.ToUpper() -eq "Y") {
        Write-Host -ForegroundColor green "Downloading ..."
        try {
            Invoke-WebRequest 'https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe' -OutFile ~/Downloads/DockerInstall.exe
        }
        catch {
            Write-Host -ForegroundColor red "Issue downloading Docker Desktop for Windows"
        }
        try {
            & ~\Downloads\DockerInstall.exe
            Write-Host -ForegroundColor green "Please follow screen option to continue"
            Write-Host -ForegroundColor green "Running Docker Desktop"
            & '~\Docker Desktop.lnk'
            Write-Host -ForegroundColor green "Running VistA EHR in Docker"
            docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr
            Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
        }
        catch {
            Write-Host -ForegroundColor red "Issue running Docker Desktop Install"
        }
    }
}