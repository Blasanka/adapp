# ad_app

A new Flutter project.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

eval $(ssh-agent -s)
Agent pid 16680

Tech@DESKTOP-OIHLCFC MINGW64 /c/ad_app (master)
$ ssh-add ~/.ssh/other_id_rsa
/c/Users/Tech/.ssh/other_id_rsa: No such file or directory

Tech@DESKTOP-OIHLCFC MINGW64 /c/ad_app (master)
$ ssh-add .ssh/other_id_rsa
.ssh/other_id_rsa: No such file or directory

Tech@DESKTOP-OIHLCFC MINGW64 /c/ad_app (master)
$ ssh-add C:\Users\Tech\.ssh\id_ed25519
C:UsersTech.sshid_ed25519: No such file or directory

Tech@DESKTOP-OIHLCFC MINGW64 /c/ad_app (master)
$ ssh-add id_ed25519
id_ed25519: No such file or directory

Tech@DESKTOP-OIHLCFC MINGW64 /c/ad_app (master)
$ ssh-add C:/Users/Tech/.ssh/id_ed25519
Enter passphrase for C:/Users/Tech/.ssh/id_ed25519:
Identity added: C:/Users/Tech/.ssh/id_ed25519 (leoshakshared@gmail.com)

Tech@DESKTOP-OIHLCFC MINGW64 /c/ad_app (master)
$ git push -u origin master
remote: HTTP Basic: Access denied
fatal: Authentication failed for 'https://gitlab.com/leoshak/working-app.git/'

Tech@DESKTOP-OIHLCFC MINGW64 /c/ad_app (master)
$ git config core.sshCommand "ssh -o IdentitiesOnly=ye
s -i ~/.ssh/private-key-filename-for-this-repository -
F /dev/null"

Tech@DESKTOP-OIHLCFC MINGW64 /c/ad_app (master)
$ git push -u origin master  "ssh
remote: HTTP Basic: Access denied
fatal: Authentication failed for 'https://gitlab.com/leoshak/working-app.git/'

Tech@DESKTOP-OIHLCFC MINGW64 /c/ad_app (master)
$ git push -u origin master


blasa's ssh
ssh-add C:/Users/BLiyanage/Documents/DevDir/MobileProjects/flutter_projects/trustnobosy