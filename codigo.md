---
layout: default
title: "7. Código fuente"
nav_order: 8
---

# 7. Código fuente y reproducibilidad

El código del proyecto permite ejecutar la política DQN de balance con los pesos entrenados, reproducir las pruebas del modelo no lineal y generar el modelo de Simulink para el QUBE-Servo 3. La guía sigue el orden de trabajo del proyecto, desde la comprobación de la red hasta su integración con el equipo físico.

## 7.1 Programa principal y versión del código

El punto de entrada para reproducir las pruebas en MATLAB es [`matlab/prueba_dqn_modelo_no_lineal.m`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/matlab/prueba_dqn_modelo_no_lineal.m). El script carga la política exportada, comprueba sus acciones frente a las referencias de Python y ejecuta las pruebas de lazo cerrado con el modelo no lineal.

- [Consultar el repositorio técnico en la versión `1072497`](https://github.com/sebastiux/cubeservoquansecontrol/tree/107249755d5de330826e59d00de33d000327f3c3)
- [Descargar el código, los modelos y los pesos de esa versión (ZIP)](https://github.com/sebastiux/cubeservoquansecontrol/archive/107249755d5de330826e59d00de33d000327f3c3.zip)

Para obtener la misma versión con Git, usar estos comandos en una terminal.

```bash
git clone https://github.com/sebastiux/cubeservoquansecontrol.git
cd cubeservoquansecontrol
git checkout 107249755d5de330826e59d00de33d000327f3c3
```

## 7.2 Organización de archivos

| Archivo | Función en el proyecto |
|---|---|
| [`python/qube_model.py`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/python/qube_model.py) | Ecuaciones de la planta no lineal del QUBE-Servo 3 usadas durante el entrenamiento. |
| [`python/rl_env.py`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/python/rl_env.py) | Entorno de balance con cuantización de encoders, estimación de velocidades y configuración del ensayo. |
| [`python/train_dqn.py`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/python/train_dqn.py) | Entrenamiento en PyTorch y exportación de los pesos y del conjunto de acciones. |
| [`models/dqn_qube.mat`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/models/dqn_qube.mat) | Pesos, normalización, niveles de voltaje y período de muestreo de la política que ejecuta MATLAB. |
| [`models/dqn_qube.json`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/models/dqn_qube.json) | Configuración y métricas de validación del entrenamiento exportado. |
| [`matlab/cargar_red_dqn.m`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/matlab/cargar_red_dqn.m) y [`matlab/politica_dqn.m`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/matlab/politica_dqn.m) | Carga de la red y selección del voltaje a partir del estado observado. |
| [`matlab/qube_nonlinear_dynamics.m`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/matlab/qube_nonlinear_dynamics.m) y [`matlab/simular_lazo_cerrado.m`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/matlab/simular_lazo_cerrado.m) | Dinámica de la planta y ejecución numérica del lazo de balance de A1. |
| [`matlab/construir_entorno_pruebas.m`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/matlab/construir_entorno_pruebas.m) | Generación de `simulink/qube_dqn_pruebas.slx` para ejecutar el DQN con una planta virtual. |
| [`matlab/conectar_al_simulink_original.m`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/matlab/conectar_al_simulink_original.m) y [`matlab/dqn_controller_block.m`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/matlab/dqn_controller_block.m) | Generación de `simulink/qs3_dqn_ctrl.slx` a partir del [`simulink/qs3_lqr_ctrl_simulinkFInal.slx`](https://github.com/sebastiux/cubeservoquansecontrol/blob/107249755d5de330826e59d00de33d000327f3c3/simulink/qs3_lqr_ctrl_simulinkFInal.slx) y código del bloque de inferencia. |

## 7.3 Orden de ejecución

Abrir MATLAB y seleccionar la carpeta `matlab/` del código descargado como carpeta actual. Los scripts usan los pesos de `models/dqn_qube.mat` incluidos en el repositorio.

| Etapa | Comando en MATLAB | Qué revisar |
|---|---|---|
| **A1 · Prueba numérica** | `prueba_dqn_modelo_no_lineal` | Coincidencia de las acciones y respuestas ante la desviación inicial y la perturbación. Los archivos se guardan en `models/figuras/`. |
| **A2 · Prueba en Simulink** | `construir_entorno_pruebas` | Ejecución con la planta virtual. Revisar el ángulo del brazo, el ángulo del péndulo y el voltaje del motor. |
| **B · Integración al modelo Quanser** | `conectar_al_simulink_original` | Modelo generado en `simulink/qs3_dqn_ctrl.slx`. En el equipo de laboratorio con QUARC, abrir ese modelo para la prueba física de balance. |

La prueba A1 requiere MATLAB. A2 también requiere Simulink y se ejecuta con el QUBE simulado. La ejecución física de la etapa B requiere MATLAB, Simulink, QUARC y el QUBE-Servo 3 conectado. El modelo que genera la etapa B habilita el DQN dentro de la región de balance, con un período de decisión de 10 ms y transferencia de la acción al lazo de 2 ms.

### Reentrenamiento opcional

Con Python 3.10 o posterior y un entorno virtual activo, ejecutar estos comandos desde la carpeta raíz del repositorio. `--out` guarda la nueva exportación con otro nombre para preservar los pesos de referencia usados en las pruebas.

```bash
cd python
python -m pip install -r requirements.txt
python train_dqn.py --seed 0 --out ../models/dqn_qube_reentrenado
```

## 7.4 Datos y alcance del código publicado

- [Datos del barrido de robustez de ±2 % por escenario (CSV)]({{ '/assets/images/dqn-sensibilidad-2pct.csv' | relative_url }})
- [Gráficas A1, resultados físicos y criterios del barrido]({{ '/resultados.html' | relative_url }})
- [Implementación en Simulink y estimación de velocidades]({{ '/implementacion.html' | relative_url }})
- [Diseño de los agentes DQN y lógica de conmutación]({{ '/dqn.html' | relative_url }})

La descarga contiene la cadena de ejecución del **estabilizador DQN**. La documentación de **Agentes DQN** describe el levantamiento desde la posición colgante y la lógica de captura. Para ejecutar la secuencia de dos agentes se necesitan además los pesos de *swing-up* y el modelo con el supervisor integrado.

[Repositorio del portafolio del proyecto final](https://github.com/vmolvera/Proyecto_Final_Control_Inteligente-)
