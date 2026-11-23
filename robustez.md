---
layout: default
title: "8. Robustez y discusión"
nav_order: 9
---
# 8. Robustez y discusión

El enunciado solicita evaluar el agente entrenado con variaciones de **hasta ±2 %** de los parámetros nominales, sin reentrenamiento entre corridas. El Monte Carlo ±15 % publicado por el repositorio no sustituye una tabla explícita ±2 % conforme a la rúbrica.

## Plan de pruebas

| Ensayo | Parámetros | Métricas |
|:--|:--|:--|
| Nominal | Valores de referencia | Éxito, RMS α, RMS θ, voltaje |
| Robustez negativa | −2 % por parámetro | Estabilidad y tiempo de recuperación |
| Robustez positiva | +2 % por parámetro | Estabilidad y tiempo de recuperación |
| Perturbaciones | Impulso y condiciones iniciales | Recuperación y tasa de éxito |

## Brecha simulación–realidad

La prueba física inicial del DQN muestra oscilaciones rápidas. Entre las hipótesis por contrastar se encuentran estimaciones de velocidad, transitorios del observador, orden/unidades/signos del estado, discretización, diferencias paramétricas, fricción y latencias. No se ha identificado experimentalmente una causa única.

## Seguridad

No reactivar una política inestable sin revisión del supervisor del laboratorio, límites de voltaje, ángulos y velocidades y paro de emergencia. Las validaciones del supervisor deben hacerse primero en simulación.
