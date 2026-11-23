---
layout: default
title: Inicio
nav_order: 1
permalink: /
---
# Control inteligente mediante Deep Q-Learning
## Proyecto final — Equipo 3 · Péndulo 2

**Quanser QUBE-Servo 3 · Péndulo rotatorio invertido · Otoño 2026**

Este portafolio documenta el modelado y el control inteligente del péndulo invertido mediante una red neuronal **Deep Q-Network (DQN)**. La implementación base se desarrolló en Python, MATLAB y Simulink, con transferencia al equipo físico mediante Quanser QUARC. Como ampliación se plantea una segunda política DQN para el levantamiento autónomo (*swing-up*) y un supervisor de conmutación para la estabilización.

> **Estado de validación:** el controlador LQR de referencia estabilizó el péndulo físico. Los scripts DQN se ejecutaron en MATLAB y Simulink; durante la prueba física inicial, el DQN de balance produjo oscilaciones rápidas sin lograr estabilización sostenida. La arquitectura Swing-Up + Balance permanece en desarrollo y no debe reportarse como validada en hardware.

---
## Información del proyecto

| Elemento | Descripción |
|:--|:--|
| Universidad | Universidad Iberoamericana Ciudad de México |
| Asignatura | Control Inteligente |
| Evaluación | Proyecto final — Aprendizaje reforzado |
| Equipo | Equipo 3 |
| Planta | Péndulo 2, Quanser QUBE-Servo 3 |
| Técnicas | Deep Q-Network, comparación con LQR |
| Herramientas | Python, MATLAB, Simulink, Quanser QUARC |
| Periodo | Otoño 2026 |

---
## Objetivo principal

Estabilizar el péndulo rotatorio cerca de la posición invertida \(\alpha=0\), manteniendo el brazo cerca de \(\theta=0\), mediante una política DQN entrenada en simulación y evaluada experimentalmente. Como extensión, desarrollar un agente de *swing-up* que transfiera el control a la política de balance al cumplirse condiciones de captura.

## Arquitectura general

```text
QUBE-Servo 3 (modelo simulado / planta real)
            ↓
Encoders y observadores de velocidad
            ↓
Estado X = [θ, α, θ̇, α̇]
            ↓
     Supervisor de modos
        ↙           ↘
 DQN Swing-Up     DQN Balance
 (desarrollo)    (red existente)
        ↘           ↙
   Selección de una acción
            ↓
   Límites y paro seguro
            ↓
       Motor del QUBE
```

## Estado del trabajo

| Etapa | Evidencia disponible |
|:--|:--|
| Modelo lineal y LQR | Estabilización física observada |
| DQN Balance: prueba A1 | Script MATLAB ejecutado sin error informado |
| DQN Balance: prueba A2 | Simulink virtual ejecutado; faltan métricas exportadas |
| DQN Balance: planta física | Oscila y no mantiene el equilibrio |
| DQN Swing-Up + supervisor | Propuesta / desarrollo en simulación; pendiente validación |

## Navegación

Las secciones documentan el problema, modelo dinámico, formulación del aprendizaje, implementación, resultados, robustez, código y conclusiones. Las cifras atribuidas al repositorio del equipo se distinguen de los datos experimentales confirmados.
