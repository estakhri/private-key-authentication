$puttyPath = "$env:ProgramFiles\PuTTY"
$plink = "$puttyPath\plink.exe"
$pscp = "$puttyPath\pscp.exe"

function Install-Putty {
    Write-Host "Downloading and installing PuTTY..."
    $url = "https://the.earth.li/~sgtatham/putty/latest/w64/putty-64bit-installer.msi"
    $installer = "$env:TEMP\putty-installer.msi"
    Invoke-WebRequest $url -OutFile $installer
    Start-Process msiexec.exe -Wait -ArgumentList "/i `"$installer`" /qn"
    Remove-Item $installer
}

function Ensure-PuttyPath {
    if (-Not ($env:Path -like "*$puttyPath*")) {
        [Environment]::SetEnvironmentVariable("Path", $env:Path + ";$puttyPath", [EnvironmentVariableTarget]::Machine)
        $env:Path += ";$puttyPath"
        Write-Host "Added PuTTY path to system PATH. Please restart your terminal if commands are still not recognized."
    }
}

if (-Not (Test-Path $plink) -or -Not (Test-Path $pscp)) {
    Install-Putty
}
Ensure-PuttyPath

$Server = Read-Host "Enter server address (e.g. 192.168.1.100)"
$User = Read-Host "Enter username"
$Password = Read-Host "Enter password" -AsSecureString
$PlainPassword = [System.Net.NetworkCredential]::new("", $Password).Password

$KeyPath = "$env:USERPROFILE\.ssh\id_rsa"
if (-Not (Test-Path "$KeyPath")) {
    Write-Output "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -f $KeyPath -N ""
}

Write-Output "Copying public key to server..."
cmd /c "echo y | pscp -pw $PlainPassword $KeyPath.pub $User@$Server:/tmp/tempkey.pub"

Write-Output "Setting up SSH key and disabling password login..."
$ScriptBlock = @"
mkdir -p ~/.ssh
cat /tmp/tempkey.pub >> ~/.ssh/authorized_keys
rm /tmp/tempkey.pub
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd || sudo service ssh restart
"@

& $plink -ssh $User@$Server -pw $PlainPassword $ScriptBlock

Write-Host ""
Write-Host "✅ SSH key setup complete and password authentication disabled."
Write-Host "🔐 Your private key is located at: $KeyPath"
