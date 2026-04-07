# ðŸ“ Wiki: Arquitectura 'Diamond Tier' â€” TerrorMeter [v1.2.0]

Estructura tÃ©cnica del motor de mÃ©tricas de combate mantenido por **DarckRovert**.

## ðŸ—ï¸ JerarquÃ­a del Sistema de MÃ©tricas (Data Hierarchy)

TerrorMeter opera mediante la interceptaciÃ³n del registro de combate y la orquestaciÃ³n de red:

1.  **Hueso del Parser (`parser-vanilla.lua`)**: Escucha el evento `CHAT_MSG_COMBAT_SELF_LOG` y otros para decodificar daÃ±o y sanaciÃ³n.
2.  **Motor de Amenaza (`threat.lua`)**: Calcula dinÃ¡micamente los multiplicadores de agro segÃºn la clase y hechizo.
3.  **MÃ³dulo de SincronizaciÃ³n (`sync.lua`)**: Canal de comunicaciÃ³n bidireccional entre clientes del AddOn en la misma Raid/Guild.
4.  **Interface Renderer (`window.lua`)**: Dibuja las barras de mÃ©tricas con perfiles de configuraciÃ³n dinÃ¡micos.

---

## ðŸ§­ Diagrama de Flujo: SincronizaciÃ³n de Amenaza v9.4

```mermaid
graph TD
    A[Evento Combat Log: DaÃ±o/Skill] --> B[DecodificaciÃ³n de DaÃ±o Parser]
    B --> C[AsignaciÃ³n de Amenaza Threat.lua]
    C --> D{Â¿Cambio Significativo?}
    D -- SÃ­ --> E[BÃºfer de EnvÃ­o Sync.lua]
    D -- No --> Z[Esperar Siguiente Evento]
    E --> F[InyecciÃ³n en Canal de Hermandad/Banda]
    F --> G[RecepciÃ³n en Clientes del SÃ©quito]
    G --> H[Render de Barras con Throttling 0.1s]
    H --> I[SincronizaciÃ³n con WCS_Brain PetAI]
```

## âš¡ Estrategias de IngenierÃ­a Diamond Tier

- **Selective Parsing**: El parser solo decodifica eventos relevantes para el combate activo, ignorando el spam de buffs/debuffs menores.
- **Sync Throtling**: Los datos de amenaza se envÃ­an en paquetes comprimidos cada `50ms` para evitar la saturaciÃ³n del ancho de banda de red del cliente 1.12.1.
- **WCS Neural Integration**: Los informes de eficiencia de mascotas se inyectan a travÃ©s de eventos personalizados para el anÃ¡lisis tÃ¡ctico.

---
Â© 2026 **DarckRovert** â€” El SÃ©quito del Terror.
*Midiendo el camino hacia la gloria en Azeroth.*

