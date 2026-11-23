# Guía rápida de publicación

Este paquete es un sitio de documentación, no sustituye al código de control. El repositorio técnico del compañero queda enlazado.

1. Crea `vmolvera/Proyecto_Final_Control_Inteligente` (público).
2. Sube el contenido descomprimido a la raíz, incluidos `_config.yml`, `_sass`, `index.md` y los `.md` restantes.
3. En Settings → Pages selecciona `Deploy from a branch` → `main` → `/(root)`.
4. Espera el resultado visible en GitHub Actions; comprueba la URL `https://vmolvera.github.io/Proyecto_Final_Control_Inteligente/`.
5. Si aparece error de tema, revisa el Gemfile y el log de Pages. Si se desea exactamente el logo del portafolio anterior, incorpora su imagen autorizada como `assets/images/logo.png` y agrega `logo: "/assets/images/logo.png"` a `_config.yml` (aquí se omitió para evitar copiar un recurso no recuperado).
6. Antes de la entrega, incorpora mediciones verdaderas (figuras y videos) y hash del commit usado para los resultados; no cambies el estado de resultados si no se verificaron.

> No sobrescribir el repositorio antiguo de Evaluación I.
