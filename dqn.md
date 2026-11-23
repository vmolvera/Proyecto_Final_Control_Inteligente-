---
layout: default
title: "5. Diseño del DQN"
nav_order: 6
---
# 5. Diseño del agente DQN

## Formulación MDP

La política de balance observa cuatro estados \([\theta,\alpha,\dot\theta,\dot\alpha]\). En la versión publicada por el equipo, la red recibe cuatro entradas, contiene dos capas ocultas de 128 neuronas y produce once valores acción–estado.

| Elemento | Implementación publicada |
|:--|:--|
| Algoritmo | Double DQN con memoria de experiencias |
| Arquitectura | 4 → 128 → 128 → 11 |
| Acciones (V) | −10, −6, −3, −1.5, −0.5, 0, 0.5, 1.5, 3, 6, 10 |
| Periodo de decisión | 0.010 s |
| Paso de dinámica | 0.002 s |
| Pesos | `models/dqn_qube.mat` |

La recompensa de referencia penaliza errores angulares, velocidades y esfuerzo de control; los pesos exactos se deben documentar directamente desde `python/rl_env.py` para la versión final del código.

## Segundo agente: Swing-Up

La extensión propuesta aprende a incrementar la energía del péndulo desde \(\alpha\approx\pi\) hasta una región cercana a la posición invertida. Es recomendable representar el ángulo cíclico mediante seno y coseno, y penalizar velocidades elevadas en el momento de captura, excursion del brazo y esfuerzo de control.

## Supervisor

La transferencia debe exigir simultáneamente ángulo cercano a cero, velocidades reducidas y posición segura del brazo; conviene utilizar histéresis para evitar conmutaciones repetidas. Los umbrales son parámetros por validar en simulación. No se ha comprobado todavía un sistema completo Swing-Up + Balance sobre la planta física.
