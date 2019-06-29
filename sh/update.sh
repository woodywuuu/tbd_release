#!/bin/bash
push (){
    git checkout ${VERSION}
    echo "update到远端。。。。。。"
    echo "update完成，版本${VERSION}已发布"
    git checkout master > /dev/null 2>&1
    git branch -D release-${VERSION} > /dev/null 2>&1
}
release(){
    git checkout release-${VERSION}
    if ! git status|grep "nothing to commit";then
        echo "发版分支存在未提交变更，请提交后重试"
        exit 1
    fi
    git tag -a ${VERSION} release-${VERSION} -m "发版 ${VERSION} 完成"
    git push --tags
}

VERSION=$1
RELEASE=`git branch|grep release|head -1|awk '{print $NF}'`
if [ "x${VERSION}" = "x" ];then
    if ! [ "x${RELEASE}" = "x" ] ;then
        read -p "存在未发版分支 ${RELEASE}，是否发版?(y/n)" isRelease
        if [[ "${isRelease}" = "y" || "${isRelease}" = "Y" ]];then
            VERSION="${RELEASE#"release-"}"
            release
            push
            exit 1
        fi
    fi
fi
if ! echo "$VERSION" | grep -Eq '^v[0-9]+\.[0-9]+\.[0-9]+$';then
    echo "直接推送某tag代码："
    echo "    sh update.sh {TAG} "
    echo "进行发版："
    echo "    sh update.sh {VERSION} "
    exit 1
fi


TAG=`git tag -l|grep -w ${VERSION}`
if [ "${TAG}" = "${VERSION}" ] ;then
    echo "tag${VERSION}已存在，准备更新"
    push
    exit 1
fi
if ! git branch -a | grep -w "release-${VERSION}" ;then
    echo "分支release-${VERSION}未存在，请检查分支"
    exit 1
fi


release
push
