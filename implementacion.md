---
layout: default
title: "6. Implementación"
nav_order: 7
---
# 6. Implementación en MATLAB y Simulink

## Repositorio técnico de referencia

[sebastiux/cubeservoquansecontrol](https://github.com/sebastiux/cubeservoquansecontrol) — contiene scripts Python, pesos de la red de balance, funciones MATLAB y modelo Simulink original de Quanser.

## Orden de pruebas DQN Balance

Desde la carpeta `matlab/` del repositorio técnico:

```matlab
cargar_red_dqn
prueba_dqn_modelo_no_lineal
construir_entorno_pruebas
% Solo tras validación y revisión de hardware:
conectar_al_simulink_original
```

`conectar_al_simulink_original` genera `qs3_dqn_ctrl.slx`, una copia del modelo LQR con la política DQN. Su generación no implica que el controlador esté validado.

## Integración con QUARC

El modelo físico utiliza encoders, observadores de velocidad y salida al motor. Los ensayos físicos requieren comprobación de signos, límites de tensión, restricción de ángulos, paro de emergencia y autorización del responsable del laboratorio.

## Extensión Swing-Up

Los scripts experimentales del segundo agente deben mantenerse en una carpeta independiente y enlazarse aquí **solo después** de fijar una versión revisada y métricas reproducibles. El supervisor debe seleccionar una única política a la vez y deshabilitar la actuación al detectar condiciones inseguras.
