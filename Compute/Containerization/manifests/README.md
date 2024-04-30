### sample-app.yaml

## Description:

This YAML configuration defines Kubernetes resources for deploying a web application consisting of a React frontend and a Flask backend. It includes Deployments, Services, and an Ingress resource for routing traffic to the appropriate services.

## React Frontend Deployment:

- **Name:** `react-app`
- **Replicas:** 1
- **Image:** `anurapa/react-app:v1.0`
- **Port:** 80
- **Node Selector:** Selects nodes with the specified `eks.amazonaws.com/nodegroup`.

## Flask Backend Deployment:

- **Name:** `flask-app`
- **Replicas:** 1
- **Image:** `anurapa/flask-app:v1.0`
- **Port:** 5000
- **Node Selector:** Selects nodes with the specified `eks.amazonaws.com/nodegroup`.

## Service Definitions:

- **Flask App Service:**
  - **Name:** `flask-app-service`
  - **Selectors:** Selects pods labeled with `app: flask-app`
  - **Port:** 5000

- **React App Service:**
  - **Name:** `react-app-service`
  - **Selectors:** Selects pods labeled with `app: react-app`
  - **Port:** 80

## Ingress Configuration:

- **Name:** `react-app-ingress`
- **Annotations:** 
  - `alb.ingress.kubernetes.io/scheme`: "internet-facing"
  - `alb.ingress.kubernetes.io/target-type`: "ip"
  - `alb.ingress.kubernetes.io/certificate-arn`: "" # Certificate ARN
- **Ingress Class:** "alb"
- **Rules:**
  - **Host:** `samplewebapp.co.uk`
    - **Paths:** 
      - `/`: Routes to the React app service on port 80.
      - `/api`: Routes to the Flask app service on port 5000.

