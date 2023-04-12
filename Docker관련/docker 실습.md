1. tensorflow 이미지를 가져와서 컨테이너 실행 후 디바이스 목록 확인하기

    - docker pull tensorflow/tensorflow # 이미지 내려받기
    - docker run -d -it --name prac1 tensorflow/tensorflow # 컨테이너 생성
    - docker exec -it  prac1 bash # bash 접근 
    - python <br>
    이후 실습내용대로.<br>
    `device_lib.list_local_devices()` <br> 
    [name: "/device:CPU:0"
    device_type: "CPU"
    memory_limit: 268435456
    locality {
    }
    incarnation: 16295234266148644695
    xla_global_id: -1
    ]

2. miniconda3 이미지로 pandas, numpy 버전 확인하기 
   - docker pull continuumio/miniconda3 # 이미지 내려받기
   - docker run -d -it --name prac2 continuumio/miniconda3 # 컨테이너 실행
   - docker exec -it prac2 bash (base로 접근..)
   - pip list 확인시 pandas, numpy 없음.
   - conda list 에도 없음. 
   - 설치. pandas 1.5.3 numpy 1.23.5 설치함.

3.  jupyter notebook 실행하기 
   - docker run -it -p 9090:9090 --name prac3 continuumio/miniconda3 /bin/bash 
   - conda install jupyter
   - jupyter notebook --ip 0.0.0.0 --port 9090 --no-browser --allow-root 
   - 터미널에 출력되는 jupyter 접속. 

----------------------------------------------------------------------------------------

dockerfile 만들기
베이스 : python 3.9
label : version, description
run : apt-get update, apt-get upgrade -y
run : apt-get install python3-pip
workdir : /data/app 

[dockerfile]
```dockerfile
FROM python:3.9
LABEL version=1.0.0
LABEL description=test
RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install python3-pip -y
WORKDIR /data/app
```

docker build -t  test-image .
docker run --name test test-image:v1.0.0
docker image inspect test-image 로 label 확인가능

------------------------------------------------------------

위 dockerfile를 이용해서. 파이썬 패키지를 포함한 이미지 만들기 

COPY : requirements.txt 파일을 WORKDIR로 복사
RUN : pip install 사용해 requirements.txt 실행 

[dockerfile]
```dockerfile
FROM python:3.9

LABEL version=1.0.0
LABEL description=test

RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install python3-pip -y

WORKDIR /data/app
COPY requirements.txt ./requirements.txt

RUN pip install -r requirements.txt
```

-----------------------------------------------------------

딥러닝 모델을 실행할 수 있는 docker image 만들기 

[dockerfile]
```dockerfile
FROM python:3.9.16

RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install python3-pip -y

WORKDIR /data/app
COPY requirements.txt ./requirements.txt

RUN pip install -r requirements.txt
RUN git clone https://github.com/J-WChan/DeepFM.git
WORKDIR /data/app/DeepFM
CMD python main.py
```

