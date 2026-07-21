# Credit Risk Modeling

O projeto possui dois experimentos reproduzíveis e rastreados no MLflow:

1. O notebook `notebooks/03_PROCESSING_TRAING_MODEL.ipynb` compara os modelos de
   base com validação cruzada, escolhe o campeão e o avalia no conjunto de teste.
2. No mesmo notebook, o segundo experimento otimiza os hiperparâmetros do campeão
   usando validação cruzada, sem usar o conjunto de teste para a escolha.

## Executar com Docker

Os Dockerfiles ficam centralizados em `docker/`. Cada novo serviço deve ter seu
próprio arquivo nesse diretório (por exemplo, `Dockerfile.streamlit` e
`Dockerfile.grafana`) e ser referenciado pelo `docker-compose.yml`.

```bash
docker compose up -d mlflow
docker compose up --build notebook
```

Abra `http://localhost:8888` para executar o notebook no container e
`http://localhost:5000` para consultar os experimentos, métricas, gráficos e modelos.
O volume `mlflow_data` mantém o banco SQLite e os artefatos entre reinícios.

O pré-processador final é registrado no Model Registry como `model-preprocessing`.
