
---
layout: default
title: Inicio
nav_order: 1
permalink: /
---

# Control inteligente del péndulo invertido

## Proyecto Final - Control Inteligente

**Quanser QUBE-Servo 3 · Equipo 3 · Péndulo 2 · Otoño 2026**

Este portafolio digital documenta el desarrollo, implementación y evaluación de un sistema de **Control Inteligente mediante Aprendizaje por Refuerzo Profundo (Deep Reinforcement Learning)** aplicado al péndulo rotatorio invertido **Quanser QUBE-Servo 3**.

El proyecto se centra en el diseño de un controlador neuronal basado en **Deep Q-Network (DQN)**, capaz de seleccionar acciones de control para mantener el péndulo cerca de su posición vertical invertida, mientras regula el movimiento del brazo rotatorio.

El desarrollo comprende el modelado dinámico del sistema, la formulación del problema de aprendizaje, el entrenamiento de redes neuronales, la evaluación mediante simulación y la integración del controlador con la planta física utilizando **Python, MATLAB, Simulink y Quanser QUARC**.

Adicionalmente, se estudia el **levantamiento autónomo del péndulo (Swing-Up)** mediante políticas neuronales, así como la transición hacia el control de equilibrio. Las distintas versiones desarrolladas permiten analizar la influencia del modelo dinámico, las perturbaciones, los retardos y el filtrado de la señal de control.

---

## Información del proyecto

| Elemento | Información |
|---|---|
| Universidad | Universidad Iberoamericana Ciudad de México |
| Asignatura | Control Inteligente |
| Evaluación | Proyecto Final - Aprendizaje por Refuerzo |
| Equipo | Equipo 3 |
| Planta asignada | Péndulo 2 |
| Plataforma | Quanser QUBE-Servo 3 |
| Sistema | Péndulo rotatorio invertido |
| Técnica principal | Deep Q-Network (DQN) |
| Controlador de referencia | Regulador Lineal Cuadrático (LQR) |
| Desarrollo | Python, MATLAB y Simulink |
| Implementación física | Quanser QUARC |
| Periodo | Otoño 2026 |

---

## Objetivos principales

El objetivo general del proyecto es **diseñar, entrenar y evaluar un agente de aprendizaje por refuerzo profundo para estabilizar el péndulo rotatorio invertido**, utilizando un modelo dinámico no lineal y evaluando su comportamiento tanto en simulación como en la planta física.

Para alcanzarlo se consideran las siguientes etapas:

1. **Modelado dinámico:** implementar y validar las ecuaciones que describen el comportamiento del QUBE-Servo 3.

2. **Diseño del agente DQN:** definir estados, acciones, función de recompensa, arquitectura neuronal y parámetros de entrenamiento.

3. **Entrenamiento y simulación:** desarrollar una política de control y evaluar su capacidad para mantener el equilibrio ante distintas condiciones iniciales y perturbaciones.

4. **Implementación experimental:** integrar la red entrenada con Simulink y Quanser QUARC para estudiar su desempeño en la planta física.

5. **Análisis de robustez:** evaluar las variaciones paramétricas, las limitaciones del modelo y las diferencias entre simulación y realidad.

6. **Levantamiento autónomo:** desarrollar y evaluar políticas Swing-Up capaces de trasladar el péndulo desde la posición colgante hacia la región invertida.

---

## Plataforma experimental

El sistema utilizado está compuesto por:

- **Quanser QUBE-Servo 3:** plataforma electromecánica con motor de corriente continua y brazo rotatorio.
- **Módulo de péndulo:** mecanismo que se mueve por el acoplamiento dinámico con el brazo accionado.
- **Encoders:** sensores utilizados para obtener las posiciones angulares del brazo y del péndulo.
- **Observadores de velocidad:** permiten estimar las velocidades angulares necesarias para la realimentación.
- **Computadora de laboratorio:** utilizada para modelado, simulación y ejecución de los controladores.
- **MATLAB y Simulink:** herramientas de análisis, simulación y construcción del sistema de control.
- **Quanser QUARC:** interfaz para la implementación y supervisión del controlador en tiempo real.
- **Python:** entorno empleado para desarrollar y entrenar las redes neuronales.

El péndulo es un sistema **no lineal, subactuado e inestable en su posición invertida**. El motor actúa directamente sobre el brazo rotatorio, mientras que el movimiento del péndulo se controla indirectamente mediante el acoplamiento entre ambos cuerpos.

---

## Arquitectura general del proyecto

El desarrollo parte de la medición de los estados de la planta y utiliza una red neuronal para calcular el voltaje que debe aplicarse al motor.

```text
            QUANSER QUBE-SERVO 3
                     |
                     v
          Medición de los ángulos
             theta y alpha
                     |
                     v
         Estimación de velocidades
           theta_dot y alpha_dot
                     |
                     v
           Vector de observación
                     |
                     v
            Controlador neuronal
                     |
              Acción de control
                     |
                     v
              Motor del QUBE
                     |
                     v
           Nueva respuesta física
                     |
               Realimentación
```

Se estudian dos tareas de control:

**Estabilización (DQN Balance):** mantener el péndulo próximo a la vertical invertida cuando comienza dentro de una región cercana al equilibrio.

**Levantamiento autónomo (DQN Swing-Up):** generar movimientos del brazo que permitan elevar el péndulo desde su posición colgante. El repositorio técnico del equipo documenta distintas versiones de esta política, con mejoras progresivas en el entrenamiento y filtrado.

La integración y selección de políticas debe analizarse junto con las condiciones de captura, límites de movimiento y protecciones del sistema.

---

## Metodología general

El trabajo se desarrolló siguiendo una secuencia de modelado, diseño, entrenamiento y experimentación.

| Etapa | Actividad |
|---|---|
| 1. Modelado | Obtención de parámetros y representación dinámica |
| 2. Control de referencia | Diseño y prueba del controlador LQR |
| 3. Entorno DQN | Construcción del modelo no lineal para entrenamiento |
| 4. Aprendizaje | Entrenamiento de la política neuronal |
| 5. Validación | Pruebas en Python, MATLAB y Simulink |
| 6. Transferencia | Integración del controlador con Quanser QUARC |
| 7. Mejoras | Evaluación de Swing-Up, robustez y filtrado |
| 8. Documentación | Comparación de resultados y análisis experimental |

Cada una de estas etapas se presenta en las secciones del portafolio, incluyendo sus fundamentos, parámetros, archivos y procedimientos de reproducción.

---

## Resultados y estado de validación

Durante el proyecto se obtuvieron resultados tanto con el controlador convencional LQR como con las políticas neuronales desarrolladas.

| Evaluación | Estado documentado |
|---|---|
| Controlador LQR | Estabilización del péndulo físico comprobada en laboratorio |
| DQN Balance en MATLAB | Scripts de evaluación ejecutados |
| DQN Balance en Simulink | Pruebas realizadas sobre el modelo no lineal |
| DQN Balance físico inicial | Oscilaciones rápidas sin estabilización sostenida |
| DQN Swing-Up | Versiones de entrenamiento y pruebas descritas en el repositorio técnico |
| Validación final integrada | Requiere consolidar las evidencias experimentales |

El repositorio técnico del equipo publica resultados adicionales de simulación y pruebas de diferentes versiones Swing-Up. Estas cifras se analizarán en la sección de resultados, distinguiendo los resultados reportados, los reproducidos y los verificados experimentalmente.

El análisis de las diferencias entre simulación y planta real es parte fundamental del proyecto, ya que permite identificar limitaciones del modelo y oportunidades de mejora del controlador.

---

## Código fuente y reproducibilidad

Los programas del proyecto se encuentran organizados en archivos Python, MATLAB y Simulink.

**[Consultar el repositorio técnico del equipo](https://github.com/sebastiux/cubeservoquansecontrol)**

**[Consultar el repositorio de documentación](https://github.com/vmolvera/Proyecto_Final_Control_Inteligente-)**

El portafolio presenta los procedimientos de instalación, configuración, entrenamiento, simulación y validación, con el propósito de que otro estudiante pueda comprender la implementación y reproducir sus experimentos.

---

## Integrantes

**Equipo 3 - Péndulo 2**

- Carlos
- Víctor
- Joel

Universidad Iberoamericana Ciudad de México  
Asignatura: Control Inteligente  
Periodo: Otoño 2026
