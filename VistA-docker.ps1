#
#   Check to see if Docker is installed. If not, download and install Docker Desktop for Windows. Then pull and run VistA EHR image in container
#
param ([String] $action="install")
if ($action.ToUpper() -eq "RESTART") {
    try {
        $contid=""
        $fnd=0
        Get-Process | ForEach-Object { 
            if ( $_.Name  -eq "Docker Desktop" ) { 
                $fnd=1 
            } 
        }
        if ($fnd -eq 0 ) {
            Write-Host -ForegroundColor Red "Docker Desktop is not running. Starting now ..."
            & '~\Desktop\Docker Desktop.lnk'
            Start-Sleep 60
        }
        if (docker ps -a --format "{{.Names}}" | Select-String "wv") { 
            docker ps -a | Select-String "wv" | ForEach-Object { 
                $bits=$_.toString().split(" ")
                if ($bits[0] -notmatch "CONTAINER") { 
                    $contid = $bits[0] 
                } 
                docker rm -f $contid | Out-Null
                docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr | Out-Null
                Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
                exit
            }
        }
        if ($contid -eq "") {
            $ans3 = Read-Host -Prompt "There was an error recreating the VistA EHR container. Do you wish to create one now? (Y/N)"
            if ($ans3.ToUpper() -eq "Y") {
                docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr | Out-Null
                Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
                exit
            }
        }
    }
    catch {
        Write-Host -ForegroundColor Red "There was an error recreating the VistA EHR container"
    }
    exit
}
elseif ($action.ToUpper() -eq "STOP") {
    try {
        $contid=""
        if (docker ps -a --format "{{.Names}}" | Select-String "wv") { 
            docker ps -a | Select-String "wv" | ForEach-Object { 
                $bits=$_.toString().split(" ")
                if ($bits[0] -notmatch "CONTAINER") { 
                    $contid = $bits[0] 
                } 
                docker rm -f $contid | Out-Null
                Write-Host -ForegroundColor green "VistA EHR is stopped and container removed"
                exit
            }
        }
        if ($contid -eq "") {
            Write-Host -ForegroundColor Green "The VistA EHR container is not running"
        }
    }
    catch {
        Write-Host -ForegroundColor Red "There was an error recreating the VistA EHR container"
    }
    exit
}
elseif ($action.ToUpper() -eq "START") {
    try {
        $contid=""
        $fnd=0
        Get-Process | ForEach-Object { 
            if ( $_.Name  -eq "Docker Desktop" ) { 
                $fnd=1 
            } 
        }
        if ($fnd -eq 0 ) {
            Write-Host -ForegroundColor Red "Docker Desktop is not running. Starting now ..."
            & '~\Desktop\Docker Desktop.lnk'
            Start-Sleep 60
        }
        if (docker ps -a --format "{{.Names}}" | Select-String "wv" ) { 
            docker ps -a | Select-String "wv" | ForEach-Object { 
                $bits=$_.toString().split(" ")
                if ($bits[0] -notmatch "CONTAINER") { 
                    $contid = $bits[0] 
                } 
            }
        }
        if ($fnd -eq 0 ) {
            docker rm -f $contid | Out-Null
            docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr | Out-Null
            Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
            exit
        }
        elseif ($contid -eq "") {
            docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr | Out-Null
            Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
            exit
        }
        else {
            Write-Host -ForegroundColor Green "The VistA EHR container is already running"
        }
    }
    catch {
        Write-Host -ForegroundColor Red "There was an error recreating the VistA EHR container"
    }
    exit
}
elseif ($action.ToUpper() -eq "STATUS") {
    try {
        $contid=""
        if (docker ps -a --format "{{.Names}}" | Select-String "wv") { 
            docker ps -a | Select-String "wv" | ForEach-Object { 
                $bits=$_.toString().split(" ")
                if ($bits[0] -notmatch "CONTAINER") { 
                    $contid = $bits[0] 
                } 
            }
        }
        if ($contid -eq "") {
            Write-Host -ForegroundColor Green "The VistA EHR container is not running"
            exit
        }
        else {
            $contdet = docker ps -a --format "{{.ID}}:{{.RunningFor}}" | ForEach-Object {
                $contdetsp = $_.split(":")
                $runfor = $contdetsp[1]
            }
            Write-Host -ForegroundColor Green "The VistA EHR container has been running since $runfor"
            exit
        }
    }
    catch {
        Write-Host -ForegroundColor Red "There was an error recreating the VistA EHR container"
    }
    exit
}
elseif ($action.ToUpper() -eq "NOINT-INSTALL") {
    try {
        docker version | Out-Null
        Write-Host -ForegroundColor green "Docker Desktop already installed"
        if (docker ps -a --format "{{.Names}}" | Select-String "wv") {
                docker ps -a | Select-String "wv" | ForEach-Object { 
                    $bits=$_.toString().split(" ")
                    if ($bits[0] -notmatch "CONTAINER") { 
                        $contid = $bits[0] 
                    } 
                }
                docker rm -f $contid | Out-Null
                docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr | Out-Null
                Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
                exit
        }
        docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr | Out-Null
        Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
        exit
    }
    catch {
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
            Start-Sleep 60
            Write-Host -ForegroundColor green "Running VistA EHR in Docker"
            docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr | Out-Null
            Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
        }
        catch {
            Write-Host -ForegroundColor red "Issue running Docker Desktop Install"
        }
    }
}
try {
    docker version | Out-Null
    Write-Host -ForegroundColor green "Docker Desktop already installed"
    $ans=Read-Host -Prompt "Would you like to run VistA EHR in Docker? (Y/N)"
    if ($ans.ToUpper() -eq "Y") {
        if (docker ps -a --format "{{.Names}}" | Select-String "wv") {
            $ans2=Read-Host -Prompt "Would you like to remove the existing and recreate a container running VistA EHR? (Y/N)"
            if ( $ans2.ToUpper() -eq "Y") {
                docker ps -a | Select-String "wv" | ForEach-Object { 
                    $bits=$_.toString().split(" ")
                    if ($bits[0] -notmatch "CONTAINER") { 
                        $contid = $bits[0] 
                    } 
                }
                docker rm -f $contid | Out-Null
                docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr | Out-Null
                Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
                exit
            }
        }
        docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr | Out-Null
        Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
        exit
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
            Start-Sleep 60
            Write-Host -ForegroundColor green "Running VistA EHR in Docker"
            docker run -d -p 2222:22 -p 8001:8001 -p 8080:8080 -p 9430:9430 -p 9080:9080 --name=wv worldvista/worldvista-ehr | Out-Null
            Write-Host -ForegroundColor green "VistA EHR is now running in Docker. Use the install.ps1 script to install the client CPRS software if needed"
        }
        catch {
            Write-Host -ForegroundColor red "Issue running Docker Desktop Install"
        }
    }
}
