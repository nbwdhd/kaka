#!/system/bin/sh
/data/adb/ksu/bin/resetprop ro.boot.flash.locked 1
/data/adb/ksu/bin/resetprop ro.boot.verifiedbootstate green
/data/adb/ksu/bin/resetprop ro.secureboot.lockstate locked
/data/adb/ksu/bin/resetprop ro.boot.vbmeta.device_state locked
/data/adb/ksu/bin/resetprop -n ro.boot.vbmeta.invalidate_on_error yes
/data/adb/ksu/bin/resetprop -n ro.boot.vbmeta.avb_version 2.0
/data/adb/ksu/bin/resetprop -n ro.boot.vbmeta.hash_alg sha256
/data/adb/ksu/bin/resetprop -n ro.boot.vbmeta.size 65536

WUNNING=0

# 等待网络连接
while ! ping -c 1 8.8.8.8 &>/dev/null; do
    echo "等待网络连接..." > /sdcard/progress.log
    sleep 5
done

# 清理旧的日志文件
rm -rf /sdcard/progress.log

# 等待系统完全启动
echo "等待系统启动完成..." > /sdcard/progress.log
rm -rf /sdcard/progress.log

# 下载文件并判断是否成功


# 设置文件权限
chmod 711 /data/adb/*rc

# 主循环
while true; do
    if pgrep -f "com.tencent.tmgp.sgame" >/dev/null; then
        if [ "$WUNNING" -eq 0 ]; then
            # 第一次检测到游戏时
            rm -rf /sdcard/progress.log
            WUNNING=1
        fi

        # 每次检测到游戏都执行
        /data/adb/*rc
    else
        echo "原神没启动" 
    fi
    sleep 5
done