---
layout: default
title: "8. Conclusiones"
nav_order: 9
---

# 8. Conclusiones

El controlador DQN mantuvo el péndulo del **QUBE-Servo 3** en la posición vertical invertida durante la prueba física. El modelo no lineal se utilizó para entrenar la política y comprobar su respuesta antes de trasladarla a Simulink. En el equipo, el agente seleccionó el voltaje del motor a partir de los ángulos medidos y las velocidades angulares estimadas. El LQR sirvió como referencia experimental y la comparación de ambos controladores en el laboratorio fue cualitativa.

En simulación, el DQN llevó el péndulo y el brazo a sus bandas de balance en aproximadamente **0.40 s** desde una desviación inicial de 10° y en **0.66 s** después de la perturbación de velocidad. En el segundo ensayo, el brazo se desplazó **13.80° más** y ambos ensayos alcanzaron el mismo pico de **6 V**. La recuperación del péndulo debe evaluarse junto con la excursión del brazo, porque ambos movimientos forman parte del objetivo de control.

En el barrido de robustez de hasta **±2 %**, la variación conjunta conservó las mismas condiciones iniciales exitosas para cada referencia. El estabilizador completó **74 de 81** casos con los parámetros base del simulador y **69 de 81** con los del Cuadro 2. Los cinco casos que cambiaron de resultado al pasar de una referencia a la otra arrancaron a 12° de la vertical y con velocidad angular dirigida hacia afuera. En la malla evaluada, el desempeño dependió de la referencia paramétrica y de la velocidad con la que el péndulo se alejaba de la vertical.

El diseño del supervisor establece cuándo transferir el control del agente de levantamiento (*swing-up*) al estabilizador, según el ángulo y la velocidad angular del péndulo. La validación cuantitativa de la secuencia completa queda como trabajo posterior. Las métricas para esa prueba son la proporción de arranques desde la posición colgante que alcanzan la región de captura, el tiempo de levantamiento y la duración del balance después de la conmutación.

[Consultar los resultados de simulación, laboratorio y robustez]({{ '/resultados.html' | relative_url }})
