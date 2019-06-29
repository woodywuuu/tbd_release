#!/bin/bash

#只需要master分支了
git checkout master
if ! git status|grep "nothing to commit";then
    echo "master分支存在未提交变更，请提交后重试"
    exit 1
fi
git pull

# CHANGELOG=Changelog.md
DAY_NOW=`date +%F`
VER_NOW=`git for-each-ref --sort='*authordate' --format='%(tag)' refs/tags|tail -n 1`
DELIM='@-@' #日志分隔符
if [[ -z "${VER_NOW}" ]];then
    VER_PATCH="无, 版本号示例: v0.0.1"
fi
read -e -p "当前版本号: ${VER_NOW}${VER_PATCH}, 请输入新版本号: " VER_NEW
if ! echo ${VER_NEW} | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$';then
    echo "版本号格式错误，退出"
    exit 1
fi
if git tag | grep -w "${VER_NEW}" ;then
    echo "版本号已存在，请检查，退出"
    exit 1
fi

cherry () {
    echo "请cherry-pick后执行："
    echo "    sh update.sh ${VER_NEW}"
    exit 1
}

read -p "是否需要从上次tag创建release分支?(y/n):" isCommit
if [[ "${isCommit}" = "y" || "${isCommit}" = "Y" ]];then
    git checkout -b release-${VER_NEW} ${VER_NOW}
    echo "发版分支 release-${VER_NEW} 已基于tag${VER_NOW}创建"
    cherry
else
    git checkout -b release-${VER_NEW} master
    echo "发版分支 release-${VER_NEW} 已基于master创建"
fi

sh update.sh ${VER_NEW}
