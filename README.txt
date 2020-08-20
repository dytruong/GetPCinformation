
----------------------------------------INSTRUCTION---------------------------------------------------------------
There are two functions on this script:
- Get information on one computer (default)
- Get information on mutiple computers.

I. How to get information on one computer?
	- Update your domain admin and password in CheckPCinformation.ps1.
	- Update your PC naming convetion
		+ Change saiwks to your own.
	- Run as Administrator file RunasAdministrator.bat to run.

II. How to get information on mutiple computers?
	- Add all computer (computername) that you want to get information to the same column in computername.csv file.
	- Update your domain admin and password in CheckPCinformation.ps1.
	- Update your PC naming convetion
		+ Change saiwks to your own.
	- Remove hashtag # in first of a line checkmutiple to get mutiple PCs information. And add # to disable.
		+ Checkone is check one defined computer.
		+ Checkmutiple is check mutiple at the same time. 
    	- Run as Administrator file RunasAdministrator.bat to run.

*Note:  
  + "Powershell is not recognized as an internal or external command operable ..". Please add %SYSTEMROOT%\System32\WindowsPowerShell\v1.0\ to the Path enviroment.
  + DO NOT run two functions (checkmutiple and checkone) at the same time. 

---------------------------------------INFORMATION----------------------------------------------------------------
This script can get information below:
- IP address
- MAC address
- Current logged username
- RAM, HDD, CPU, VGA, windows 10 version.

Let me know if you need get more information ^^
Please don't hesitate to touch me with any question/issues related - duytruongtran1997@gmail.com
