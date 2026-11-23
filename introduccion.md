---
layout: default
title: "1. Introducción"
nav_order: 2
---
# 1. Introducción

El péndulo rotatorio de Furuta es un sistema subactuado, no lineal e inestable alrededor de su posición invertida. El motor actúa sobre el brazo rotatorio, mientras que el péndulo responde por acoplamiento dinámico.

El proyecto del **Equipo 3 — Péndulo 2** aborda la estabilización mediante aprendizaje por refuerzo profundo. Se compara la política aprendida con un controlador LQR de referencia construido a partir de un modelo linealizado.

La implementación inicial utiliza una red DQN de balance; como extensión se considera un segundo agente para levantamiento autónomo y transferencia por supervisor. Esta extensión no equivale a haber demostrado todavía la estabilización real.

## Variables

- \(\theta\): ángulo del brazo rotatorio.
- \(\alpha\): ángulo del péndulo, medido respecto de la vertical invertida.
- \(\dot\theta,\dot\alpha\): velocidades estimadas a partir de los encoders mediante observadores.
- \(V_m\): tensión aplicada al motor.

El objetivo principal es \(\alpha
ightarrow0\) y \(\theta
ightarrow0\), sin rebasar los límites de seguridad del equipo.
