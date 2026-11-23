---
layout: default
title: "2. Objetivos"
nav_order: 3
---
# 2. Objetivos

## Objetivo general

Diseñar, entrenar, implementar y evaluar una política DQN capaz de estabilizar el péndulo invertido del Quanser QUBE-Servo 3, contrastando su desempeño en simulación y en la planta física.

## Objetivos específicos

1. Implementar y validar un modelo no lineal de la planta contra mediciones reales comparables.
2. Definir el proceso de decisión de Markov: estados, acciones, recompensa y terminación.
3. Entrenar y evaluar un controlador DQN con condiciones iniciales y perturbaciones variadas.
4. Integrar la política con MATLAB/Simulink y las señales de los encoders/observadores.
5. Comparar desempeño frente a LQR y determinar causas de discrepancia simulación–realidad.
6. Evaluar robustez con variaciones de hasta ±2 % de los parámetros nominales.
7. Como extensión, diseñar un DQN de swing-up y un supervisor que transfiera la autoridad de control al DQN de balance.

## Criterios de evaluación

Las métricas a documentar son error angular, rango del brazo, tiempo de recuperación, esfuerzo de control, éxito por episodio y robustez. Las pruebas físicas deben realizarse con las protecciones pertinentes y supervisión de laboratorio.
