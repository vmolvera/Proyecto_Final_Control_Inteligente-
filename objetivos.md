---
layout: default
title: "2. Objetivos"
nav_order: 3
---

# 2. Objetivos

## 2.1 Objetivo general

Diseñar, entrenar, implementar y evaluar un controlador basado en una **Deep Q-Network (DQN)** para estabilizar el péndulo rotatorio del **Quanser QUBE-Servo 3** cerca de la posición vertical invertida y regular la posición angular del brazo.

## 2.2 Objetivos particulares

### 2.2.1 Modelado de la planta

Representar el movimiento del brazo y del péndulo mediante un modelo dinámico que sirva para entrenar el agente y diseñar el controlador.

### 2.2.2 Entrenamiento del DQN de balance

Desarrollar una política que seleccione el voltaje del motor a partir de las posiciones y velocidades angulares del brazo y del péndulo.

Formular el problema como un **proceso de decisión de Markov**, con un estado, un conjunto discreto de acciones de voltaje, una recompensa y condiciones de terminación.

### 2.2.3 Diseño del levantamiento y la transición a balance

Como extensión del control de balance, diseñar un agente DQN de **levantamiento autónomo** (*swing-up*) para llevar el péndulo desde la posición colgante hasta la región de captura.

Definir la región de captura en función del ángulo y la velocidad angular del péndulo. Diseñar un supervisor que transfiera el control al DQN de balance al cumplirse las condiciones de captura.
