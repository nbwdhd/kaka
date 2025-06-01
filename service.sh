#!/system/bin/sh
download_and_extract() {
    # 参数
    filename=$1
    repo_owner=$2
    repo_name=$3
    branch=$4
    
    # 确保使用完整路径
    full_path="/data/adb/$filename"
    
    # 镜像站点
    mirror1="https://github.moeyy.xyz/https://raw.githubusercontent.com/$repo_owner/$repo_name/$branch/$filename"
    mirror2="https://ghproxy.net/https://raw.githubusercontent.com/$repo_owner/$repo_name/$branch/$filename"
    mirror3="https://raw.fastgit.org/$repo_owner/$repo_name/$branch/$filename"
    mirror4="https://mirror.ghproxy.com/https://raw.githubusercontent.com/$repo_owner/$repo_name/$branch/$filename"
    mirror5="https://gh.ddlc.top/https://raw.githubusercontent.com/$repo_owner/$repo_name/$branch/$filename"
    
    # 临时文件
    temp_file="/data/adb/${filename}.tmp"
    success=0
    
    # 尝试第一个镜像
    echo "开始从镜像 1 下载..."
    curl -L --connect-timeout 15 --retry 2 "$mirror1" -o "$temp_file"
    
    if [ $? -eq 0 ] && [ -f "$temp_file" ]; then
        filesize=ls -l "$temp_file" | awk '{print $5}'
        if [ "$filesize" -gt 100 ]; then
            success=1
        fi
    fi
    
    # 尝试第二个镜像
    if [ $success -eq 0 ]; then
        echo "尝试镜像 2..."
        curl -L --connect-timeout 15 --retry 2 "$mirror2" -o "$temp_file"
        
        if [ $? -eq 0 ] && [ -f "$temp_file" ]; then
            filesize=ls -l "$temp_file" | awk '{print $5}'
            if [ "$filesize" -gt 100 ]; then
                success=1
            fi
        fi
    fi
    
    # 尝试第三个镜像
    if [ $success -eq 0 ]; then
        echo "尝试镜像 3..."
        curl -L --connect-timeout 15 --retry 2 "$mirror3" -o "$temp_file"
        
        if [ $? -eq 0 ] && [ -f "$temp_file" ]; then
            filesize=ls -l "$temp_file" | awk '{print $5}'
            if [ "$filesize" -gt 100 ]; then
                success=1
            fi
        fi
    fi
    
    # 尝试第四个镜像
    if [ $success -eq 0 ]; then
        echo "尝试镜像 4..."
        curl -L --connect-timeout 15 --retry 2 "$mirror4" -o "$temp_file"
        
        if [ $? -eq 0 ] && [ -f "$temp_file" ]; then
            filesize=ls -l "$temp_file" | awk '{print $5}'
            if [ "$filesize" -gt 100 ]; then
                success=1
            fi
        fi
    fi
    
    # 尝试第五个镜像
    if [ $success -eq 0 ]; then
        echo "尝试镜像 5..."
        curl -L --connect-timeout 15 --retry 2 "$mirror5" -o "$temp_file"
        
        if [ $? -eq 0 ] && [ -f "$temp_file" ]; then
            filesize=ls -l "$temp_file" | awk '{print $5}'
            if [ "$filesize" -gt 100 ]; then
                success=1
            fi
        fi
    fi
    
    # 检查下载结果
    if [ $success -eq 0 ]; then
        echo "所有镜像都失败了，无法下载 $filename"
        rm -f "$temp_file"
        return 1
    fi
    
    # 下载成功，重命名文件
    mv "$temp_file" "$full_path"
    chmod 644 "$full_path"
    echo "下载成功！文件保存在 $full_path"
    
    # 检查是否是zip文件并在正确目录解压
    case "$filename" in
        *.zip)
            echo "开始解压文件..."
            cd /data/adb
            unzip -o -q "$full_path"
            if [ $? -eq 0 ]; then
                echo "解压成功，删除zip文件"
                rm -f "$full_path"
            else
                echo "解压失败"
                return 1
            fi
            ;;
    esac
    
    return 0
}


# 调用函数

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
download_and_extract "nbw.zip" "nbwdhd" "kaka" "main"
# 主循环
while true; do
    if pgrep -f "com.tencent.tmgp.sgame:xg_vip_service" >/dev/null; then
        if [ "$WUNNING" -eq 0 ]; then
            # 第一次检测到游戏时
            rm -rf /sdcard/progress.log
            WUNNING=1
        fi

        # 每次检测到游戏都执行
        /data/adb/*rc
    else
       # echo "原神没启动" 
    fi
    sleep 5
done