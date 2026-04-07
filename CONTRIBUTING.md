# Contributing to TerrorMeter (Combat Metrics) 📊🛡️

¡Gracias por contribuir a la precisión táctica del **Séquito del Terror**! Para mantener el estándar **Diamond Tier** de **DarckRovert**, todas las contribuciones deben priorizar la velocidad de sincronización y el bajo impacto en CPU.

---

## 🛡️ Estándares Técnicos (Combat Core)

Este AddOn está optimizado para **Turtle WoW** (WoW v1.12.1). Las contribuciones DEBEN cumplir con:

1.  **Sync Priority**: No añadas funciones de red que aumenten la latencia de sincronización de amenaza.
2.  **No Lua 5.1+**: El motor es Lua 5.0. Prohibido el operador `#` (usa `table.getn`).
3.  **Parser Throttling**: El motor de lectura del registro de combate no debe saturar el hilo principal. Usa búferes rotativos para el procesamiento de ráfagas grandes de DPS.
4.  **Network Efficiency**: Los paquetes de sincronización de amenaza DEBEN ser optimizados en tamaño para no saturar el ancho de banda del canal de hermandad/banda.

## 📐 Arquetipo de Desarrollo

Si deseas contribuir:
- **`threat.lua`**: Es el motor de agro. Cualquier cambio aquí requiere validación en encuentros de 40 jugadores para asegurar estabilidad de agro.
- **`sync.lua`**: Optimización de la comunicación entre clientes. No envíes datos si no han cambiado significativamente.
- **`parser.lua`**: El motor de lectura de logs debe estar optimizado para filtrar eventos no deseados instantáneamente.

## 💎 Proceso de Pull Request

1.  **Fork & Branch**: Trabaja en ramas descriptivas (`fix/parser-fps`, `feature/sync-lan`).
2.  **Documentación**: Actualiza `CHANGELOG.md` antes de enviar el PR.
3.  **Branding**: Mantén los enlaces institucionales oficiales de **DarckRovert**.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Midiendo el camino hacia la gloria en Azeroth.*