---
layout: default
title: "3. Metodología"
nav_order: 4
---

# 3. Metodología

El trabajo comenzó con la instrumentación del **Quanser QUBE-Servo 3**, a partir del modelo no lineal se entrenó el agente DQN de balance en Python, se verificó su ejecución en MATLAB y Simulink y se integró en una copia del modelo de laboratorio para realizar la prueba física. El levantamiento autónomo se planteó como una extensión de este procedimiento.

## 3.1 Plataforma experimental y señales

Se utilizó la unidad **Péndulo 2** del laboratorio. Sus encoders miden el ángulo del brazo $\theta$ y el ángulo del péndulo $\alpha$, medido respecto de la vertical invertida. Los observadores estiman las velocidades angulares a partir de esas mediciones. El estado que recibe el agente de balance sigue el orden $[\theta,\alpha,\dot{\theta},\dot{\alpha}]$ y la acción del controlador es el voltaje aplicado al motor, $V_m$.

En el equipo físico, **Quanser QUARC** comunica el modelo de Simulink con los encoders y el motor. La comparación entre simulación y laboratorio requiere usar las mismas convenciones de signo, unidades, referencias angulares y orden de estados.

## 3.2 Modelo no lineal 

El modelo no lineal del brazo y el péndulo se implementó en Python y MATLAB. Para poder comparar las ejecuciones, se documentan los parámetros de la planta y la discretización. La configuración de simulación usa un paso de integración de **2 ms** y actualiza la acción del agente cada **10 ms**.

## 3.3 Entrenamiento y transferencia del DQN

El balance se formuló como un problema de aprendizaje por refuerzo. En cada paso, el agente observa el estado, elige un voltaje de un conjunto discreto y recibe una recompensa de acuerdo con la respuesta del péndulo y del brazo. Las condiciones de terminación definen cuándo se da por concluido un episodio de entrenamiento.

El agente se entrenó en Python mediante **Double DQN** con el modelo no lineal. Los pesos se exportaron a un archivo **.mat** para ejecutar la política en MATLAB. La transferencia permite comprobar la selección de acciones y la respuesta en lazo cerrado antes de conectar el sistema físico.

## 3.4 Pruebas de simulación en MATLAB y Simulink

| Prueba | Archivo principal | Qué se comprueba |
|---|---|---|
| **A1. MATLAB** | `prueba_dqn_modelo_no_lineal` | Carga de la red, selección de acciones y respuesta del modelo no lineal con el DQN en lazo cerrado. |
| **A2. Simulink** | `construir_entorno_pruebas` | Integración de la política en el modelo virtual y evolución temporal del ángulo del brazo, el ángulo del péndulo y el voltaje de control. |

Las dos pruebas se ejecutaron en simulación. El registro de $\theta$, $\alpha$ y $V_m$ permite evaluar la respuesta del controlador además de comprobar que los scripts se ejecutan correctamente.

## 3.5 Levantamiento autónomo

Se planteó entrenar un segundo agente desde la posición colgante para llevar el péndulo hasta una región de captura. Un supervisor debe transferir el control al DQN de balance cuando el péndulo se encuentre cerca de la vertical superior y con una velocidad angular adecuada. La validación conjunta de levantamiento, transición y balance en la planta física queda pendiente.
