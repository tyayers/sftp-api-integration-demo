# create & add sftp user to group
sudo groupadd sftpusers
sudo useradd -m -g sftpusers -s /bin/false sftpuser
(echo 'apigeeRocks%12'; echo 'apigeeRocks%12') | sudo passwd sftpuser

# configure sftp subsystem
sudo sed -i 's/\(PasswordAuthentication\).*/\1 yes/g' sshd_config
sudo sed -i 's/\(PasswordAuthentication\).*/\1 yes/g' sshd_config

sudo sed -i -e '$a\'$'\n''Match Group sftpusers' /etc/ssh/sshd_config
sudo sed -i -e '$a\'$'\n''    X11Forwarding no' /etc/ssh/sshd_config
sudo sed -i -e '$a\'$'\n''    AllowTcpForwarding no' /etc/ssh/sshd_config
sudo sed -i -e '$a\'$'\n''    ChrootDirectory /sftp/%u' /etc/ssh/sshd_config
sudo sed -i -e '$a\'$'\n''    ForceCommand internal-sftp' /etc/ssh/sshd_config

sudo mkdir -p /sftp/sftpuser/files
sudo chown root:sftpusers /sftp/sftpuser
sudo chmod 755 /sftp/sftpuser
sudo chown sftpuser:sftpusers /sftp/sftpuser/files

# restart ssh with changes
sudo systemctl restart ssh