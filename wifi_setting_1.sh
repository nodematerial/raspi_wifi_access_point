#!/bin/bash
set -e

#sudo apt install vim
#sudo apt install tmux
sudo apt install -y hostapd dnsmasq dhcpcd

cat << EOT | sudo tee -a /etc/dnsmasq.conf
# dhcp server setting
interface=wlan0
dhcp-range=192.168.249.50,192.168.249.59,255.255.255.0,12h
EOT

sudo systemctl stop wpa_supplicant.service
sudo systemctl mask wpa_supplicant.service
cat << EOT | sudo tee -a /etc/dhcpcd.conf
# dhcp client setting
interface wlan0
static ip_address=192.168.249.1/24
nohook wpa_supplicant
EOT
sudo systemctl restart dhcpcd.service

cat << EOT | sudo tee -a /etc/hostapd/hostapd.conf
# wifi setting
ctrl_interface=/var/run/hostapd
ctrl_interface_group=0
interface=wlan0
driver=nl80211
ssid=YOUR_SSID
hw_mode=g
country_code=JP
channel=11
ieee80211d=1
wmm_enabled=0
macaddr_acl=0
auth_algs=1
wpa=2
wpa_passphrase=YOUR_PASSWORD
wpa_key_mgmt=WPA-PSK
rsn_pairwise=CCMP
EOT

cat << 'EOT' | sudo tee /lib/systemd/system/hostapd.service
[Unit]
Description=Access point and authentication server for Wi-Fi and Ethernet
Documentation=man:hostapd(8)
After=network.target
ConditionFileNotEmpty=/etc/hostapd/hostapd.conf

[Service]
Type=forking
PIDFile=/run/hostapd.pid
Restart=on-failure
RestartSec=2
Environment=DAEMON_CONF=/etc/hostapd/hostapd.conf
EnvironmentFile=-/etc/default/hostapd
ExecStart=/usr/sbin/hostapd -B -P /run/hostapd.pid $DAEMON_OPTS ${DAEMON_CONF}
ExecStartPre=/bin/sleep 5

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl unmask hostapd.service
sudo systemctl enable hostapd.service


cat << EOT | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf
# set Country code
country=JP
EOT

sudo rfkill unblock wlan
sudo apt install -y nginx

sudo reboot

