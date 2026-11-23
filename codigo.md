---
layout: default
title: "9. Código fuente"
nav_order: 10
---
# 9. Código fuente y reproducibilidad

## Repositorios

- [Código técnico del equipo](https://github.com/sebastiux/cubeservoquansecontrol)
- [Proyecto final — documentación](https://github.com/vmolvera/Proyecto_Final_Control_Inteligente)
- [Portafolio de la Evaluación I — referencia de estilo](https://vmolvera.github.io/Evaluaci-n1_Control_Inteligente/)

## Archivos centrales

| Archivo | Función |
|:--|:--|
| `python/qube_model.py` | Modelo no lineal |
| `python/rl_env.py` | Entorno de entrenamiento de balance |
| `python/train_dqn.py` | Entrenamiento y exportación |
| `models/dqn_qube.mat` | Pesos de balance |
| `matlab/cargar_red_dqn.m` | Carga de la política |
| `matlab/prueba_dqn_modelo_no_lineal.m` | Prueba MATLAB |
| `matlab/construir_entorno_pruebas.m` | Simulink sin hardware |
| `matlab/conectar_al_simulink_original.m` | Integración en copia del modelo Quanser |

## Requisitos de reproducibilidad

Especificar la rama y hash exacto, versiones Python/Matlab/QUARC, semillas, parámetros, modelos, fecha del ensayo y archivos de datos originales. No subir credenciales ni archivos sujetos a restricciones de distribución del laboratorio.
