---
layout: default
title: Inicio
nav_order: 1
---

# Entrenamiento planta altamente no lineal por DQN

## Proyecto Final - Control Inteligente

**Quanser QUBE-Servo 3 · Equipo 3 · Péndulo 2**

Este portafolio digital documenta el desarrollo, implementación y evaluación experimental de un sistema **mediante Aprendizaje por Refuerzo Profundo** aplicado a un péndulo invertido **Quanser QUBE-Servo 3**.

El proyecto integra el **modelado dinámico no lineal del péndulo**, el diseño de un **controlador de referencia LQR**, la estimación de estados mediante observadores y el entrenamiento de una **red neuronal Deep Q-Network (DQN)** orientada a mantener el péndulo en su posición vertical invertida.

La implementación se desarrolló mediante **Python, MATLAB y Simulink**, utilizando **Quanser QUARC** para conectar los controladores con la planta física. Como ampliación, se desarrollaron diferentes versiones de una política neuronal de **levantamiento autónomo (Swing-Up)**, capaces de generar acciones para trasladar el péndulo desde su posición colgante hacia la región de equilibrio.

El trabajo permite estudiar el comportamiento de los controladores neuronales, sus condiciones de estabilidad, la influencia de los parámetros físicos y las diferencias entre los resultados obtenidos en simulación y en el sistema real.

---

## Información del proyecto

| Elemento | Información |
|---|---|
| Asignatura | Control Inteligente |
| Evaluación | Proyecto Final |
| Equipo | Equipo 3 |
| Planta asignada | Péndulo 2 |
| Plataforma | Quanser QUBE-Servo 3 |
| Técnica de control inteligente | Deep Q-Network (DQN) |
| Desarrollo | Python, MATLAB y Simulink |
| Periodo | Otoño 2026 |

---

## Demostración experimental

Como parte de la evaluación del sistema, se realizaron pruebas de simulación y experimentales sobre el **Quanser QUBE-Servo 3**, con el propósito de analizar la capacidad de los controladores para mantener el equilibrio del péndulo y estudiar el levantamiento autónomo.

Las pruebas comprenden:

- **Controlador LQR:** Estabilización del péndulo físico mediante realimentación de estados.
- **DQN Balance:** Evaluación del controlador neuronal en MATLAB, Simulink y el equipo físico.
- **DQN Swing-Up:** Desarrollo y evaluación de políticas de levantamiento autónomo, con diferentes configuraciones de entrenamiento, robustez y filtrado.

---

## Objetivos principales

El desarrollo del proyecto comprende cinco etapas principales:

1. **Modelado matemático del QUBE-Servo 3**, utilizando las ecuaciones dinámicas no lineales que describen el movimiento del brazo rotatorio y del péndulo.
2. **Diseño e implementación de un controlador LQR de referencia**, para comprobar la estabilidad del sistema y disponer de una base de comparación.
3. **Diseño, entrenamiento y evaluación de un agente DQN**, capaz de seleccionar acciones de voltaje a partir del estado del sistema para estabilizar el péndulo invertido.
4. **Implementación y validación experimental**, mediante MATLAB, Simulink y Quanser QUARC, comparando el comportamiento del modelo simulado con la planta física.
5. **Desarrollo y evaluación de políticas Swing-Up**, orientadas al levantamiento autónomo del péndulo y al mejoramiento de la estabilidad y robustez del control neuronal.

---

## Plataforma experimental

El sistema utilizado está compuesto por:

- **Quanser QUBE-Servo 3**, como plataforma electromecánica de experimentación.
- **Brazo rotatorio accionado por un motor de corriente continua**, encargado de generar el movimiento de control.
- **Péndulo rotatorio**, cuyo movimiento depende del acoplamiento dinámico con el brazo.
- **Encoders**, para medir las posiciones angulares del brazo y del péndulo.
- **MATLAB y Simulink**, para modelado, análisis dinámico, implementación y supervisión.
- **Python**, para el desarrollo y entrenamiento de las redes neuronales DQN.
  
---

## Arquitectura general del proyecto

El procedimiento desarrollado sigue la secuencia:

1. **Quanser QUBE-Servo 3:** Sistema físico y modelo dinámico no lineal.
2. **Medición de estados:** Adquisición de las posiciones angulares del brazo y del péndulo mediante encoders.
3. **Estimación de velocidades:** Procesamiento de las mediciones mediante observadores de estado.
4. **Control neuronal:** Políticas DQN para calcular el voltaje de control.
   - **DQN Balance:** Estabilización cerca de la posición invertida.
   - **DQN Swing-Up:** Levantamiento autónomo desde la posición colgante, con diferentes versiones de implementación.
5. **Aplicación del voltaje:** Accionamiento del motor mediante las señales de control y los límites de seguridad configurados.
6. **Realimentación:** Adquisición de nuevos estados para calcular las siguientes acciones.
7. **Validación:** Análisis de los ángulos, voltajes, estabilidad y comportamiento experimental.

La arquitectura de referencia utiliza el vector de estados:

$$
X=\begin{bmatrix}
\theta & \alpha & \dot{\theta} & \dot{\alpha}
\end{bmatrix}^{T}
$$

donde $\theta$ representa el ángulo del brazo rotatorio y $\alpha$ el ángulo del péndulo respecto a la posición invertida.

El controlador DQN de estabilización recibe estos estados y selecciona una acción entre **11 niveles discretos de voltaje**, con un periodo de decisión de **10 ms**. El modelo utiliza un paso de simulación de **2 ms**.

El desarrollo de Swing-Up incorpora políticas neuronales y estrategias adicionales de tratamiento de señales y robustez. La integración de ambas tareas debe evaluarse considerando las condiciones de captura y las limitaciones físicas del equipo.

---

## Resultados principales

El sistema se evaluó mediante pruebas de simulación, análisis de robustez y experimentos sobre la planta física.

| Prueba | Resultado reportado |
|---|---:|
| Comparación de decisiones MATLAB–Python | 0 diferencias en 200 estados |
| Validación durante el entrenamiento en Python | 98.8 % de éxito |
| Monte Carlo en MATLAB | 99.6 % de éxito |
| Número de escenarios Monte Carlo | 500 |
| Variación paramétrica de esa evaluación | ±15 % |
| Estabilización desde $\alpha_0=10^\circ$ | Menos de 1s |
| Recuperación ante perturbación de velocidad | Menos de 1s |

Estos resultados corresponden a las pruebas de simulación documentadas en el repositorio técnico y no deben interpretarse como porcentajes de éxito experimental en el QUBE físico.

---

## Código y reproducción del proyecto

El código fuente del proyecto se encuentra organizado en archivos de Python, MATLAB y Simulink, junto con los pesos de las redes neuronales entrenadas.

**[Repositorio técnico del equipo — Código y modelos](https://github.com/sebastiux/cubeservoquansecontrol)**
**[Repositorio del portafolio — Documentación](https://github.com/vmolvera/Proyecto_Final_Control_Inteligente-)**

En las siguientes secciones se describen los archivos, sus funciones, las herramientas utilizadas y los procedimientos necesarios para reproducir las pruebas de simulación y evaluar los controladores.

La reproducción sobre el sistema físico requiere una instalación compatible de Quanser QUARC, comprobación de los límites de actuación y supervisión del laboratorio.

---

## Integrantes

**Equipo 3 — Péndulo 2**

- Carlos Sebastián Ortega Hernández
- Víctor Manuel Olvera de la Cruz
- Joel Alberto RioValle 
