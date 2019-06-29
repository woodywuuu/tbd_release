#/bin/bash
cherry(){
    git log master --pretty=oneline -10
    read -p "请输入Commit/Commit组: " Commit
    git cherry-pick ${Commit}
}
echo "可以单次commitID，如 42fgwx"
echo "也可以输入两次ID，中间所有提交会被pick，左开右闭，如 42fgwx...86feqd"
echo "最好按照时间顺序pick，不然会出篓子"
while true;do
    cherry
done
