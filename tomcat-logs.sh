#!/bin/sh

######################################################################
# 删除90天之前的日志文件，压缩一周之前的日志文件
# 日志文件时间是根据日志名称后面的日期来计算
# 运行脚本注意日志文件中是否有其他相同后缀的非日志文件和日志文件名称是否符合要求
######################################################################

#日志文件所在目录
path=/data1/tomcat-goopay/logs/pay

#进入日志目录
cd $path


#90天之前的日志文件删除
#获取90天之前的日期
del_date=`date +%Y-%m-%d -d "90 days ago"`
#获取文件名中的日期字符串，然后对比时间进行相应的操作，localhost_access_log的后缀文件名一般是txt，这里包括txt文件
for n in `ls *.log *.txt -1`;do
    m=`echo $n | awk -F. '{print $(NF-1)}'`
    m=`echo ${m:0-10}`
	echo $n $m
	if [ ! $m ]; then
		echo "IS NULL"
		continue
	fi
    if [[ $m < $del_date || $m = $del_date ]];then
        echo file $n will be deleted.
        rm -rf $n
    fi
done

#15天之前的文件压缩
#获取15天之前的日期
zip_date=`date +%Y-%m-%d -d "1 days ago"`
#获取文件名中的日期字符串，然后对比时间进行相应的操作
for n in `ls *.log *.txt -1`;do
    m=`echo $n | awk -F. '{print $(NF-1)}'`
    m=`echo ${m:0-10}`
    echo $n $m
    if [ ! $m ]; then
        echo "IS NULL"
        continue
    fi
    if [[ $m < $zip_date || $m = $zip_date ]];then
        echo file $n will be tar.
        tar -zcvf  $n.tar.gz $n
        rm -rf $n
    fi
done
