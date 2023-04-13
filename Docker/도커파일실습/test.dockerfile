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
