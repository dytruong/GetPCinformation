#Author - TruongproKuteVIP^^

$password = "Password@123" | ConvertTo-SecureString -asPlainText -Force;    #update your domain admin password 
$username = "a.nguyenvan@abc.com";                                          #update your domain admin account
$cred = New-object System.Management.Automation.PSCredential($username,$password)

function checkinfo {
    param (
        [string]$cp
    )
    Write-Host "---------------------------------------------------------";
    $testcn = Test-Connection -ComputerName $cp -Quiet;
    if ($testcn -eq "True"){
        Write-Host "$cp is online" -ForegroundColor Green;
        Write-Host "---------------------------------------------------------";
        $ipaddress = (Test-Connection -ComputerName $cp -count 1).IPV4Address.IPAddressToString
        write-host "IP address is $ipaddress" -ForegroundColor Blue;
        $macaddress = (Get-NetAdapter | Where-Object {$_.Name -eq "Ethernet"}).MacAddress;
        Write-Host "MAC address is $macaddress" -ForegroundColor Blue;
        Write-Host "---------------------------------------------------------";
        Invoke-Command -ComputerName $cp -Credential $cred -ScriptBlock{
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
                Write-Host "Username is: $getusername $username" -ForegroundColor Yellow;
                Write-Host "---------------------------------------------------------";
                Write-Host "CPU: $getcpu" -ForegroundColor Green;
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

function checkmutiple{
    $ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path;
    $computer = Import-csv -Path "${ScriptDir}\source\computername.csv" -Header computername
    foreach ($pc in $computer)
    {
        checkinfo -cp $pc.computername;
    }
}

function checkone{
    $comp = read-host "What is the computername? ";
    checkinfo -cp $comp;
}

#remove or add # before function you want to run. For ex: If you want to get information of mutiple computers, remove # in checkmutiple and add #checkone and counterwork. 
#checkmutiple;
checkone;
