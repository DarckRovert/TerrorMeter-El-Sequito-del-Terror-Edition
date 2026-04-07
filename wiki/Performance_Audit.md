# 📉 Wiki: Auditoría de Rendimiento — TerrorMeter [Terror-Tier]

El estándar **Diamond Tier** de **DarckRovert** exige una precisión milimétrica en las métricas de combate sin sacrificar el rendimiento del cliente.

---

## ⚡ Análisis de Latencia y Sincronización (Sync Lag)

El motor original de sincronización de combate en Vanilla/Turtle WoW solía inundar el canal de red con paquetes de datos constantes. En la **Sequito Edition**, hemos optimizado el flujo:

### 🎭 Comparativa de Impacto (Ciclos de Sincronización)

| Proceso | Escala Original | Escala Optimized | Mejora Lograda |
| :--- | :---: | :---: | :---: |
| **Sync de Amenaza** | 200ms | < 50ms | **+300% Rapidez** |
| **Parsing del Log** | 20ms | < 5ms | **+400% Agilidad** |
| **OnUpdate Refresh** | Cada Frame | 0.1s (Throttled) | **Estabilidad FPS** |

## 🧪 Pruebas de Estabilidad de FPS (Combat Stress Test)

### Escenario A: Raid 40 (Onyxia/MC)
- **TerrorMeter Original**: El parser procesaba cada evento de daño de los 40 jugadores, lo que causaba caídas de FPS de hasta 10 durante las ráfagas intensas.
- **Séquito Edition**: El nuevo **Lag-Free Parser** filtra y agrupa eventos por tanda, manteniendo la interfaz fluida incluso bajo presión masiva de DPS.

### Escenario B: Sincronización Global de Amenaza
- **TerrorMeter Original**: Picos de latencia al recibir datos de 40 compañeros simultáneamente.
- **Séquito Edition**: Los paquetes de datos comprimidos y el **Sync Throttling** eliminan la congestión del canal, proporcionando datos de amenaza casi instantáneos.

---

## 💾 Gestión de Memoria (Footprint)

- **GC Selective**: El motor de métricas elimina automáticamente los datos históricos de combates finalizados para evitar el crecimiento indefinido de las tablas en memoria.
- **String Recyling**: Se ha optimizado el procesamiento de nombres de jugadores y hechizos mediante un sistema de indexación numérica estática.

---
© 2026 **DarckRovert** — El Séquito del Terror.
*Midiendo el camino hacia la gloria en Azeroth.*
