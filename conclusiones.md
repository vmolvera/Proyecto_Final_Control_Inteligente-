---
layout: default
title: "8. Conclusiones"
nav_order: 9
---
# 8. Conclusiones y trabajo pendiente

Se dispone de un controlador LQR que sirvió como referencia física, de un modelo no lineal y de una política DQN de balance con resultados de simulación publicados en el repositorio del equipo. La integración DQN en el QUBE-Servo 3 real no consiguió mantener la posición invertida durante el ensayo inicial.

La principal conclusión técnica es que una alta tasa de éxito en simulación no basta para declarar estabilidad en hardware. Se requiere validar los observadores, la interfaz de estados, la temporización y la fidelidad del modelo, además de reproducir la comparación con LQR y las pruebas de robustez ±2 %.

Como trabajo adicional se desarrolla la arquitectura de dos agentes: uno para levantamiento (*swing-up*) y otro para balance, con supervisor de transferencia. Su éxito requiere demostrar tanto la llegada a una región capturable como la estabilidad del controlador receptor; ninguna de estas condiciones debe presumirse cumplida en la planta física.
