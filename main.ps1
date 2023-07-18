Add-Type -AssemblyName System.windows.Forms

#Create Objects
$FormObject = [System.windows.Forms.Form]
$LabelObject = [System.windows.Forms.Label]
$ButtonObject = [System.windows.Forms.Button]
$TextObject = [System.windows.Forms.TextBox]

#Modify Objects
$Form=New-Object $FormObject
$Form.ClientSize='900,900'
$Form.Text='Active Directory Inactive Computers'
$Form.BackColor="F5F5F5"
$Form.StartPosition=[System.Windows.Forms.FormStartPosition]::CenterScreen

$inputlabel=New-Object $LabelObject
$inputlabel.Size=New-Object System.Drawing.Size(220,50)
$inputlabel.Text="Enter Days Inactive:"
$inputlabel.Font='Verdana,7,style=Bold'
$inputlabel.Left=300
$inputlabel.Top=27

$inputBox=New-Object $TextObject
$inputBox.Left=420
$inputBox.Top=25
$inputBox.Add_KeyDown({
  if ($_.KeyCode -eq "Enter") {
      FindInactive
  }
})

$btn=New-Object $ButtonObject
$btn.Text="Find"
$btn.AutoSize=$true
$btn.Font='Verdana,7,style=Bold'
$btn.Location=New-Object System.Drawing.Point(400,100)

$lblhead=New-Object $LabelObject
$lblhead.Text=""
$lblhead.Font='Verdana,10,style=Bold'
$lblhead.Location=New-Object System.Drawing.Point(325,175)
$lblhead.Size=New-Object System.Drawing.Size(250,50)

$lbltitle=New-Object $LabelObject
$lbltitle.Text=''
$lbltitle.AutoSize=$true
$lbltitle.BackColor="#FFFFFF"
$lbltitle.Font='Verdana,7,style=Bold'
$lbltitle.Location=New-Object System.Drawing.Point(300,270)

#Add items to Form
$Form.ControlsAddRange(@($lbltitle, $btn, $inputBox, $inputlabel, $lblhead))

#Logic/Functions
function FindInactive {
  $time = (Get-Date).addDays(-($inputBox.Text))
  $comps = Get-ADComputer -Filter {LastLogonTimeStamp -lt $time} -Properties Name, LastLogonDate, UserPrincipalName | Select Name, LastLogonDate, UserPrincipalName
  $input=$inputBox.Text
  $lblhead.Text="Computers Inactive for $input Days:"

  foreach ($c in $comps)
  {
    $lbltitle.Text=$comps | Format-List | Out-String
  }

  if ($comps -eq $null)
  {
    $lbltitle.Text="No Inactive Computers"
    $lbltitle.Left=350
    $lblhead.Text=""
  }
}

#Add Function to Form
$btn.Add_Click({FindInactive})

#Display Form
$Form.ShowDialog()

#Close Form
$Form.Dispose()
