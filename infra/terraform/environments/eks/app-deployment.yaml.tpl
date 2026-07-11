apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${app_name}
  labels:
    app: ${app_name}
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ${app_name}
  template:
    metadata:
      labels:
        app: ${app_name}
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8000"
    spec:
      containers:
        - name: fastapi
          image: ${app_image}
          ports:
            - containerPort: 8000
          env:
%{ for key, value in app_env ~}
            - name: ${key}
              value: "${value}"
%{ endfor ~}
---
apiVersion: v1
kind: Service
metadata:
  name: ${app_name}
spec:
  selector:
    app: ${app_name}
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8000
