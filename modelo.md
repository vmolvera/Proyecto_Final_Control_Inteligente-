---
layout: default
title: "4. Modelo dinámico"
nav_order: 5
---
# 4. Modelo dinámico del péndulo

El estado es

$$x=\begin{bmatrix}\theta & \alpha & \dot\theta & \dot\alpha\end{bmatrix}^{T},\qquad u=V_m.$$ 

El modelo completo del proyecto considera el acoplamiento rotacional, la gravedad, la fuerza contraelectromotriz y el amortiguamiento del brazo y del péndulo. La implementación está en `python/qube_model.py` y en los scripts MATLAB del repositorio técnico.

## Parámetros nominales del enunciado

| Parámetro | Símbolo | Valor |
|:--|:--|--:|
| Resistencia de armadura | \(R_m\) | 8.4 Ω |
| Constante de motor | \(k_m\) | 0.042 |
| Masa del brazo | \(m_r\) | 0.095 kg |
| Longitud del brazo | \(L_r\) | 0.085 m |
| Masa del péndulo | \(m_p\) | 0.024 kg |
| Longitud del péndulo | \(L_p\) | 0.129 m |
| Amortiguamiento brazo | \(D_r\) | 0.0015 N m s/rad |
| Amortiguamiento péndulo | \(D_p\) | 0.0005 N m s/rad |
| Gravedad | \(g\) | 9.81 m/s² |

**Nota:** son valores del enunciado; el script LQR y el modelo empleado en el entrenamiento pueden emplear valores diferentes. Las diferencias deben documentarse y validarse experimentalmente, no combinarse sin comprobación.

## Linealización y referencia LQR

La aproximación alrededor del equilibrio invertido se expresa como \(\dot x=Ax+Bu\), con \(u=-Kx\). La validación con LQR se usa como referencia y no prueba por sí misma el desempeño del controlador DQN.
