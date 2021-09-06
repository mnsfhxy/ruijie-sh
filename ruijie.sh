#!/bin/bash
#填入用户名，密码，服务名，校园网ip
userId=''
password=''
service=""
ip=''

#
rm -rf ruijie.html
service=`echo "$service" | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g'`
curl -sL -o ruijie.html -X GET www.baidu.com
file=./ruijie.html
flag=1
while [ ! -s $file ]
do
curl -sL -o ruijie.html -X GET www.baidu.com
let flag=$flag+1
if (($flag > 5))
then
	echo "尝试超过5次....自动退出...."
	rm -rf ruijie.html
	exit 1
fi
done

tryNet(){
if [[ -z "`grep -o -e '/eportal/index.jsp' ruijie.html`" ]] && [[ -z "`grep -o -e '<script>top.self.location.href=' ruijie.html`" ]]; then
 echo "网络已连接！"
 rm -rf ruijie.html
 exit 1
fi
}
tryNet
portal=`cat ruijie.html`
portal=`echo ${portal#*index.jsp?}`
qs=`echo ${portal%\'\<\/script*}`
#qs=`echo "$qs" | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g'`
echo $qs
curl  -X POST -A 'login' -H 'Accept: */*' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -d "userId=${userId}&password=${password}&service=${service}&queryString=${qs}&passwordEncrypt=false" http://${ip}/eportal/InterFace.do?method=login
rm -rf ruijie.html
tryNet

