---
layout: default
title: "7. Resultados"
nav_order: 8
---
# 7. Resultados de simulación y experimentales

## Resultados publicados en el repositorio del equipo

| Prueba | Resultado publicado | Alcance |
|:--|:--|:--|
| Comparación PyTorch–MATLAB | 0 diferencias en 200 estados | Concordancia de inferencia |
| Validación Python | 98.8 % | Simulación |
| Monte Carlo MATLAB, N=500 | 99.6 % | Simulación, variación ±15 % |
| Perturbación de velocidad | Recuperación publicada menor de 1 s | Simulación |

**Fuente:** README de `sebastiux/cubeservoquansecontrol`, rama `claude/wizardly-darwin-rmg1zu`. Las cifras deben reproducirse y adjuntar trazas antes de su presentación como resultados propios del equipo.

## Pruebas realizadas en laboratorio

| Controlador | Observación | Conclusión |
|:--|:--|:--|
| LQR | Mantuvo el péndulo invertido | Referencia física funcional |
| DQN Balance | Movimiento rápido izquierda–derecha y caída | No se logró estabilización sostenida |
| DQN Swing-Up + Balance | Sin prueba física documentada | Pendiente |

## Evidencias por integrar

- Gráficas temporales exportadas de \(\alpha(t)\), \(\theta(t)\), \(V_m(t)\), con ejes y unidades.
- Video de prueba física acompañado de fecha, versión del programa y condiciones.
- Métricas reproducibles: establecimiento, error RMS, saturación y éxito por episodio.
- Comparación LQR/DQN en condiciones equivalentes.

**No colocar capturas ilustrativas como si fueran mediciones reales.** Los resultados físicos existentes obligan a analizar y corregir la brecha entre simulación y hardware.
