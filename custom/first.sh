#!/bin/bash
# https://github.com/281677160/build-actions
# common Module by 28677160
# matrix.target=${FOLDER_NAME}

function Diy_one() {
echo "${INPUTS_REPO_BRANCH}"
cd ${GITHUB_WORKSPACE}
if [[ -n "${BENDI_VERSION}" ]] && [[ ! -d "${OPER_ATES}" ]]; then
  git clone -q --single-branch --depth=1 --branch=main https://github.com/281677160/build-actions shangyou
  cp -Rf shangyou/build ${OPER_ATES}
  rm -rf shangyou
  chmod -R +x ${OPER_ATES}
else
  if [[ -d "build" ]]; then
    rm -rf ${OPER_ATES}
    cp -Rf build ${OPER_ATES}
  fi
fi
}

function Diy_two() {
cd ${GITHUB_WORKSPACE}
curl -fsSL https://raw.githubusercontent.com/281677160/common/main/common.sh -o common.sh
if [[ ! -d "${OPER_ATES}" ]]; then
  echo -e "\033[31m 根目录缺少编译必要文件夹存在 \033[0m"
  SYNCHRONISE="NO"
elif [[ ! -d "${FOLDER_NAME}" ]]; then
  echo -e "\033[31m 缺少${FOLDER_NAME}文件夹 \033[0m"
  SYNCHRONISE="NO"
elif [[ ! -f "${BUILD_PARTSH}" ]]; then
  echo -e "\033[31m 缺少${BUILD_PARTSH}文件 \033[0m"
  SYNCHRONISE="NO"
elif [[ ! -f "${BUILD_SETTINGS}" ]]; then
  echo -e "\033[31m 缺少${BUILD_SETTINGS}文件 \033[0m"
  SYNCHRONISE="NO"
elif [[ ! -f "${OPER_ATES}/${FOLDER_NAME}/relevance/actions_version" ]]; then
  echo -e "\033[31m 缺少relevance/actions_version文件 \033[0m"
  SYNCHRONISE="NO"
elif [[ -f "${OPER_ATES}/${FOLDER_NAME}/relevance/actions_version" ]]; then
  ACTIONS_VERSION1="$(sed -nE 's/^[[:space:]]*ACTIONS_VERSION[[:space:]]*=[[:space:]]*"?([0-9.]+)"?.*/\1/p' common.sh)"
  ACTIONS_VERSION2="$(sed -nE 's/^[[:space:]]*ACTIONS_VERSION[[:space:]]*=[[:space:]]*"?([0-9.]+)"?.*/\1/p' ${OPER_ATES}/${FOLDER_NAME}/relevance/actions_version)"
  if [[ ! "${ACTIONS_VERSION1}" == "${ACTIONS_VERSION2}" ]]; then
    echo -e "\033[31m 和上游版本不一致 \033[0m"
    SYNCHRONISE="NO"
  fi
else
  SYNCHRONISE="YES"
fi
}

function Diy_three() {
cd ${GITHUB_WORKSPACE}
if [[ "${SYNCHRONISE}" == "NO" ]]; then
  if [[ -n "${BENDI_VERSION}" ]]; then
    git clone -q --single-branch --depth=1 --branch=main https://github.com/281677160/build-actions shangyou
    if [[ -d "${OPER_ATES}" ]]; then
      mv ${OPER_ATES} backups
      cp -Rf shangyou/build ${OPER_ATES}
      mv backups ${OPER_ATES}/backups
      rm -rf shangyou
    else
      cp -Rf shangyou/build ${OPER_ATES}
      rm -rf shangyou
    fi
    chmod -R +x ${OPER_ATES}
  else
    git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
    git config --global user.name "github-actions[bot]"
    git clone -q --single-branch --depth=1 --branch=main https://github.com/281677160/build-actions shangyou
    [[ -d "build" ]] && cp -Rf build shangyou/backups
    BANBEN_SHUOMING="同步上游于 $(date +%Y.%m%d.%H%M.%S)"
    chmod -R +x shangyou
    git add .
    git commit -m "${BANBEN_SHUOMING}"
    git push --force "https://${{ env.REPO_TOKEN }}@github.com/${{ github.repository }}" HEAD:${{ github.ref_name }}
    if [[ $? -ne 0 ]]; then
      echo -e "\033[31m 同步上游仓库失败,请注意密匙是否正确 \033[0m"
    else
      echo -e "\033[33m 同步上游仓库完成,请重新设置好文件再继续编译 \033[0m"
    fi
    exit 1
  fi
fi
}

function Diy_memu() {
Diy_one
Diy_two
Diy_three
}

Diy_memu "$@"
