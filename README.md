# CI/CD con AWS, Terraform, GitHub Actions y ECS (Fargate) – Django

Este proyecto implementa un pipeline **CI/CD completo** para una aplicación **Python (Django)** usando:

- Docker
- Amazon ECR
- Amazon ECS (Fargate)
- Application Load Balancer (ALB)
- Terraform (backend remoto en S3 + DynamoDB)
- GitHub Actions

La infraestructura se puede **levantar y destruir bajo demanda** para minimizar costos.

---

## Requisitos previos

### Local
- Python 3.11+
- Docker Desktop
- Terraform >= 1.5
- AWS CLI configurado
- Git

### AWS
- Cuenta AWS
- Repositorio ECR creado (ejemplo):
- Usuario IAM con permisos para:
- ECR
- S3
- DynamoDB
- ECS / ELB / VPC

### GitHub
- Repo creado
- Secrets configurados:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

---

## Estructura del proyecto
├── app/ # Aplicación Django
│ ├── Dockerfile
│ ├── requirements.txt
│ ├── manage.py
│ └── mysite/
├── infra/
│ └── terraform/
│ ├── bootstrap/ # Backend Terraform (S3 + DynamoDB)
│ └── envs/dev/ # Infra ECS + ALB + VPC
└── .github/
└── workflows/
├── ci.yml # Build & push imagen
└── deploy.yml # Deploy con Terraform


---

## Paso 1 – Ejecutar la app localmente (opcional)

```bash
python -m venv .venv
source .venv/Scripts/activate   # Git Bash
pip install -r app/requirements.txt
python app/manage.py runserver 0.0.0.0:8000
abrir: http://localhost:8000/
```

## Paso 2 Construir imagen y probar local
docker build -t django-hello -f app/Dockerfile app
docker run --rm -p 8000:8000 django-hello

## Paso 3 
El workflow CI se ejecuta automáticamente al hacer push a main.

Acciones que realiza:
Build de imagen Docker desde app/
Tag:
latest
sha-<commit>
Push a Amazon ECR
Archivo:
.github/workflows/ci.yml

Verificar:
GitHub → Actions → CI en verde
AWS → ECR → imágenes visibles

## Paso 4 
Bootstrap de Terraform (una sola vez)

Desde local:
cd infra/terraform/bootstrap
terraform init
terraform apply

Guardar los outputs:
Nombre del bucket S3
Nombre de la tabla DynamoDB
Región

## Paso 5
Configurar backend remoto 
Bootstrap de Terraform (una sola vez)

Desde local:
cd infra/terraform/bootstrap
terraform init
terraform apply

Guardar los outputs:
Nombre del bucket S3
Nombre de la tabla DynamoDB
Región

## Paso 6 Levantar infraestructura
Opción A – Local
cd infra/terraform/envs/dev
terraform init -reconfigure
terraform apply

Opción B – GitHub Actions (recomendado)
Workflow CD:
.github/workflows/deploy.yml

Ejecutar desde GitHub Actions:
Input image_tag:
sha-<commit>

## Paso 7 – Verificar despliegue

Terraform output:
alb_dns_name
Abrir en navegador:
http://<alb_dns_name>/

Respuesta esperada:
{"message":"Hello from Django"}

## Destrucción de infraestructura (importante)
Destruir entorno dev
cd infra/terraform/envs/dev
terraform destroy

Destruir bootstrap (opcional)
cd infra/terraform/bootstrap
terraform destroy
