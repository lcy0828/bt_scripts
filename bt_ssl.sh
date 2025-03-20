#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.acme.sh

CERT_HOME="/root/.acme.sh"
PANEL_CERT_DIR="/www/cloud_waf/nginx/conf.d/cert"

declare -A domains=(
  ["xxxxxx.cn"]=""   # 示例：主域名
  ["xxxxxx.top"]=""    # 其他泛域名
  ["xxxxxx.pub"]=""    # 其他泛域名
)

cert_count=0
echo $cert_count > https_count.txt
for domain in "${!domains[@]}"; do
  echo "----------------------------"
  echo -e "\e[1;31mDomain : $domain \e[0m"
  read cert_count < https_count.txt  
  subs_count=0
  # 将域名中的点 . 转换为下划线 _，用于匹配目录名
  domain_dir="${domain//./_}"
  # 遍历所有可能包含该域名的目录（支持 _0、_1 等后缀）
  find "$PANEL_CERT_DIR" -maxdepth 1 -type d -name "*${domain_dir}*" | while read -r subdir; do
    subdomain_name=$(basename "$subdir")
    
    # 匹配主域名目录（如 xxxxxx_cn_0）和子域名目录（如 chat_xxxxxx_cn_0）
    if [[ "$subdomain_name" =~ ^${domain_dir}(_[0-9]+)?$ ]]; then
      # 主域名目录（如 xxxxxx_cn_0 → xxxxxx.cn）
      real_subdomain="$domain"
    elif [[ "$subdomain_name" =~ ^(.*)_${domain_dir}(_[0-9]+)?$ ]]; then
      # 子域名目录（如 chat_xxxxxx_cn_0 → chat.xxxxxx.cn）
      real_subdomain="${BASH_REMATCH[1]//_/.}.$domain"  # 将子域名中的 _ 还原为 .
    else
      continue  # 跳过不匹配的目录
    fi

      #echo $subdir
      acme.sh --install-cert -d "$domain" \
        --key-file "$subdir/privkey.pem" \
        --fullchain-file "$subdir/fullchain.pem" \
        --reloadcmd "docker exec  cloudwaf_nginx nginx -s reload"
      
      echo "Installed certificate for: ${real_subdomain//../\*.}  (Directory: $subdomain_name)"
      ((subs_count++))
      ((cert_count++))
     echo $cert_count > https_count.txt
     echo $subs_count > https_sbs_count.txt
  done
  read sbs_count < https_sbs_count.txt  
  echo "$domain certificates installed: $sbs_count"
  read cert_count < https_count.txt  
done
echo "----------------------------"
echo "Total certificates installed: $cert_count"
rm https_count.txt https_sbs_count.txt
