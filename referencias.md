---
layout: default
title: "9. Referencias"
nav_order: 10
---

# 9. Referencias

## 9.1 Enunciado de la asignatura

- López González, A., y Caballero Mora, J. A. (2026, 29 de octubre). *Proyecto Final – Control Inteligente*. Universidad Iberoamericana. Enunciado facilitado al equipo. El **Cuadro 2** establece los parámetros nominales que se documentan en [Implementación]({{ '/implementacion.html' | relative_url }}#modelo-no-lineal).

## 9.2 Modelado y control del péndulo rotatorio

- Cazzolato, B. S., y Prime, Z. (2011). On the dynamics of the Furuta pendulum. *Journal of Control Science and Engineering*, 2011, artículo 528341. Referencia para la dinámica no lineal y la linealización del péndulo rotatorio. [DOI](https://doi.org/10.1155/2011/528341).
- Furuta, K., Yamakita, M., y Kobayashi, S. (1992). Swing-up control of inverted pendulum using pseudo-state feedback. *Proceedings of the Institution of Mechanical Engineers, Part I: Journal of Systems and Control Engineering*, 206(4), 263–269. Antecedente del problema de levantamiento desde la posición colgante. [DOI](https://doi.org/10.1243/PIME_PROC_1992_206_341_02).

## 9.3 Aprendizaje por refuerzo y agentes DQN

- Sutton, R. S., y Barto, A. G. (2018). *Reinforcement learning: An introduction* (2.ª ed.). MIT Press. Fundamentos de los procesos de decisión de Markov, la recompensa y el aprendizaje de valores de acción. [Editorial](https://mitpress.mit.edu/9780262039246/reinforcement-learning/).
- Mnih, V., et al. (2015). Human-level control through deep reinforcement learning. *Nature*, 518, 529–533. Trabajo original de DQN. [DOI](https://doi.org/10.1038/nature14236).
- van Hasselt, H., Guez, A., y Silver, D. (2016). Deep reinforcement learning with Double Q-learning. *Proceedings of the AAAI Conference on Artificial Intelligence*, 30(1), 2094–2100. Fundamento de la separación entre la selección y la evaluación de la acción en Double DQN. [DOI](https://doi.org/10.1609/aaai.v30i1.10295).

## 9.4 Hardware y software

- Quanser. *Qube-Servo 3*. Descripción del equipo y del módulo de péndulo invertido. [Ficha oficial](https://www.quanser.com/products/qube-servo-3/).
- Quanser. *Quanser Qube-Servo 3*, documentación de adquisición de datos de QUARC. Interfaz USB y asignación de los canales de los encoders. [Documentación](https://quanser-update.azurewebsites.net/quarc/documentation/qube_servo3_usb.html).
- Quanser. *QUARC Tab*. Compilación y ejecución en tiempo real desde Simulink mediante *Monitor & Tune*. [Guía de QUARC](https://docs.quanser.com/quarc/documentation/quarc_tab.html).
- MathWorks. *Zero-Order Hold* y *Handle Rate Transitions*. Documentación para consultar la retención de señales y la comunicación entre bloques con distintos periodos de muestreo. [Zero-Order Hold](https://www.mathworks.com/help/simulink/slref/zeroorderhold.html) · [Transiciones de frecuencia](https://www.mathworks.com/help/simulink/ug/handle-rate-transitions.html).
- MathWorks. *Linear-Quadratic Regulator (LQR) design*. Función de MATLAB para el diseño del regulador lineal cuadrático de referencia. [Documentación de `lqr`](https://www.mathworks.com/help/control/ref/lti.lqr.html).

## 9.5 Material del proyecto

- Scripts, modelos, pesos del agente de balance y guía de ejecución. [Código Fuente]({{ '/codigo.html' | relative_url }}).
- Evidencia de simulación y laboratorio, criterios de éxito y datos del barrido paramétrico. [Resultados]({{ '/resultados.html' | relative_url }}).
- Portafolio de Evaluación I de Control Inteligente. Referencia para la organización del portafolio digital. [Evaluación I](https://github.com/vmolvera/Evaluaci-n1_Control_Inteligente).
