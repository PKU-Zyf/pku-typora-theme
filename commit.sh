cd D:/MyProjects/pku-typora-theme
git add -A
time=$(date "+%Y-%m-%d %H:%M")
git commit -m "更新于：$time"
git pull
git push
echo 备份完成！
sleep 15
