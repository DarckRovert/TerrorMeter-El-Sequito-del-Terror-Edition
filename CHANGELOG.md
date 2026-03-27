# Changelog — TerrorMeter

---

## [9.3.0] — 2024-03-20 (God-Tier — Ecosystem Sync)
### Añadido
- Bridge con WCS_Brain: métricas disponibles en pestaña de Estadísticas.
- Modo HPS (Healing Per Second) completo con desglose por hechizo.
- Sistema de segmentación automática de encuentros.
- Sync P2P: publicación de métricas en addon channel del clan.

### Cambiado
- Parser de combate reescrito para mayor precisión en Turtle WoW 1.12.1.
- Interfaz rediseñada con colores del Séquito (rojo oscuro / dorado).

### Arreglado
- Fix crítico: daño de mascota Warlock ahora se atribuye al jugador, no a la mascota.
- Corrección de doble conteo en AOE.

---

## [2.1.0] — 2024-01-15
### Añadido
- Sistema de amenaza (Threat) con indicadores visuales.
- Ventanas de DPS configurable: 5s, 15s, 60s, sesión completa.

### Arreglado
- Fix: reset de datos al entrar a una mazmorra.
- Fix: datos de sanación perdidos en combates largos.

---

## [2.0.0] — 2023-12-01 (Rewrite)
### Cambiado
- Reescritura completa del parser de combate.
- Compatibilidad garantizada con Lua 5.0 y Turtle WoW 1.12.1.