# MLflow 실습

### 파이썬 가상환경 생성

python3 -m venv {가상환경이름} (venv 설치해야함.)
source {가상환경}/bin/activate # 가상환경활성화
deactivate # 가상환경 비활성화 
pip install mlflow==2.2.1 # mlflow 설치 

#### tracking server 만들기 

mlflow용 특정 디렉토리 생성. (~/workspace/lecture/mlflow-local 로 준비했음.)
해당 디렉토리에서 mlflow ui (-p 5000) # mlflow 연결, 기본 포트 5000임.
브라우저 127.0.0.1:5000 으로 mlflow ui에 접속
Experiments 생성. 디렉토리 tree에 하위 파일들 생성되는 것 확인가능. 

wget https://raw.githubusercontent.com/mlflow/mlflow/master/examples/sklearn_elasticnet_diabetes/linux/train_diabetes.py # 데이터셋 다운로드. 

mlflow.set_tracking_uri("http://localhost:5000")
mlflow.set_experiment("my-exp01") # 파일 내부에 세팅 추가. 
python train_diabetes.py # 실행. 이후 mlflow ui에 기록된 것 확인 가능.**

export MLPLOW_TRACKING_URI="http://localhost:5000" # 환경변수에 등록해놓으면 이후 파일 수정하지 않아도 됨.
mlflow run https://github.com/mlflow/mlflow-examplt.git # 깃허브 파일 실행도 가능. 

### serving

mlflow models serve -m runs:/194b834d595640adb80ab4facb4f4d44/model --no-conda -p 1234 # serve 명령어

curl http://localhost:1234/health # API요청 예시

curl -X POST -H "Content-Type:application/json" --data '{"dataframe_split": {"columns":["fixed acidity", "volatile acidity", "citric acid", "residual sugar", "chlorides", "free sulfur dioxide", "total sulfur dioxide", "density", "pH", "sulphates", "alcohol"],"data":[[6.2, 0.66, 0.48, 1.2, 0.029, 29, 75, 0.98, 3.33, 0.39, 12.8]]}}' http://localhost:1234/invocations # 요청하면 prediction 출력됨.

cli가 어려우면 postman 을 통해 serve 가능

mlflow models serve -m runs:/194b834d595640adb80ab4facb4f4d44/model --no-conda -p 1234