---
layout: default
title: "8. Conclusiones"
nav_order: 9
---

# 8. Conclusiones

El proyecto demostró que una política DQN de voltaje discreto puede **mantener el péndulo del QUBE-Servo 3 en la posición vertical invertida**. El resultado se obtuvo al integrar el modelo no lineal, las mediciones de los encoders, la estimación de velocidades y la ejecución de la política en Simulink. En simulación también se cuantificó cuánto se desplaza el brazo durante la recuperación, porque su regulación forma parte del objetivo de control.

## 8.1 Del modelo no lineal al equipo físico

El modelo de simulación reprodujo tanto la dinámica acoplada del brazo y el péndulo como las señales disponibles para el controlador. La política decidió cada **10 ms** a partir de posiciones angulares y velocidades estimadas, mientras la planta simulada y el observador se actualizaron cada **2 ms**. Así se pudo probar la política con una observación compatible con la del laboratorio, donde los encoders entregan posiciones y las velocidades se reconstruyen a partir de ellas.

## 8.2 Recuperación del balance y movimiento del brazo

En la prueba A1, el sistema volvió a la banda conjunta de balance en aproximadamente **0.40 s** desde una desviación inicial de 10° y **0.66 s** después de una perturbación de velocidad del péndulo. En el segundo ensayo, el brazo alcanzó **36.42°** de excursión máxima frente a **22.62°** en el primero, con un pico de **6 V** en ambos. El mayor recorrido del brazo muestra que dos maniobras que recuperan la vertical pueden exigir transitorios distintos. Para juzgar la calidad del control conviene observar juntos el ángulo del péndulo, la excursión del brazo y el voltaje aplicado.

## 8.3 Levantamiento autónomo y transferencia al estabilizador

El diseño de dos agentes aborda dos maniobras distintas. El agente de *swing-up* debe llevar el péndulo desde la posición colgante hasta una región que el estabilizador pueda recuperar. El supervisor usa el ángulo y la velocidad angular estimada para decidir cuándo cederle el control. La velocidad en ese instante importa porque determina cuánto seguirá desplazándose el péndulo tras cruzar la vertical y cuánto margen tendrá el estabilizador para corregirlo.
