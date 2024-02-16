#!/bin/bash

# 필요한 스크립트 실행 권한 부여
chmod +x /opt/airflow/wait-for-it.sh

# PostgreSQL 및 Redis가 준비될 때까지 대기
/opt/airflow/wait-for-it.sh postgres:5432 --timeout=30 &&
/opt/airflow/wait-for-it.sh redis:6379 --timeout=30 &&

# Airflow DB 초기화 및 기본 사용자 생성
airflow db init &&
if [ $? -eq 0 ]; then
  airflow users create --role Admin --username admin --password password --email airflow@airflow.com --firstname first --lastname last
else
  echo 'airflow db init failed'
  exit 1
fi
