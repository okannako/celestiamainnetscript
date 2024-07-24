#!/bin/bash
echo -e "\033[0;37m"
echo "============================================================================================================"
echo " #####   ####        ####        ####  ####    ######    ##########  ####    ####  ###########   ####  ####"
echo " ######  ####       ######       #### ####    ########   ##########  ####    ####  ####   ####   #### ####"
echo " ####### ####      ###  ###      ########    ####  ####     ####     ####    ####  ####   ####   ########"   
echo " #### #######     ##########     ########   ####    ####    ####     ####    ####  ###########   ########"
echo " ####  ######    ############    #### ####   ####  ####     ####     ####    ####  ####  ####    #### ####"  
echo " ####   #####   ####      ####   ####  ####   ########      ####     ############  ####   ####   ####  ####"
echo " ####    ####  ####        ####  ####   ####    ####        ####     ############  ####    ####  ####   ####"
echo "============================================================================================================"
echo -e '\e[36mTwitter :\e[39m' https://twitter.com/NakoTurk
echo -e '\e[36mGithub  :\e[39m' https://github.com/okannako
echo -e '\e[36mYoutube :\e[39m' https://www.youtube.com/@CryptoChainNakoTurk
echo -e "\e[0m"
sleep 5

echo -e "\e[1m\e[32m Yapmak istediğin şey nedir ? \e[0m" && sleep 2
PS3='Select an action: '
options=(
"Validator Node Yüklemek"
"Validator Node Kontrol"
"Validator Oluşturmak"
"Light Node Yüklemek"
"Bridge Node Yüklemek"
"Full Storage Node Yüklemek"
"Light Node Data Sıfırla"
"Bridge Node Data Sıfırla"
"Full Storage Node Data Sıfırla"
"Light Node ID Nedir ?"
"Bridge Node ID Nedir ?"
"Full Storage Node ID Nedir ?"
"Çıkış")
select opt in "${options[@]}"
do
case $opt in

"Validator Node Yüklemek")

echo -e "\e[1m\e[32m Güncellemeler \e[0m" && sleep 2

sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git ncdu -y
sudo apt install make -y
sleep 1

echo -e "\e[1m\e[32m Go Yükleniyor \e[0m" && sleep 2
ver="1.22.0"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version && sleep 2

cd $HOME 
rm -rf celestia-app 
git clone https://github.com/celestiaorg/celestia-app.git 
cd celestia-app/ 
APP_VERSION=v1.11.0
git checkout tags/$APP_VERSION -b $APP_VERSION
make install
celestia-appd version && sleep 3

echo "NodeIsmi:"
read NodeIsmi
echo export NodeName=${NodeIsmi} >> $HOME/.bash_profile

celestia-appd init "$NodeIsmi" --chain-id celestia

SEEDS="12ad7c73c7e1f2460941326937a039139aa78884@celestia-mainnet-seed.itrocket.net:40656"
PEERS="d535cbf8d0efd9100649aa3f53cb5cbab33ef2d6@celestia-mainnet-peer.itrocket.net:40656,fed121cc9450f5518f2441ee9e1168392027a117@135.181.236.8:36656,905cecaaefc2ec59c0f383ff4e318baf9530e903@65.109.49.164:26000,5f7b67e8f41fec251f9b86045b1b648a2fba5988@37.120.245.61:26656,3e9edb7aa157894b498e75373e2148f7c22100b2@103.219.171.67:26656,140df92f010e78bd9d854e47d019468e10df7628@65.109.27.253:26001,e19f9cd1005fa5176ebf97c73694863f361a9d9b@95.216.71.19:11656,2a4cf74e21a28f4aa387ad00de3956af512d837b@65.108.123.161:26656,57307aa4cac3b00aace33d34fe0a7c52e290705f@80.190.129.50:27657,5e727b10ba178737a56f2891168a0e42380b6755@198.244.200.98:26664,9a179402b03fa08f4b635439a0cd857184c87979@65.21.69.230:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.celestia-app/config/config.toml

wget -O $HOME/.celestia-app/config/genesis.json https://mainnet-files.itrocket.net/celestia/genesis.json
wget -O $HOME/.celestia-app/config/addrbook.json https://mainnet-files.itrocket.net/celestia/addrbook.json

sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.celestia-app/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.celestia-app/config/app.toml

sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.002utia"|g' $HOME/.celestia-app/config/app.toml

celestia-appd tendermint unsafe-reset-all --home $HOME/.celestia-app

sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-appd.service
[Unit]
Description=Celestia node
After=network-online.target
[Service]
User=root
ExecStart=$(which celestia-appd) start --home $HOME/.celestia-app
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable celestia-appd
sudo systemctl start celestia-appd

echo "CüzdanIsmi:"
read CüzdanIsmi
echo export CuzdanIsmi=${CuzdanIsmi} >> $HOME/.bash_profile
celestia-appd keys add $CuzdanIsmi

echo -e '\e[36mBu adımda cüzdanınızla ilgili bilgiler paylaşılır.. >>>LÜTFEN ANLATICI KELİMELERİ YEDEKLEYİN.<<< Yedekleme yaptıktan sonra Enter tuşuna basarak devam edebilirsiniz.\e[39m'
read Enter

echo -e '\e[36mIMPORTANT: Geçerli bloğa senkronizasyonu bekleyin. Kontrol etmek için betiği yeniden başlatın ve ilgili seçeneği seçin.\e[39m'
sleep 7
sudo journalctl -u celestia-appd -f

break
;;

"Validator Node Kontrol")

celestia-appd status 2>&1 | jq .SyncInfo
echo -e '\e[36mÖNEMLİ: "catching_up": false olduğunda, mevcut bloğa erişmişsinizdir ve betiği tekrar çalıştırıp Doğrulayıcı Oluşturabilirsiniz. Doğrulayıcı oluşturmadan önce Discord'da cüzdanınıza bir test jetonu talep ettiğinizden emin olun.\e[39m'
sleep 10

break
;;

"Validator Oluşturmak")

celestia-appd tx staking create-validator \
--amount=1000000utia \
--pubkey=$(celestia-appd tendermint show-validator) \
--moniker=$NodeIsmi \
--chain-id=celestia \
--commission-rate=0.05 \
--commission-max-rate=0.20 \
--commission-max-change-rate=0.01 \
--min-self-delegation=1 \
--from=$CuzdanIsmi \
--gas-adjustment=1.4 \
--gas=auto \
--gas-prices=0.01utia

echo -e "\e[36mÖNEMLİ: Doğrulayıcı oluşturma adımı tamamlandıktan sonra .celestia-appd klasöründeki config klasörünü yedeklediğinizden emin olun..\e[39m"
sleep 10

break
;;

"Light Node Yüklemek")

echo -e "\e[1m\e[32m Güncellemeler \e[0m" && sleep 2
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git ncdu -y
sudo apt install make -y
sleep 1

echo -e "\e[1m\e[32m Go Yüklemek \e[0m" && sleep 2
ver="1.22.0"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version && sleep 2

cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.14.0
make build 
make install 
make cel-key 
celestia version && sleep 3
celestia light init --core.ip rpc.celestia.pops.one --p2p.network celestia

echo -e "\e[36mBu adımda cüzdanınızla ilgili bilgiler paylaşılır.. >>>LÜTFEN ANLATICI KELİMELERİ YEDEKLEYİN.<<< Yedekleme yaptıktan sonra Enter tuşuna basarak devam edebilirsiniz.\e[39m"
read Enter

sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-lightd.service
[Unit]
Description=celestia-light Cosmos daemon
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/celestia light start --core.ip rpc.celestia.pops.one --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=true --metrics --metrics.endpoint otel.celestia.observer
Restart=on-failure
RestartSec=3
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF
systemctl enable celestia-lightd
systemctl start celestia-lightd

echo -e '\e[36mÖNEMLİ: /root/.celestia-light-mocha anahtarlar altındaki klasörün yedeklenmesi gerekir.\e[39m'
sleep 7

journalctl -u celestia-lightd.service -f

break
;;

"Bridge Node Yüklemek")

echo -e "\e[1m\e[32m Güncellemeler \e[0m" && sleep 2
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git ncdu -y
sudo apt install make -y
sleep 1

echo -e "\e[1m\e[32m Go Yüklemek \e[0m" && sleep 2
ver="1.22.0"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version && sleep 2

cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.14.0 
make build 
make install 
make cel-key 
celestia version && sleep 3

cd $HOME 
rm -rf celestia-app 
git clone https://github.com/celestiaorg/celestia-app.git 
cd celestia-app/ 
APP_VERSION=v1.11.0
git checkout tags/$APP_VERSION -b $APP_VERSION 
make install

echo "NodeIsmi:"
read NodeIsmi
echo export NodeName=${NodeIsmi} >> $HOME/.bash_profile

celestia bridge init --core.ip rpc.celestia.pops.one

sudo tee /etc/systemd/system/celestia-bridge.service > /dev/null <<EOF
[Unit]
Description=celestia-bridge Cosmos daemon
After=network-online.target

[Service]
User=root
ExecStart=/usr/local/bin/celestia bridge start --core.ip rpc.celestia.pops.one --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=true --metrics --metrics.endpoint otel.celestia.observer
Restart=on-failure
RestartSec=3
LimitNOFILE=100000

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable celestia-bridge
sudo systemctl start celestia-bridge

echo -e "\e[36mÖNEMLİ: /root/.celestia-bridge-mocha anahtarlar altındaki klasörün yedeklenmesi gerekir.\e[39m"
sleep 7

sudo journalctl -u celestia-bridge.service -f

break
;;

"Full Storage Node Yüklemek")

echo -e "\e[1m\e[32m Güncellemeler \e[0m" && sleep 2
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git ncdu -y
sudo apt install make -y
sleep 1

echo -e "\e[1m\e[32m Go Yüklemek \e[0m" && sleep 2
ver="1.22.0"
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version && sleep 2

cd $HOME 
rm -rf celestia-node 
git clone https://github.com/celestiaorg/celestia-node.git 
cd celestia-node/ 
git checkout tags/v0.14.0 
make build 
make install 
make cel-key 
celestia version && sleep 3

celestia full init --core.ip rpc.celestia.pops.one 

echo -e "\e[36mBu adımda cüzdanınızla ilgili bilgiler paylaşılır.. >>>LÜTFEN ANLATICI KELİMELERİ YEDEKLEYİN.<<< Yedekleme yaptıktan sonra Enter tuşuna basarak devam edebilirsiniz.\e[39m"
read Enter

sudo tee <<EOF >/dev/null /etc/systemd/system/celestia-fulld.service
[Unit]
Description=celestia-fulld Full Node
After=network-online.target

[Service]
User=$USER
ExecStart=/usr/local/bin/celestia full start --core.ip rpc.celestia.pops.one --core.rpc.port 26657 --core.grpc.port 9090 --keyring.accname my_celes_key --metrics.tls=true --metrics --metrics.endpoint otel.celestia.observer
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

systemctl enable celestia-fulld
systemctl start celestia-fulld


echo -e "\e[36mIMPORTANT: /root/.celestia-full-mocha-4 anahtarlar altındaki klasörün yedeklenmesi gerekir.\e[39m"
sleep 7

journalctl -u celestia-fulld.service -f

break
;;

"Light Node Data Sıfırla")

systemctl stop celestia-lightd
celestia light unsafe-reset-store --p2p.network celestia
systemctl restart celestia-lightd
journalctl -u celestia-lightd.service -f

break
;;

"Bridge Node Data Sıfırla")

sudo systemctl stop celestia-bridge
celestia bridge unsafe-reset-store --p2p.network celestia
sudo systemctl restart celestia-bridge
sudo journalctl -u celestia-bridge.service -f

break
;;

"Full Storage Node Data Sıfırla")

systemctl stop celestia-fulld
celestia full unsafe-reset-store --p2p.network celestia
systemctl restart celestia-fulld
journalctl -u celestia-fulld.service -f

break
;;

"Light Node ID Nedir ?")

AUTH_TOKEN=$(celestia light auth admin --p2p.network celestia)

curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658

break
;;

"Bridge Node ID Nedir ?")

AUTH_TOKEN=$(celestia bridge auth admin --p2p.network celestia)

curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658

break
;;

"Full Storage Node ID Nedir ?")

AUTH_TOKEN=$(celestia full auth admin --p2p.network celestia)

curl -X POST \
     -H "Authorization: Bearer $AUTH_TOKEN" \
     -H 'Content-Type: application/json' \
     -d '{"jsonrpc":"2.0","id":0,"method":"p2p.Info","params":[]}' \
     http://localhost:26658

break
;;

"Exit")
exit
;;
*) echo "invalid option";;
esac
done
done
