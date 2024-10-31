![(23)](https://github.com/okannako/celestiamainnetscript/assets/73176377/b0c62370-d14b-4046-9feb-6c5cd4e0afc6)

Celestia Mainnet Beta ağında aşağıdaki kodu çalıştırarak Mainnet Beta ağında Validator, Bridge, Full Storage ve Light Node çalıştırabilirsiniz. Diğer ayrıntılarla birlikte bu script sayesinde kurulumu çok kısa bir süre içierisinde yapabilirsiniz.

```
curl -s https://raw.githubusercontent.com/okannako/celestiamainnetscript/main/nodescript.sh > nodescript.sh && chmod +x nodescript.sh && ./nodescript.sh
```

### bbr Aktif Hale Getirmek (Mutlaka Yapın)
- Aşağıdaki kodları girerek basit bir şekilde aktifleştirebilirsiniz.
```
cd celestia-app
make enable-bbr
```

- Eğer yukarıdaki kodlarda hata alırsanız aşağıdaki kodla aktif hale getirebilirsiniz.
```
sudo modprobe tcp_bbr; \
        echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf; \
        echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf; \
        sudo sysctl -p; \
```

Kurulumn sırasında veya sonrasında bir şey sormak isterseniz bana Telegram, Mail ve Discord yoluyla ulaşabirsiniz.
