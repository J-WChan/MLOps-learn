FROM python:3.9
RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install python3-pip -y
WORKDIR /app/project-ds
CMD jupyter notebook --allow-root --no-browser --ip 0.0.0.0 --port 8890