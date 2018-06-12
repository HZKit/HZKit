# -*- coding: utf-8 -*-

import os

# 说明
#
## 逻辑待完善：提示注册 trunk、发布结果校验待
##
## 参考文章：https://blog.csdn.net/stubbornness1219/article/details/50968000
## 1.开源库发布之后，需要打上tag
## 2.进入到项目根目录下，创建podspec文件
##   pod spec create PodName
## 3.编辑podspec文件中的相关信息，有两个比较重要的地方s.source和s.source_files,可以验证是否有误：
##   pod spec lint PodName.podspec
## 4.注册pod trunk
##   $ pod trunk register orta@cocoapods.org 'Orta Therox' --description='macbook air'
## 5.发布到pod trunk
##   pod trunk push [NAME.podspec]
##   该命令在包含有.podspec文件的目录下执行
## 6.更新pod库
##   pod setup
##   如果pod trunk push成功后无法pod search到自己的库，可执行该命令。

spec_name = 'HZKit.podspec'

passed_validation = '%s passed validation' % spec_name

# 执行命令，并返回输出值
def exec_cmd(cmd):
    r = os.popen(cmd)
    text = r.read()
    r.close()
    return text

# 验证
def pod_spec_lint():
    print('开始验证...')
    cmd = 'pod spec lint %s' % spec_name
    return (passed_validation in exec_cmd(cmd))

def main():
    # Check
    if pod_spec_lint():
        cmd = 'pod trunk push %s' % spec_name
        print(exec_cmd(cmd))
        print('发布完成')
    else:
        # // TODO: 精准提示
        print('未建tag')

main()

