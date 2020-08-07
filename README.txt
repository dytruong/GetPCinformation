
----------------------------------------INSTRUCTION---------------------------------------------------------------
1. Add all computer (computername) that you want to get information to the same column in computername.csv file.
2. Update your domain admin and password in CheckPCinformation.ps1.
3. Remove hashtag # in first of a line checkmutiple to get mutiple PCs information. And add # to disable.
	+ Checkone is check one defined computer.
	+ Checkmutiple is check mutiple at the same time. 
    
4. Run as Administrator file RunasAdministrator.bat to run.

*Note:  
  + "Powershell is not recognized as an internal or external command operable ..". Please add %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\ to the Path enviroment.
  + DO NOT run two function (checkmutiple and checkone) at the same time. 

---------------------------------------INFORMATION----------------------------------------------------------------
This script can get a information below:
- IP address
- MAC address
- Current logged username
- RAM, HDD, CPU, VGA, windows 10 version.

Let me know if you need get more information ^^
Please don't hesitate to touch me with any question/issues related - duytruongtran1997@gmail.com
