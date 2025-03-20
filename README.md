# Bt Scripts
本脚本适用于宝塔云WAF，前提条件:
安装acme.sh
curl  https://get.acme.sh | sh
续签证书:
acme.sh --issue --dns dns_dp -d xxxxxx.cn -d *.xxxxxx.cn --force
安装到证书夹
acme.sh --install-cert -d xxxxxx.cn \
--key-file       /www/cloud_waf/vhost/ssl/xxxxxx.cn/privkey.pem  \
--fullchain-file /www/cloud_waf/vhost/ssl/xxxxxx.cn/fullchain.pem \
--reloadcmd     "docker exec cloudwaf_nginx nginx -s reload"

##如何使用
1. 修改脚本内的主域名
2. chmod +x bt_ssl.sh
3. bash bt_ssl.sh
4. all will be ok
