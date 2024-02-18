# 이미지 목록
$images = @(
    "grafana/grafana:10.2.4",
    "postgres:13",
    "prom/prometheus:latest",
    "redis:latest",
    "apache/airflow:2.7.3-python3.11",
    "prom/statsd-exporter:latest"
)

# 백업 디렉토리 생성
$backupDir = "docker_images_backup"
New-Item -ItemType Directory -Force -Path $backupDir

foreach ($image in $images) {
    # 이미지 다운로드 (pull)
    Write-Host "Pulling $image..."
    docker pull $image

    # 파일 이름 정의 (이미지 이름에서 '/', ':', 공백을 '_'로 변경)
    $fileName = $image -replace "[/: ]", "_"
    $filePath = Join-Path $backupDir "$fileName.tar"

    # 이미지 저장
    Write-Host "Saving $image to $filePath"
    docker save -o $filePath $image
}

Write-Host "All images have been saved."
