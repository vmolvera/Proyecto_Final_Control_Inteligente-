---
layout: default
title: Inicio
nav_order: 1
---

# Entrenamiento planta altamente no lineal por DQN

## Proyecto Final - Control Inteligente

**Quanser QUBE-Servo 3 · Equipo 3 · Péndulo 2**

Este portafolio documenta el desarrollo de un sistema de **control inteligente mediante aprendizaje por refuerzo profundo** para el péndulo rotatorio invertido del Quanser QUBE-Servo 3. El proyecto combina un modelo dinámico no lineal, un controlador LQR de referencia y una **Deep Q-Network (DQN)** de balance, entrenada en simulación para mantener el péndulo cerca de la vertical superior.

---

## Información del proyecto

| Elemento | Información |
|---|---|
| Asignatura | Control Inteligente |
| Evaluación | Proyecto Final |
| Equipo | Equipo 3 |
| Planta asignada | Péndulo 2 |
| Plataforma | Quanser QUBE-Servo 3 |
| Desarrollo | Python, MATLAB y Simulink |
| Interfaz experimental | Quanser QUARC |
| Periodo | Otoño 2026 |

---

## Demostración experimental

Como evidencia del funcionamiento del sistema desarrollado, se realizaron diferentes pruebas físicas del **Quanser QUBE-Servo 3**.

Las grabaciones permiten observar diferentes etapas de la ejecución y validación experimental del sistema.

**[▶ Ver videos de las pruebas experimentales](https://github.com/vmolvera/Evaluaci-n1_Control_Inteligente/tree/main/assets/videos)**

---

## Objetivos principales

El desarrollo de la evaluación comprende tres etapas principales:

1. Modelar la dinámica no lineal del brazo rotatorio y del péndulo.
2. Diseñar un controlador LQR como referencia y entrenar una política DQN de balance.
3. Comparar el comportamiento de los controladores en simulación y en el equipo físico, y estudiar el levantamiento autónomo desde la posición colgante.

---

## Plataforma experimental

El QUBE-Servo 3 utiliza un motor de corriente continua para accionar el brazo rotatorio. Dos encoders miden los ángulos del brazo y del péndulo. Un observador estima las velocidades angulares y Quanser QUARC comunica el modelo de Simulink con el equipo físico.

---

## Arquitectura general del proyecto

El **DQN de balance** utiliza los ángulos y las velocidades angulares del brazo y del péndulo para seleccionar una acción de voltaje discreta. La arquitectura de dos agentes asigna el levantamiento desde la posición colgante al **DQN de *swing-up***. Un supervisor transfiere el control al agente de balance cuando el péndulo entra en la región de captura con una velocidad angular adecuada. La integración de ambos agentes queda pendiente de validación en la planta física.

---

## Integrantes

- Carlos Sebastián Ortega Hernández
- Víctor Manuel Olvera de la Cruz
- Joel Alberto RioValle
