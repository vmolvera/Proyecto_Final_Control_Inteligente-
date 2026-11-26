---
layout: default
title: "2. Objetivos"
nav_order: 3
---

# 2. Objetivos

## 2.1 Objetivo general

Diseñar, entrenar, implementar y evaluar un controlador basado en una **Deep Q-Network (DQN)** para estabilizar el péndulo rotatorio del **Quanser QUBE-Servo 3** cerca de la posición vertical invertida y regular la posición angular del brazo.

El proyecto busca comparar el desempeño del DQN con el de un **regulador cuadrático lineal (LQR)** y establecer en qué medida la respuesta obtenida en simulación se reproduce en el equipo físico.

## 2.2 Objetivos particulares

### 2.2.1 Modelado de la planta y diseño del LQR

Representar el movimiento del brazo y del péndulo mediante un modelo dinámico que sirva para entrenar el agente y diseñar el controlador de referencia.

- Implementar el modelo no lineal y contrastar su respuesta con mediciones del equipo físico obtenidas en condiciones comparables.
- Linealizar el modelo alrededor del equilibrio invertido y diseñar el LQR para utilizarlo como referencia de balance.

### 2.2.2 Entrenamiento del DQN de balance

Desarrollar una política que seleccione el voltaje del motor a partir de las posiciones y velocidades angulares del brazo y del péndulo.

- Formular el problema como un **proceso de decisión de Markov**, con un estado, un conjunto discreto de acciones de voltaje, una recompensa y condiciones de terminación.
- Entrenar el agente con el modelo no lineal y evaluar su respuesta en simulación ante condiciones iniciales y perturbaciones variadas.

### 2.2.3 Integración y evaluación del controlador

Integrar la política entrenada en **MATLAB y Simulink** para utilizarla dentro del lazo de control del péndulo.

- Conectar la política con las posiciones medidas por los encoders y las velocidades estimadas mediante observadores.
- Comparar el desempeño del DQN y del LQR, contrastar las respuestas de simulación y laboratorio y analizar las posibles causas de sus diferencias.
- Evaluar en simulación la robustez frente a variaciones de hasta **±2 %** en los parámetros nominales del modelo.

### 2.2.4 Diseño del levantamiento y la transición a balance

Como extensión del control de balance, diseñar un agente DQN de **levantamiento autónomo** (*swing-up*) para llevar el péndulo desde la posición colgante hasta la región de captura.

- Definir la región de captura en función del ángulo y la velocidad angular del péndulo.
- Diseñar un supervisor que transfiera el control al DQN de balance al cumplirse las condiciones de captura.

## 2.3 Criterios de evaluación

El desempeño se evaluará mediante el error angular, el rango de movimiento del brazo, el tiempo de recuperación, el esfuerzo de control, la proporción de episodios exitosos y la respuesta ante variaciones paramétricas. Las pruebas físicas se realizarán con las protecciones del equipo y bajo supervisión de laboratorio.
