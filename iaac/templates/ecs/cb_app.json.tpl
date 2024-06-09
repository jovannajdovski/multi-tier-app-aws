[
    {
      "name": "cb-app",
      "image": "${app_image}",
      "cpu": 0,
      "networkMode": "awsvpc",
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "/ecs/cb-app",
            "awslogs-region": "${app_region}",
            "awslogs-stream-prefix": "ecs"
          }
      },
      "portMappings": [
        {
            "containerPort": 80,
            "hostPort": 80,
            "protocol": "tcp",
            "appProtocol": "http"
        },
        {
            "containerPort": 443,
            "hostPort": 443,
            "protocol": "tcp"
        }
    ]
    }
  ]