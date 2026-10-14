enable symbolic link creation via "ln -s"
    Settings -> Update & Security -> For Developers -> turn on "Developer Mode"

enable scoop
    PowerShell
        -> ipconfig /flushdns
        -> (run as admin) Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("8.8.8.8","1.1.1.1")
        -> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        -> Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

install lazygit via scoop
    -> scoop bucket add extras
    -> scoop install lazygit
