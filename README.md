## 本脚本适用于宝塔云 WAF，前提条件:

安装 acme.sh

curl  https://get.acme.sh | sh

## 续签证书:

`acme.sh --issue --dns dns_dp -d xxxxxx.cn -d *.xxxxxx.cn --force`

## 安装到证书夹

`acme.sh --install-cert -d luocaiyi.cn `<br />`--key-file       /www/cloud_waf/vhost/ssl/luocaiyi.cn/privkey.pem  `<br />`--fullchain-file /www/cloud_waf/vhost/ssl/luocaiyi.cn/fullchain.pem `<br />`--reloadcmd     "docker exec -it cloudwaf_nginx nginx -s reload"`

## 如何使用

1. 修改脚本内的主域名
2. `chmod +x bt_ssl.sh`
3. `bash bt_ssl.sh`
4. all will be ok
5. ![1742450100247.png](https://img.luocaiyi.cn/i/own/2025/03/20/67dbadb975abd.png)[https://img.luocaiyi.cn/i/own/2025/03/20/67dbadb975abd.png](https://img.luocaiyi.cn/i/own/2025/03/20/67dbadb975abd.png)
