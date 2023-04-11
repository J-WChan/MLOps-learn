# docker 시작

docker for windows 설치

- shell ->  wsl 진입


** docker 기본 명령어들

docker --help 
(명령어 확인가능)

docker pull nginx:1.21
해당 이미지 다운.
docker images | grep nginx 
이미지 존재여부 확인

docker run nginx:1.21
컨테이너 create 후 start 
docker run -p 80:80 nginx:1.21 (wsl이므로 포트 설정)(기본명령어 참고)

docker run -d image (백그라운드에서 컨테이너 실행) (docker run --rm 실행 이후 종료되면 삭제)

docker ps
실행중인 컨테이너 확인 

docker start stop (nifty_franklin:컨테이너 이름)
컨테이너 실행, 종료

docker stop $(docker ps -a -q)
모든 컨테이너 종료 

docker pause, unpause (nifty_franklin:컨테이너 이름)
컨테이너 일시정지, 다시 실행 

docker inspect (컨테이너 이름)
컨테이너 상세 설명 

docker kill (컨테이너 이름)
컨테이너 강제종료. 

docker rm 
컨테이너 삭제 (실행중이면 삭제불가, -f 강제종료 후 삭제, )

docker container prune
중지된 모든 컨테이너 삭제 

** Entrypoint, Command
Entrypoint : 컨테이너 실행시 고정적으로 실행되는 스크립트, 생략될경우 Command에 지정된 것으로 실행됨.
Command : 기본 명령어 or Entrypoint에 지정된 인자 값 .
docker inspect 를 통해 기본 커맨드 확인가능. 

docker run --entrypoint sh ubuntu
docker run --entrypoint echo ubuntu hello ubuntu


** 환경변수 
docker run --help 로 인자 확인 -e, --env list, --env_file list 등등 

docker run -it -e MY_HOST=1.1.1.1 ubuntu:latest bash
echo $MY_HOST

nano sample.env에 MY_HOST=1.1.1.1 작성 후 
docker run -it --env-file sample.env ubuntu env 로도 같은 실행 가능


** docker exec(명령어 실행)

docker run -d --name my-nginx nginx

docker exec -it my-nginx bash (해당 컨테이너에서 bash 명령어  실행)

docker exec my-nginx env(환경변수 확인)

** Network (컨테이너를 서비스와 연결)

예문 : docker run -p [HOST IP:PORT] : [CONTAINER PORT] [container이름]
예시 : docker run -d -p 80:80 nginx # 컨테이너의 80번 포트와 호스트의 모든 IP 80번 포트와 연결
       docker run -d -p 127.0.0.1:80:80 nginx # 컨테이너의 80번 포트와 호스트의 127.0.0.1 의 80번 포트와 연결
       docker run -d -p 80 nginx # 컨테이너의 80번 포트를 호스트의 사용 가능한 포트와 연결

** Expose VS Publish 
docker run -d --expose 80 nginx ( --expose : 문서화, run하기전까진 사용할 수 없음.)

docker run -d -p 80 nginx (publish : 실제 포트 바인딩)

** Volume 

컨테이너는 이미지 레이어와 컨테이너 레이어로 구성됨. 
컨테이너 레이어는 컨테이너가 종료되면 삭제됨.
보존하는 방법은 Host volume, Volume Container, Docker volume 세 가지 방법이 있음.

*Host volume (호스트의 디렉토리를 컨테이너에 마운트)

docker run -d -it -p 8090:80 --name my-nginx nginx # 기본 접속 
# 마운트할 디렉토리 생성
docker run -d -p 8090:80 -v $(pwd)/html:/usr/share/nginx/thml --name my-nginx nginx
# 마운트 확인
docker inspect my-nginx

(        "Mounts": [
            {
                "Type": "bind",
                "Source": "/home/ubuntu/workspace/lecture/html",
                "Destination": "/usr/share/nginx/thml",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }                                       )

docker run -d -it -p 9090:80 --name my-nginx2 nginx #다른 컨테이너 생성 
$ docker exec -it my-nginx2 bash  # 다른 컨테이너에서 해당 폴더 접근 
cd /usr/share/nginx/html/
cat index.html # 생성된 파일 확인 가능. 


* Volume Container (특정 컨테이너의 볼륨 마운트를 공유할 수 있음) 

docker run -d --name my-volume -it -v ${pwd}/html:/usr/share/nginx/html ubuntu

# my-volume 의 볼륨을 공유. 
docker run -d -p 8090:80 --name my-nginx --volumes-from myvolume nginx 

* Docker volume (컨테이너가 삭제되더라도 데이터 보존)   

docker volume ls # 볼륨확인 

docker volume create --name test-db #웹볼륨 도커 볼륨 생성

# 웹볼륨을 웹루트 디렉토리로 마운트
docker run -d --name mysql -v test-db:/var/lib/mysql -p 3306:3306 mysql:5.7

# 플랫폼 에러메시지시 활용. 
docker run -d --name my-sql -v test-db:/var/lib/mysql -p 3306:3306 \
--platform linux/amd64 -e MYSQL_ROOT_PASSWORD=test mysql:5.7

* 도커 볼륨 삭제

docker volume rm {볼륨이름}
