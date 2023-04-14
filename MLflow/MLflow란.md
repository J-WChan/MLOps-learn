# MLflow

### MLflow란
- 머신러닝 실험, 배포에 용이한 오픈소스
- CLI, GUI 지원

```python
# Tracking 

import numpy as np
import mlflow

def main() :
    #enable autologging
    mlflow.autolog(log_input_example=true)
```

로그를 쉽게 기록할 수 있음.

### MLflow 핵심기능
- Experient Management & Tracking
  - 실험들을 관리, 내용을 기록
  - parameter, Metric, Artifacts 등 저장

- Model Registry
  - MLflow를 실행한 모델을 모델 저장소에 등록할 수 있음
  - 공유 용이. 
  - 저장시 모델의 버전 자동 업데이트


### MLflow Tracking

- 머신러닝 코드 실행시 패러미터, 결과 등을 저장하고 시각화하는 API와 UI를 제공.

- run시 기록되는 정보
  - Code Version
  - Start & End Time
  - Source
  - Parameters
  - Metrics
  - Artifacts(출력파일)

기록위치
    - local
    - Database(mysql,mssql,sqlite,postgresql)
    - Remote Server