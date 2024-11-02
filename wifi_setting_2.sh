sudo apt install -y nftables
cat << _EOT_ | sudo tee -a /etc/nftables.conf
# Ref: https://wiki.archlinux.jp/index.php/Nftables#.E3.83.9E.E3.82.B9.E3.82.AB.E3.83.AC.E3.83.BC.E3.83.89
table ip nat {
  chain prerouting {
    type nat hook prerouting priority 0;
  }
  chain postrouting {
    type nat hook postrouting priority 0;
    oifname "eth0" masquerade;
  }
}
_EOT_
sudo systemctl restart nftables.service
sudo systemctl unmask nftables.service
sudo systemctl enable nftables.service

cat << _EOT_ | sudo tee /etc/sysctl.d/10-ipforward.conf
net.ipv4.ip_forward = 1
_EOT_


