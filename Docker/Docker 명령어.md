# docker 시작

docker for windows 설치

- shell ->  wsl 진입


## docker 기본 명령어들

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

## Entrypoint, Command
Entrypoint : 컨테이너 실행시 고정적으로 실행되는 스크립트, 생략될경우 Command에 지정된 것으로 실행됨.
Command : 기본 명령어 or Entrypoint에 지정된 인자 값 .
docker inspect 를 통해 기본 커맨드 확인가능. 

docker run --entrypoint sh ubuntu
docker run --entrypoint echo ubuntu hello ubuntu


## 환경변수 
docker run --help 로 인자 확인 -e, --env list, --env_file list 등등 

docker run -it -e MY_HOST=1.1.1.1 ubuntu:latest bash
echo $MY_HOST

nano sample.env에 MY_HOST=1.1.1.1 작성 후 
docker run -it --env-file sample.env ubuntu env 로도 같은 실행 가능


## docker exec(명령어 실행)

docker run -d --name my-nginx nginx

docker exec -it my-nginx bash (해당 컨테이너에서 bash 명령어  실행)

docker exec my-nginx env(환경변수 확인)

## Network (컨테이너를 서비스와 연결)

예문 : docker run -p [HOST IP:PORT] : [CONTAINER PORT] [container이름]
예시 : docker run -d -p 80:80 nginx # 컨테이너의 80번 포트와 호스트의 모든 IP 80번 포트와 연결
       docker run -d -p 127.0.0.1:80:80 nginx # 컨테이너의 80번 포트와 호스트의 127.0.0.1 의 80번 포트와 연결
       docker run -d -p 80 nginx # 컨테이너의 80번 포트를 호스트의 사용 가능한 포트와 연결

## Expose VS Publish 
docker run -d --expose 80 nginx ( --expose : 문서화, run하기전까진 사용할 수 없음.)

docker run -d -p 80 nginx (publish : 실제 포트 바인딩)

## Volume 

컨테이너는 이미지 레이어와 컨테이너 레이어로 구성됨. 
컨테이너 레이어는 컨테이너가 종료되면 삭제됨.
보존하는 방법은 Host volume, Volume Container, Docker volume 세 가지 방법이 있음.

### Host volume (호스트의 디렉토리를 컨테이너에 마운트)

docker run -d -it -p 8090:80 --name my-nginx nginx # 기본 접속 

docker run -d -p 8090:80 -v $(pwd)/html:/usr/share/nginx/thml --name my-nginx nginx # 마운트할 디렉토리 생성

docker inspect my-nginx # 마운트 확인(하단 부분)

(        "Mounts": [
            {
                "Type": "bind",
                "Source": "/home/ubuntu/workspace/lecture/html",
                "Destination": "/usr/share/nginx/thml",
                "Mode": "",
                "RW": true,
                "Propagation": "rprivate"
            }                                        
       )

docker run -d -it -p 9090:80 --name my-nginx2 nginx #다른 컨테이너 생성 
$ docker exec -it my-nginx2 bash  # 다른 컨테이너에서 해당 폴더 접근 
cd /usr/share/nginx/html/
cat index.html # 생성된 파일 확인 가능. 


### Volume Container (특정 컨테이너의 볼륨 마운트를 공유할 수 있음) 

docker run -d --name my-volume -it -v ${pwd}/html:/usr/share/nginx/html ubuntu

docker run -d -p 8090:80 --name my-nginx --volumes-from myvolume nginx # my-volume 의 볼륨을 공유. 

### Docker volume (컨테이너가 삭제되더라도 데이터 보존)   

docker volume ls # 볼륨확인 

docker volume create --name test-db # 웹볼륨 도커 볼륨 생성


(docker run -d --name mysql -v test-db:/var/lib/mysql -p 3306:3306 mysql:5.7 # 웹볼륨을 웹루트 디렉토리로 마운트)

docker run -d --name my-sql -v test-db:/var/lib/mysql -p 3306:3306 --platform linux/amd64 -e MYSQL_ROOT_PASSWORD=test mysql:5.7 

docker exec -it my-sql2 bash # 컨테이너 진입하여 bash 접근

(mysql -u root -p (비밀번호는 컨테이너 생성시 설정함)
이후 mysql 명령어로 접근가능. )

### 도커 볼륨 삭제

docker volume rm {볼륨이름}


### 로그 확인 

docker logs my-nginx # 해당 컨테이너 이름의 로그

docker logs --tail 5 my-nginx # 로그 마지막 5줄

docker logs -f my-nginx # 로그 스트림 확인(실시간)

docker logs -f -t my-nginx # 타임스탬프 표시

### 이미지 레이어 확인
(nginx는 ubuntu를 기반으로 생성된 이미지일 때 nginx이미지 내 ubuntu 관련 소스는 이미지 레이어(리드만 가능), 컨테이너 레이어(read,write 가능) 로 구성된다. )


docker image inspect nginx # 해당 이미지의 이미지 레이어가 어떻게 구성되었는지 확인가능 

### dockerfile 없이 이미지 생성 

docker run -it --name my-ubuntu ubuntu:latest # 컨테이너 실행

echo "hello ubuntu" > my_file # my_file 생성
ctrl + p, q # 명령어 저장, 컨테이너 종료하지않고 빠져나옴

docker commit -a hwkim -m "Add my_file" my-ubuntu my-ubuntu:v1.0.0 # commit 으로 컨테이너의 변경점 저장

docker images # 이미지 목록에서 확인가능 

docker image inspect my-ubuntu:v1.0.0 # 새로운 이미지 레이어 상세 내용 확인

### dockerfile 이용 이미지 생성.

Dockerfile은 지시어와 그 인자로 구성, 순차적으로 실행됨.

dockerfile 예시
(FROM node:12-alpine
RUN apk add --no-cache python3 g++ make
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"])

FROM ubuntu:20.04
RUN apt-get update
CMD ["echo", "Hello Ubuntu"]

docker build -t my-app:v1 -f example/MyDockerfile ./ # -t로 태그, -f로 경로 지정하여 이미지 생성.

### dockerfile 명령어 

FROM : 어떤 image를 베이스로 할 것인지 
ex) FROM ubuntu:20.04

LABEL : 이미지의 메타데이터, 필수옵션 아님
ex) LABEL version = "1.0.0"

COPY : source의 파일을 target에 복사하는 것.
ex) COPY a.txt some-dir/b.txtx

RUN : 명시한 커맨드를 도커 컨테이너에서 실행하는 것을 명시하는 명령어. 
ex) RUN pip install torch 

CMD : 명시한 커맨드를 통해 컨테이너가 시작될 때 실행하는 것. 하나의 CMD만 실행할 수 있어서 RUN과 다름
ex) CMD python main.py

WORKDIR : 명령어들을 어떤 디렉토리에서 수행할지 명시
ex) WORKDIR /home/demo

EXPOSE : 컨테이너에서 사용할 port / protocol 지정 (명시할뿐, 포워딩되지않음)
ex) EXPOSE 8080 

ENV : 컨테이너 내부에서 사용할 환경변수 설정.
ex) RUN locale-gen ko_KR.UTF-8 ENV LANG ko_KR.UTF-8 

이후 이 dockerfile로 빌드할 수 있음 

### Docker compose

```dockerfile
docker run --name 'db' -v "$(pwd)/db_data:/var/lib/mysql"\
-e "MYSQL_ROOT_PASSWORD=12345"\
-e "MYSQL_DATABASE=wordpress"\
-e "MYSQL_USER=wordpress_user"\
-e "MYSQL_PASSWORD=12345"\
--net wordpress_net mysql:5.7 
```

위와같은 명령어로 container를 run 해야할 때 docker-compose.yml 파일에 미리 설정한 후 

docker-compose up 명령어로 입력가능. 

docker-compose down # 컨테이너 및 네트워크 종료

docker-compose -p <프로젝트명> # 해당 프로젝트의 상세를 확인할 수 있음
       logs -f 
       events
       images 