Clear-Host
Write-Host "`r`nSelf-Service Password Reset" -ForegroundColor Yellow
Write-Host "By Jonathan Ball"
Write-Host "`r`nChecking VPN Connection..."

#Clear variables and collect data

#Tests connection to head office network / VPN connected and if not attempts to connect
if (!($testconnection = Test-Connection 10.1.14.49 -Count 3 -ErrorAction SilentlyContinue))

{
Clear-Host
Write-Host "`r`nSelf-Service Password Reset" -ForegroundColor Yellow
Write-Host "By Jonathan Ball"
Write-Host "`r`nTrying to connect to VPN1..."
$rasdial = rasdial vpn1.truenorth.co.za
sleep 5
if (!($testconnection = Test-Connection 10.1.14.49 -Count 1 -ErrorAction SilentlyContinue))
{
Clear-Host
Write-Host "`r`nSelf-Service Password Reset" -ForegroundColor Yellow
Write-Host "By Jonathan Ball"
Write-Host "`r`nTrying to connect to VPN2..."
$rasdial = rasdial vpn2.truenorth.co.za
sleep 5}
if (!($testconnection = Test-Connection 10.1.14.49 -Count 1 -ErrorAction SilentlyContinue))
{
Clear-Host
Write-Host "`r`nSelf-Service Password Reset" -ForegroundColor Yellow
Write-Host "By Jonathan Ball"
Write-Host "`r`nTrying to connect to VPN3..."
$rasdial = rasdial vpn3.truenorth.co.za
sleep 5}
}

if ($testconnection) {

$currentusername = $env:USERNAME
$ErrorActionPreference = "Stop"
$xCmdString = {rundll32.exe user32.dll,LockWorkStation}
$adresetwarning = $null
$message = "`r`n`r`nAfter resetting your password your computer will lock and will require you to sign in with the new password`r`n`r`nPassword Policy Requirements: `r`n`r`nMinimum 10 character length`r`nUppercase characters`r`nLowercase characters`r`nSpecial characters`r`nNumbers`r`n`r`nPlease note that this is your Windows login password and you are unfortunately unable to reuse previous passwords.`r`n"

Clear-Host
Write-Host "`r`nSelf-Service Password Reset" -ForegroundColor Yellow
Write-Host "By Jonathan Ball"

Write-Host $message -ForegroundColor Gray

#Try reset password     
        while (($adresetwarning -eq $null) -or ($adresetwarning -match "Failure")){

        $newpassword1 = $null
        $newpassword2 = $null
        $oldpassword = $null

        while (($newpassword1 -eq $null) -or ($newpassword1 -eq '') -or ($newpassword2 -eq $null) -or ($newpassword2 -eq '') -or ($oldpassword -eq $null) -or ($oldpassword -eq ''))
        {
            #Get Password info
            $oldpassword = Read-Host "Please enter your current password" -AsSecureString
            $newpassword1 = Read-Host "New Password" -AsSecureString
            $newpassword2 = Read-Host "Confirm New Password" -AsSecureString
            $plainenewpass1 = (New-Object PSCredential '.', $newpassword1).GetNetworkCredential().Password
            $plainenewpass2 = (New-Object PSCredential '.', $newpassword2).GetNetworkCredential().Password                  

            while (!($plainenewpass1 -eq $plainenewpass2) -or ($plainenewpass1 -eq $null) -or ($plainenewpass1 -eq '') -or ($plainenewpass2 -eq $null) -or ($plainenewpass1 -eq ''))
            {
            Clear-Host
            Write-Host "`r`nSelf-Service Password Reset`r`n`r`n" -ForegroundColor Yellow
            write-warning "The Passwords either do not match or you have left a password field blank. Please try again.`r`n`r`n" 
            $oldpassword = Read-Host "Please enter your current password" -AsSecureString
            $newpassword1 = Read-Host "New Password" -AsSecureString
            $newpassword2 = Read-Host "Confirm New Password"-AsSecureString
            $plainenewpass1 = (New-Object PSCredential '.', $newpassword1).GetNetworkCredential().Password
            $plainenewpass2 = (New-Object PSCredential '.', $newpassword2).GetNetworkCredential().Password
            }
            
            if (($newpassword1 -ne $null) -or ($newpassword1 -ne ''))
            {
            try {$sesh = New-PSSession -ComputerName tnf-srv-dc1 -ConfigurationName selfservicepasswordreset
                $icm = Invoke-Command -Session $sesh {Set-ADAccountPassword -Identity ($using:currentusername) -OldPassword ($using:oldpassword) -NewPassword ($using:newpassword1)}               
                Clear-Host
                Write-Host "`r`nSelf-Service Password Reset" -ForegroundColor Yellow
                Write-Host "`r`nYour password has been successfully reset. When you press Enter the computer will lock and you will need to log in with the New password you have just set.`r`n" -ForegroundColor Green
                $adresetwarning = "Success"
                $sesh | Remove-PSSession}
            catch {$adresetwarning = "`r`nUnable to reset your password. `r`n`r`nEither the current password is incorrect or the New password does not meet complexity requirements.`r`nPlease try again.`r`n`r`nYou can close this program at any time."
                    Clear-Host
                    Write-Host "`r`nSelf-Service Password Reset" -ForegroundColor Yellow
                    Write-Host $adresetwarning -ForegroundColor Red
                    $adresetwarning = "Failure"
                    $sesh | Remove-PSSession}
            }
        }
    }
}
else
{
Clear-Host
Write-Warning "Unable to connect to the directory server. Please ensure that you are connected to a VPN and try run this program again. If you are connected to a VPN and you are still seeing this error please make contact with IT to investigate.`r`n"
Read-Host -Prompt “Press Enter to exit”
break
}

Read-Host -Prompt “Press Enter to exit”
Invoke-Command $xCmdString
                                                                                                                     
                                                                                                                                                                                                                                       

