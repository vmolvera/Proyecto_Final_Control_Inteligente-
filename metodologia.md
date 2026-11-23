---
layout: default
title: "3. Metodología"
nav_order: 4
---
# 3. Metodología

## Flujo de trabajo

1. **Planta y referencia:** calcular \(A\), \(B\) y \(K\) LQR a partir de `ProyectoControlFinal.m`; verificar el balance físico con el modelo original.
2. **Modelo no lineal:** reproducir la dinámica en Python y MATLAB, con parámetros y discretización declarados.
3. **Entrenamiento:** usar aprendizaje Double DQN en Python y exportar pesos para inferencia en MATLAB.
4. **Validación A1:** ejecutar `prueba_dqn_modelo_no_lineal` y registrar sus resultados.
5. **Validación A2:** ejecutar `construir_entorno_pruebas` y guardar \(\theta,\alpha,V_m\).
6. **Integración física:** ejecutar `conectar_al_simulink_original` para crear una copia con la política neuronal. La prueba inicial produjo oscilaciones, por lo que requiere diagnóstico de estados y observadores.
7. **Extensión Swing-Up:** entrenar un segundo agente desde la posición colgante y evaluar un supervisor con condiciones de captura por ángulo y velocidad.
8. **Robustez y comparación:** repetir pruebas con ±2 % de parámetros y contrastar con LQR bajo condiciones comparables.

## Diferencia entre simulación y hardware

En la planta real deben comprobarse signos, unidades y orden de estados \([\theta,\alpha,\dot\theta,\dot\alpha]\), estimación de velocidades, cuantización, saturación, tiempo de ejecución, límites angulares y parada de emergencia. No habilitar políticas experimentales sobre el motor sin la revisión de seguridad correspondiente.

## Reproducibilidad

Registrar versión de MATLAB, QUARC, commit exacto del código de entrenamiento, semillas, pesos `.mat`, parámetros, periodo de muestreo y fecha de cada corrida. No interpretar una ejecución sin errores como éxito de control.
