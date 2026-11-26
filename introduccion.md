---
layout: default
title: "1. Introducción"
nav_order: 2
---

# 1. Introducción

El control de un **péndulo rotatorio de fruta** plantea un desafío porque su dinámica es no lineal y el equilibrio en la vertical superior es inestable. Una pequeña desviación puede alejar al péndulo de esa posición, por lo que el controlador debe corregir su movimiento mientras regula la posición angular del brazo.

En este proyecto, el **Equipo 3** trabajó con la unidad **Péndulo 2** del **Quanser QUBE-Servo 3**. El motor acciona el brazo horizontal y el péndulo se mueve por acoplamiento dinámico con el brazo. Como el péndulo carece de un actuador propio, el sistema es subactuado.

El proyecto aplica **aprendizaje por refuerzo profundo** para estudiar la estabilización del péndulo mediante una **Deep Q-Network (DQN)**. El agente de balance selecciona el voltaje del motor entre un conjunto de acciones discretas. La red se entrenó con un modelo no lineal de la planta y se evaluó en MATLAB y Simulink.

Los encoders registran las posiciones angulares del brazo y del péndulo. Las velocidades angulares se estiman a partir de esas mediciones. Con estas cuatro variables, el controlador determina la siguiente acción conforme cambia el estado del sistema.

Para abordar el arranque desde la posición colgante, se planteó una arquitectura de dos agentes con funciones distintas:

1. **Agente de levantamiento (*swing-up*).** Acerca el péndulo a la vertical superior desde su posición colgante.
2. **Agente de balance.** Busca mantener el péndulo cerca de la vertical superior y regular la posición del brazo.

Un supervisor transfiere el control al agente de balance cuando el péndulo entra en la región de captura con una velocidad angular adecuada.

El desarrollo del proyecto comprende las siguientes etapas:

1. **Modelado de la planta.** Representación de la dinámica no lineal del brazo y del péndulo.
2. **Diseño del controlador de referencia.** Linealización alrededor del equilibrio invertido y diseño del regulador cuadrático lineal (LQR).
3. **Entrenamiento del agente de balance.** Definición del estado, las acciones de voltaje y la recompensa para entrenar la DQN en simulación.

El **LQR** proporciona una referencia para comparar el comportamiento de los controladores cerca del equilibrio invertido. Durante el balance se busca mantener $\alpha$ y $\theta$ cerca de cero, dentro de los límites de operación del equipo. La comparación entre simulación y planta física permite identificar hasta qué punto el comportamiento observado en el modelo se reproduce en el QUBE-Servo 3.
