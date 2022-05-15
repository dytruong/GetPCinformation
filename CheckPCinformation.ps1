#############################################################  
$username = "anv"    
$security_path = "C:\Windows\Temp\passwd.txt"
$pstool_location = "C:\Pstool\psexec.exe"

#############################################################
#Credential handling
function Save_credential{
    param($username, $security_path)

    #Check security path to know this file passwd is alive or not
    if (Test-Path $security_path){
        $password = Get-Content "$security_path" | ConvertTo-SecureString
    }
    #if file was saved already! Just use it!
    else{
        (get-credential $username).password | ConvertFrom-SecureString | set-content "$security_path"
        $password = Get-Content "$security_path" | ConvertTo-SecureString
    }
    
    #get credential
    $credential = New-Object System.Management.Automation.PsCredential($username, $password)
    
    #test credential
    $username = $credential.username
    $password = $credential.GetNetworkCredential().password
    
    # Get current domain using logged-on user's credentials
    $CurrentDomain = "LDAP://" + ([ADSI]"").distinguishedName
    $domain = New-Object System.DirectoryServices.DirectoryEntry($CurrentDomain,$UserName,$Password)
    
    if ($domain.name -eq $null)
    {
        write-host "Authentication failed - please verify your username and password." -ForegroundColor Red
        Remove-Item -Path $security_path -Force
        $password = $null
        exit #terminate the script.
    }
    else
    {
        write-host "Successfully authenticated!" -ForegroundColor Green
        return $credential
    }
    
}

# Check computer info
function checkinfo {
    param (
        [string] $cp, $credential, $pstool_location
    )
    Write-Host "---------------------------------------------------------";
    $testcn = Test-Connection -ComputerName $cp -Quiet -Count 2;
    if ($testcn -eq "True"){
        Write-Host "$cp is online" -ForegroundColor Green;
        Write-Host "---------------------------------------------------------";
        $ipaddress = (Test-Connection -ComputerName $cp -count 1).IPV4Address.IPAddressToString
        write-host "IP address is $ipaddress" -ForegroundColor Blue;
        Start-Process -Filepath $pstool_location -Argumentlist "\\$cp -h -d winrm.cmd quickconfig -q" -Credential $credential
        Invoke-Command -ComputerName $cp -Credential $credential -ScriptBlock{
                $macaddress = (Get-NetAdapter | Where-Object {$_.Name -like "Ethernet*"} | Where-Object {$_.Status -eq "Up"}).MacAddress;
                Write-Host "MAC address is $macaddress" -ForegroundColor Blue;
                Write-Host "---------------------------------------------------------";
                $getusername = (Get-ComputerInfo).CsUserName;
                if ($null -eq $getusername){
                    $getlocalmember = Get-LocalGroupMember Administrators | Where-Object {$_.ObjectClass -eq "User"} | Where-Object {$_.PrincipalSource -eq "ActiveDirectory"};
                    $username = $getlocalmember.Name;
                }
                $getcpu = (Get-CimInstance -ClassName CIM_Processor).Name;
                $getram = ((Get-ComputerInfo).OsTotalVisibleMemorySize)/0.001Gb;
                $number = [math]::Truncate($getram);
                $numberplus = $number + 1;
                $gethdd = Get-PhysicalDisk | Select-Object MediaType, Size
                $getwdversion = (Get-ComputerInfo).WindowsVersion
                $getmainmodel = (Get-WmiObject win32_baseboard).Product
                Write-Host "Username is: $getusername $username" -ForegroundColor Yellow;
                Write-Host "---------------------------------------------------------";
                Write-Host "CPU: $getcpu" -ForegroundColor Green;
                Write-Host "Mainboard product: $getmainmodel"
                Write-Host "Total RAM: $numberplus Gb";
                Write-Host $gethdd;
                Write-Host "---------------------------------------------------------";
                $getVGA = (Get-WmiObject win32_VideoController).Description
                Write-Host $getVGA -ForegroundColor Blue;
                Write-Host "---------------------------------------------------------";
                write-host "Windows 10 version "$getwdversion -ForegroundColor Green;
                Write-Host "---------------------------------------------------------";
}
}
    else {
        Write-Host "$cp is offline" -ForegroundColor Red;
    }
}

# check each computer
function checkone{
    param (
        $credential, $pstool
    )
    $comp = read-host "What is the computername? ";
    $ip = $comp;
    if ($comp -like "sa*****"){
        $computername = $comp;
    }elseif ($comp -like "*.*.*.*"){
        $a = (Resolve-DnsName -Name $ip).NameHost  | ForEach-Object split .
        $computername = $a[0];
    }else {
        Write-Warning "Something went wrong! Please make sure your computername or IP address is right";
        exit;
    }
    $computerad = get-adcomputer -Searchbase "ou=computers,ou=wi,dc=abc,dc=org" -filter * -Properties operatingsystem | ? operatingsystem -match "windows" | Sort-Object name;
    $computernameAd = $computerad.Name;
    $findinad = $computernameAd | Select-String -Pattern "$computername";
    [string]$computernameinAD = $findinad;
    if ("$computernameinAD" -eq "$computername"){
        Write-Host "This machine $computername exists on AD" -ForegroundColor Yellow;
        checkinfo -cp $computername -cred $credential -pstool_location $pstool_location;
    }else{
        Write-Host "This machine $computername DOES NOT exist" -ForegroundColor Red;
        checkinfo -cp $computername -cred $credential -pstool_location $pstool_location;
    }
}

$cred = Save_credential -username $username -security_path $security_path
checkone -credential $cred -pstool $pstool_location

do{
    $answer = read-host "Do you want to continue? (y/n)"
    $response = @('y','yes')

    for ($i=0;$i -le $response.Count;$i++){
        if ($answer -eq $response[$i]){
            checkone -credential $cred -pstool $pstool_location
            break
        }
    }
}while($answer -ne 'n')
