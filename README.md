### 手順

1. rpi-imagerを使って、microSD カードに Raspberry Pi OSをインストールする。([ダウンロード](https://www.raspberrypi.com/software/
))
2. microSD カードをRaspberry Piに挿入し、電源を入れる。
3. コマンド1を実行する。
```bash
bash wifi_setting_1.sh
```

4. コマンド2を実行する。
```bash
bash wifi_setting_2.sh
```

5. raspi-config を起動し、ブート領域の ROM 化を行う。
```
sudo raspi-config

# Performance Options --> Overlay File System
1. Would you like the overlay file system to be enabled?
   --> Yes
2. Would you like the boot partition to be write-protected?
   --> Yes
```



### [参考にしたサイト]

* https://www.mikan-tech.net/entry/raspi-wifi-ap
* https://blog.soracom.com/ja-jp/2022/10/31/how-to-build-wifi-access-point-with-napt-and-traffic-counter-by-raspberry-pi/
* https://raspida.com/read-only/
