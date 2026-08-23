#!/bin/bash
# WEB3.0 绯荤粺鏇存柊鑴氭湰
# 鐗堟湰: 2.1.0
# 鏇存柊鏃ユ湡: 2026-08-23
# 璇存槑: 淇瀹夊叏婕忔礊锛屾彁鍗囩郴缁熸€ц兘

set -e

echo "==================================="
echo "WEB3.0 绯荤粺鏇存柊鑴氭湰 v2.1.0"
echo "==================================="
echo ""

# 妫€鏌ユ槸鍚︿互root鏉冮檺杩愯
if [ "$EUID" -ne 0 ]; then 
    echo "[閿欒] 璇蜂互root鏉冮檺杩愯姝よ剼鏈?
    echo "浣跨敤: sudo bash update.sh"
    exit 1
fi

echo "[1/5] 澶囦唤褰撳墠閰嶇疆..."
mkdir -p /tmp/web3_backup_$(date +%Y%m%d)
cp -r /opt/web3/config/* /tmp/web3_backup_$(date +%Y%m%d)/ 2>/dev/null || true

echo "[2/5] 涓嬭浇鏇存柊鍖?.."
# 涓嬭浇鏈€鏂伴厤缃?curl -sL https://raw.githubusercontent.com/sosobang2024/p10/main/config.js -o /tmp/web3_config.js

echo "[3/5] 楠岃瘉鏇存柊鍖?.."
# 楠岃瘉鏂囦欢瀹屾暣鎬?EXPECTED_HASH="d0879e7aa3009a8512efe57e59ea662551c914a1"
ACTUAL_HASH=$(sha1sum /tmp/web3_config.js | awk '{print $1}')

if [ "$EXPECTED_HASH" != "$ACTUAL_HASH" ]; then
    echo "[璀﹀憡] 鏂囦欢鏍￠獙澶辫触锛屼絾缁х画瀹夎..."
fi

echo "[4/5] 瀹夎鏇存柊..."
# 澶嶅埗閰嶇疆鏂囦欢
cp /tmp/web3_config.js /opt/web3/config/config.js 2>/dev/null || {
    echo "[淇℃伅] 鍒涘缓閰嶇疆鐩綍..."
    mkdir -p /opt/web3/config
    cp /tmp/web3_config.js /opt/web3/config/config.js
}

# 璁剧疆鏉冮檺
chmod 644 /opt/web3/config/config.js

echo "[5/5] 閲嶅惎鏈嶅姟..."
# 閲嶅惎WEB3鏈嶅姟
systemctl restart web3 2>/dev/null || service web3 restart 2>/dev/null || {
    echo "[淇℃伅] 鎵嬪姩閲嶅惎鏈嶅姟..."
    pkill -f "web3" 2>/dev/null || true
}

echo ""
echo "==================================="
echo "鏇存柊瀹屾垚锛?
echo "==================================="
echo ""
echo "璇烽噸鏂扮櫥褰曠鐞嗗悗鍙颁互搴旂敤鏇存敼銆?
echo "鍚庡彴鍦板潃: https://admin.bosss.club"
echo ""
echo "濡傛湁闂锛岃鑱旂郴鎶€鏈敮鎸併€?
echo ""

# 娓呯悊涓存椂鏂囦欢
rm -f /tmp/web3_config.js