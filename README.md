# RoCa Motors – Demostración de Infraestructura como Código (IaC)

Este repositorio contiene la **implementación demostrativa** de la infraestructura cloud para **RoCa Motors**, desarrollada como parte del **Portafolio de Título (PTY4684)** de la carrera *Ingeniería en Infraestructura y Plataformas Tecnológicas – Duoc UC*.

El despliegue se ejecuta en el **laboratorio educativo de AWS**, con el objetivo de **validar la automatización de infraestructura, la orquestación de contenedores y la aplicación de buenas prácticas DevOps**, utilizando **Terraform, Docker y GitHub Actions**.

> ⚠️ **Nota:** Esta implementación corresponde a una *demo técnica controlada* dentro del entorno de laboratorio.  
> No replica la totalidad de la arquitectura productiva propuesta en el informe principal, pero conserva su estructura lógica, principios de resiliencia y lineamientos de seguridad.

---

## **Objetivo de la Demostración**

Implementar un entorno funcional que permita demostrar:

- Despliegue automatizado mediante **Infraestructura como Código (IaC)**.
- Integración con **GitHub Actions** para CI/CD.
- Ejecución de contenedores con **Amazon EKS** o **ECS Fargate (según disponibilidad del lab)**.
- Gestión del estado remoto en **S3** y control de versiones.
- Destrucción controlada del entorno para validar el ciclo completo de IaC.

---

## **Componentes Principales**

| Componente | Propósito |
|-------------|-----------|
| **Terraform** | Define y versiona la infraestructura (VPC, EKS/ECS, ALB, RDS, S3, SNS). |
| **AWS S3** | Backend remoto para almacenar el `terraform.tfstate`. |
| **DockerHub** | Repositorio de la imagen de la aplicación web RoCa Motors. |
| **Amazon EKS / ECS** | Orquestación de contenedores. |
| **GitHub Actions** | Automatización del pipeline de plan, apply y destroy. |
| **SNS + CloudWatch** | Monitoreo y notificaciones básicas. |

---
```bash

## **Estructura del Repositorio**

rocamotors-iac/
├── modules/
│ ├── vpc/
│ ├── eks/
│ ├── alb/
│ ├── webapp/
│ └── sns/
├── web/
│ ├── Dockerfile
│ ├── index.html
│ └── assets/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── .github/
└── workflows/
├── terraform.yml # CI/CD principal (plan & apply)
└── terraform-destroy.yml # Pipeline de destrucción controlada
```
---

## ⚙️ **Backend remoto (S3)**

El estado se almacena en un bucket S3 para mantener consistencia entre los workflows:

```hcl
terraform {
  backend "s3" {
    bucket = "rocamotors-terraform-state"
    key    = "demo/terraform.tfstate"
    region = "us-east-1"
  }
}
Esto permite que el pipeline de apply y destroy acceda al mismo estado sin intervención manual

---
## **Objetivo de la Demostración**

## **CI/CD – GitHub Actions** 

El pipeline terraform.yml realiza:

terraform fmt → verificación de formato
terraform init → inicialización del backend
terraform validate → validación sintáctica
terraform plan → vista previa de cambios
terraform apply → ejecución automática en rama main

Los secretos de AWS se administran mediante GitHub Secrets:

AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN

Para la destrucción controlada se dispone de terraform-destroy.yml, ejecutable manualmente desde la interfaz de GitHub Actions.
```
---
🧠 Limitaciones y Alcance

Se ejecuta dentro de las cuotas del laboratorio AWS Educate / Academy, con restricciones de recursos.
Se prioriza la demostración funcional de IaC por sobre la escala productiva.
El despliegue no incluye servicios avanzados de seguridad (WAF Advanced, CloudFront, KMS dedicado), pero mantiene cifrado básico y políticas IAM.
El modelo es referencial y validado conceptualmente según el informe “Implementación de Infraestructura Resiliente AWS para RoCa Motors”.
