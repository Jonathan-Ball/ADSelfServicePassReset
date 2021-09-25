# ADSelfServicePassReset

# This program was built using Powershell and a Powershell feature, Just Enough Admnistration. This means that the JEA endpoint needed to be setup on the 
# domain controller that the program will direct the rewquest to.

# The idea is simple: Add a self service password reset capabilty to allow users in an organization to reset their own passwords ahead of an AD revamp forcing users to 
# reset their passwords. This is to get them comfortable with the idea of not having a single password and used to the idea of resetting it every few months.

# After making a working console version I set out to build a graphical version with a Powershell tool I have used before but found that this was not working properly.
# I set out to learn about the inner workings of Powershell to try build it myself and them realized that it is .NET at its core and there must be a better way to try
# do this. 

# I then found C#...
