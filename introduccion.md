---
layout: default
title: "1. Introducción"
nav_order: 2
---

# 1. Introducción

El **Quanser QUBE-Servo 3** permite estudiar el control de un péndulo rotatorio de Furuta. El motor acciona el brazo horizontal y el péndulo se mueve por acoplamiento dinámico con el brazo. Como el péndulo carece de un actuador propio, el sistema es subactuado. Su dinámica es no lineal y el equilibrio en la vertical superior es inestable. Para mantenerlo invertido, el controlador debe corregir las desviaciones del péndulo mientras regula la posición angular del brazo.

En este proyecto, el **Equipo 3** trabajó con la unidad **Péndulo 2**. La estrategia de balance utiliza una **Deep Q-Network (DQN)** para seleccionar el voltaje del motor entre un conjunto de acciones discretas. La red se entrenó en simulación con un modelo no lineal de la planta y se evaluó en MATLAB y Simulink. El **regulador cuadrático lineal (LQR)**, diseñado a partir de un modelo linealizado alrededor del equilibrio invertido, sirve como referencia para comparar el desempeño en simulación y en el equipo físico.

Para abordar el arranque desde la posición colgante, se planteó una arquitectura de dos agentes. El agente de *swing-up* eleva el péndulo y un supervisor transfiere el control al agente de balance cuando el péndulo entra en la región de captura con una velocidad angular adecuada. La operación conjunta de ambos agentes queda pendiente de validación en el equipo físico.

## Variables

| Variable | Significado |
|---|---|
| $\theta$ | Ángulo del brazo rotatorio, medido por un encoder. |
| $\alpha$ | Ángulo del péndulo, medido por un encoder y referido a la vertical invertida. |
| $\dot{\theta}$, $\dot{\alpha}$ | Velocidades angulares del brazo y del péndulo, estimadas a partir de las mediciones de los encoders mediante observadores. |
| $V_m$ | Voltaje aplicado al motor. |

Durante el balance se busca mantener $\alpha$ y $\theta$ cerca de cero, dentro de los límites de operación del equipo.

[Continuar a Objetivos]({{ '/objetivos.html' | relative_url }})
