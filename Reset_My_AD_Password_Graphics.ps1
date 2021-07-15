function SSPSMessage1 () {
$message = "Self-Service Password Reset (Windows Login)`r`nBy Jonathan Ball`r`n`r`nClick OK to check if you are connected to a VPN. If not the program will try connect you."
[System.Windows.Forms.Messagebox]::Show($message)
}
function SSPSMessage2 () {
$message = "You are connected to a VPN.`r`n`r`nPlease take note that after resetting your password your computer will lock and will require you to sign in with the new password.`r`n`r`nPassword Policy Requirements: `r`n`r`nYou cannot reuse old passwords`r`nMinimum 10 character length`r`nUppercase characters`r`nLowercase characters`r`nSpecial characters`r`nNumbers`r`n`r`nClick OK to begin resetting your password"
[System.Windows.Forms.Messagebox]::Show($message)
}
function SSPSInformation () {
$message = "Your password has been successfully reset. When you click OK the computer will lock and you will need to log in with the New password you have just set."
[System.Windows.Forms.MessageBox]::Show($message,"Self-Service Password Reset",[System.Windows.Forms.MessageBoxButtons]::OKCancel,[System.Windows.Forms.MessageBoxIcon]::Information)
}
function SSPSWarning1 () {
$message = "The Passwords either do not match or you have left a password field blank. Please try again."
[System.Windows.Forms.MessageBox]::Show($message,"Self-Service Password Reset",[System.Windows.Forms.MessageBoxButtons]::OKCancel,[System.Windows.Forms.MessageBoxIcon]::Warning)
}
function SSPSWarning2 () {
$message = "Unable to reset your password. `r`n`r`nEither the current password is incorrect or the New password does not meet complexity requirements.`r`nPlease try again."
[System.Windows.Forms.MessageBox]::Show($message,"Self-Service Password Reset",[System.Windows.Forms.MessageBoxButtons]::OKCancel,[System.Windows.Forms.MessageBoxIcon]::Warning)
}
function SSPSPasswords () {

$title = 'Self-Service Password Reset'
$currentpass = 'Current Password:'
$newpass = 'New Password:'
$newpassconfirm = 'Confirm New Password:'


$form = New-Object System.Windows.Forms.Form
$form.Width = 390
$form.Height = 200
$form.Text = $title
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

#Text label 1
$textLabel1 = New-Object System.Windows.Forms.Label
$textLabel1.Left = 25
$textLabel1.Top = 10
$textLabel1.Text = $currentpass
$textBox1 = New-Object System.Windows.Forms.MaskedTextBox
#$testBox1.PasswordChar = '*'
$textBox1.Left = 150
$textBox1.Top = 10
$textBox1.width = 200

#Text label 2
$textLabel2 = New-Object System.Windows.Forms.Label
$textLabel2.Left = 25
$textLabel2.Top = 40
$textLabel2.Text = $newpass
$textBox2 = New-Object System.Windows.Forms.MaskedTextBox
#$testBox2.PasswordChar = '*'
$textBox2.Left = 150
$textBox2.Top = 40
$textBox2.width = 200

#Text label 3
$textLabel3 = New-Object “System.Windows.Forms.Label”
$textLabel3.Left = 25
$textLabel3.Top = 70
$textLabel3.Text = $newpassconfirm
$textBox3 = New-Object System.Windows.Forms.MaskedTextBox
#$testBox3.PasswordChar = '*'
$textBox3.Left = 150
$textBox3.Top = 70
$textBox3.width = 200

#Define default values for the input boxes
$defaultValue = “”
$textBox1.Text = $defaultValue;
$textBox2.Text = $defaultValue;
$textBox3.Text = $defaultValue;

$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = 'OK'
$okButton.Location = "150,100"
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$Form.AcceptButton = $okButton

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = 'Cancel'
$cancelButton.Location = "300,100"
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$Form.CancelButton = $cancelButton

$eventHandler = [System.EventHandler]{
$textBox1.Text;
$textBox2.Text;
$textBox3.Text;
$form.Close();};

$okbutton.Add_Click($eventHandler)

$form.Controls.Add($textLabel1)
$form.Controls.Add($textLabel2)
$form.Controls.Add($textLabel3)
$form.Controls.Add($textBox1)
$form.Controls.Add($textBox2)
$form.Controls.Add($textBox3)

$Form.controls.Add($okButton)
$Form.controls.Add($cancelButton)

$ret = $form.ShowDialog();

return $textBox1.Text, $textBox2.Text, $textBox3.Text
}

SSPSMessage1

#Clear variables and collect data

#Tests connection to head office network / VPN connected and if not attempts to connect
if (!($testconnection = Test-Connection 10.1.14.49 -Count 3 -ErrorAction SilentlyContinue))
{
$rasdial = rasdial vpn1.truenorth.co.za
sleep 2
if (!($testconnection = Test-Connection 10.1.14.49 -Count 1 -ErrorAction SilentlyContinue))
{
$rasdial = rasdial vpn2.truenorth.co.za
sleep 2}
if (!($testconnection = Test-Connection 10.1.14.49 -Count 1 -ErrorAction SilentlyContinue))
{
$rasdial = rasdial vpn3.truenorth.co.za
sleep 2}
}

if ($testconnection) {

$currentusername = $env:USERNAME
$ErrorActionPreference = "Stop"
$xCmdString = {rundll32.exe user32.dll,LockWorkStation}
$running = $true

SSPSMessage2

    while ($running) {

        $oldpassword = $null
        $newpassword1 = $null
        $newpassword2 = $null

    #Try reset password  
        while (($newpassword1 -eq $null) -or ($newpassword1 -eq '') -or ($newpassword2 -eq $null) -or ($newpassword2 -eq '') -or ($oldpassword -eq $null) -or ($oldpassword -eq ''))
        {
            #Get Password info           
            $passwords = SSPSPasswords
            $oldpassword = $passwords[0]
            $newpassword1 = $passwords[1]
            $newpassword2 = $passwords[2]
            $secoldpass = ConvertTo-SecureString -String $oldpassword  -AsPlainText -Force
            $secnewpass1 = ConvertTo-SecureString -String $newpassword1 -AsPlainText -Force  
            $secnewpass2 = ConvertTo-SecureString -String $newpassword2 -AsPlainText -Force               

            while (!($newpassword1 -eq $newpassword2) -or ($newpassword1 -eq $null) -or ($newpassword1 -eq '') -or ($newpassword2 -eq $null) -or ($newpassword2 -eq ''))
            {
            SPSSWarning1 
            $passwords = SSPSPasswords
            $oldpassword = $passwords[0]
            $newpassword1 = $passwords[1]
            $newpassword2 = $passwords[2]
            $secoldpass = ConvertTo-SecureString -String $oldpassword  -AsPlainText -Force
            $secnewpass1 = ConvertTo-SecureString -String $newpassword1 -AsPlainText -Force  
            $secnewpass2 = ConvertTo-SecureString -String $newpassword2 -AsPlainText -Force 
            }
            
            if (($newpassword1 -ne $null) -or ($newpassword1 -ne ''))
            {
            try {$sesh = New-PSSession -ComputerName tnf-srv-dc1 -ConfigurationName selfservicepasswordreset
                $icm = Invoke-Command -Session $sesh {Set-ADAccountPassword -Identity ($using:currentusername) -OldPassword ($using:secoldpass) -NewPassword ($using:secnewpass1)}               
                SSPSInformation
                $running = $false
                $sesh | Remove-PSSession}
            catch {SSPSWarning2
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
                                                                                                                     
                                                                                                                                                                                                                                       

