# TerrorMeter - Changelog

## Versión 2.0.2 - Bugfix Critical (Enero 2026)

### 🐛 Correcciones Críticas

- ✅ **CRÍTICO:** Corregido error de sintaxis en `parser.lua` línea 173
  - Había un `end` extra sin bloque correspondiente que causaba error `<eof> expected near 'end'`
  - El addon no cargaba en WoW debido a este error de sintaxis
  - Se movió `start_next_segment = nil` dentro del bloque if correcto
  - Archivo afectado: `parser.lua` líneas 163-171

- ✅ **CRÍTICO:** Corregido cálculo de valores máximos en barras de progreso
  - La función `GetCaps()` usaba variable incorrecta `values.persecond_best` en lugar de `values.effective_best`
  - Esto causaba que las barras de DPS/HPS mostraran valores incorrectos
  - Archivo afectado: `window.lua` líneas 430-431

- ✅ **CRÍTICO:** Corregida limpieza de datos de threat al resetear
  - La función `ResetData()` no limpiaba los datos de threat
  - Datos de threat persistían después de `/tm reset`, causando valores incorrectos
  - Ahora se limpian correctamente `data.threat[0]` y `data.threat[1]`
  - Archivo afectado: `window.lua` después de línea 282

- ✅ **CRÍTICO:** Corregido reset de threat al iniciar nuevo combate
  - El sistema no reseteaba `data.threat[1]` al detectar nuevo segmento de combate
  - Threat del combate anterior se mezclaba con el nuevo combate
  - Ahora se resetea correctamente junto con damage[1] y heal[1]
  - Archivo afectado: `parser.lua` línea 165

### 📝 Notas

- **IMPORTANTE:** Estos bugs impedían el funcionamiento correcto del addon
- El error de sintaxis en parser.lua impedía que el addon cargara completamente
- Se recomienda ejecutar `/reload` después de actualizar
- Backup del archivo original guardado como `parser.lua.backup`

---

## Versión 2.0.1 - Hotfix (Enero 2026)

### 🐛 Correcciones

- ✅ **CRÍTICO:** Corregido error `attempt to call global 'ResetPhaseDPS' (a nil value)` en integración con BigWigs
  - La función `ResetPhaseDPS()` estaba definida como `local function`, haciéndola inaccesible desde el event handler de BigWigs
  - Cambiada a función global para permitir su llamada desde cualquier scope

- ✅ **CRÍTICO:** Corregida detección excesiva de fases en integración con BigWigs
  - El sistema detectaba nombres de habilidades que contenían "Phase" o "Fase" (ej: "Panther Phase", "Vanish Phase")
  - Esto causaba cientos de mensajes de fase en el chat
  - Ahora solo detecta cambios de fase reales que comienzan con "Phase X" o "Fase X" donde X es un número
  - Archivo afectado: `integration.lua` línea 285

  - Archivo afectado: `integration.lua` línea 304

### 📝 Notas

- Este hotfix corrige un crash y spam de mensajes que ocurrían con BigWigs instalado
- Se recomienda ejecutar `/reload` después de actualizar

---



## Versión 2.0 - Terror Ecosystem (Enero 2026)

### ✨ Nuevas Características Principales

#### Sistema de Threat REAL
- ✅ Cálculo preciso de threat con multiplicadores
- ✅ Multiplicadores por stance/form (Defensive Stance x1.3, Bear Form x1.3, Righteous Fury x1.6)
- ✅ Threat por habilidad específica (Sunder +260, Maul +322, etc.)
- ✅ Cálculo de threat por curación (50% del heal / número de enemigos)
- ✅ Detección automática de tank

#### Sincronización en Tiempo Real
- ✅ Sincronización automática de threat entre jugadores
- ✅ Envío de datos cada 2 segundos durante combate
- ✅ Compatible con party y raid
- ✅ Protocolo eficiente de comunicación

#### Sistema de Alertas
- ✅ Alertas visuales con 3 niveles (Verde, Amarillo, Rojo)
- ✅ Barra de threat personal
- ✅ Alertas sonoras cuando threat > 90%
- ✅ Colores dinámicos según nivel de peligro

#### Integración con TerrorSquadAI
- ✅ Envío automático de datos de threat
- ✅ Sugerencias inteligentes basadas en threat
- ✅ Alertas coordinadas
- ✅ Comunicación bidireccional

#### Integración con BigWigs
- ✅ Detección automática de boss fights
- ✅ Análisis de DPS por fase del boss
- ✅ Resumen automático al derrotar boss
- ✅ Rastreo de habilidades de boss
- ✅ Hooks de eventos de BigWigs

#### Integración con DoTimer
- ✅ Lectura de DoTs activos en tiempo real
- ✅ Cálculo de DPS proyectado por DoTs
- ✅ Alertas de DoTs importantes expirando (<3s)
- ✅ Base de datos de DoTs por clase
- ✅ Envío de alertas a TerrorSquadAI

### 💻 Nuevos Comandos

#### Comandos de Threat
- `/tmthreat bar` - Mostrar/ocultar barra de threat
- `/tmthreat alert` - Activar/desactivar alertas
- `/tmthreat sync` - Activar/desactivar sincronización
- `/tmthreat status` - Ver estado del sistema
- `/tmthreat reset` - Resetear datos de threat

#### Comandos de Integración
- `/tmi status` - Ver estado de integraciones
- `/tmi phases` - Ver DPS por fase (BigWigs)
- `/tmi dots` - Ver DoTs activos (DoTimer)
- `/tmi toggle [addon]` - Activar/desactivar integración
- `/tmi ai` - Ver estado de TerrorSquadAI
- `/tmi boss` - Ver info del boss actual
- `/tmi dotdps` - Ver DPS proyectado por DoTs

### 📁 Nuevos Archivos

- `threat.lua` - Sistema de threat REAL
- `sync.lua` - Sincronización entre jugadores
- `alerts.lua` - Alertas visuales y sonoras
- `integration.lua` - Integración con otros addons
- `README.md` - Documentación principal actualizada
- `COMMANDS.md` - Lista completa de comandos
- `THREAT_SYSTEM.md` - Documentación del sistema de threat
- `INTEGRATION.md` - Guía de integraciones
- `FAQ.md` - Preguntas frecuentes
- `CHANGELOG.md` - Este archivo

### 🔧 Mejoras

- ✅ Optimización del parser de combat log
- ✅ Mejor detección de habilidades
- ✅ Soporte mejorado para Vanilla y TBC
- ✅ Interfaz más responsiva
- ✅ Menor consumo de memoria
- ✅ Código más modular y mantenible

### 🐛 Correcciones

- ✅ Corregida detección de DoTimer (usaba variable incorrecta)
- ✅ Corregido compatibility con Vanilla (RegisterAddonMessagePrefix opcional)
- ✅ Corregidos bucles ipairs() por table.getn() para Vanilla
- ✅ Corregida sincronización de threat en raids grandes
- ✅ Corregido cálculo de threat por curación

### 📝 Notas

- Esta versión introduce el **Terror Ecosystem**, un conjunto de addons que trabajan juntos
- Todas las integraciones son opcionales y se activan automáticamente
- Compatible con versiones anteriores de TerrorMeter
- Requiere `/reload` para activar todas las nuevas funciones

---

## Versión 1.0 - Release Inicial

### ✨ Características Iniciales

- ✅ Medición de DPS (Damage Per Second)
- ✅ Medición de HPS (Healing Per Second)
- ✅ Parser de combat log independiente del idioma
- ✅ Soporte para Vanilla (1.12.1) y TBC (2.4.3)
- ✅ Interfaz gráfica personalizable
- ✅ Modos Current y Overall
- ✅ Sistema de segmentos
- ✅ Reportes a chat (party/raid/guild/whisper)

### 💻 Comandos Iniciales

- `/tm` - Mostrar/ocultar ventana
- `/tm reset` - Resetear datos
- `/tm report [chat]` - Reportar estadísticas
- `/tm mode` - Cambiar modo
- `/tm visible [0/1]` - Mostrar/ocultar
- `/tm lock [0/1]` - Bloquear/desbloquear
- `/tm scale [n]` - Cambiar escala
- `/tm alpha [n]` - Cambiar transparencia
- `/tm rows [n]` - Cambiar filas
- `/tm height [n]` - Altura de barras
- `/tm texture [n]` - Textura de barras
- `/tm pastel [0/1]` - Colores pastel
- `/tm backdrop [0/1]` - Fondo y borde
- `/tm trackall [0/1]` - Rastrear todos

### 📁 Archivos Iniciales

- `core.lua` - Motor principal
- `parser.lua` - Parser genérico
- `parser-vanilla.lua` - Parser para Vanilla
- `parser-tbc.lua` - Parser para TBC
- `window.lua` - Interfaz gráfica
- `settings.lua` - Configuración
- `TerrorMeter.toc` - Descriptor Vanilla
- `TerrorMeter-tbc.toc` - Descriptor TBC
- `README.md` - Documentación básica

### 📝 Notas

- Primer release público
- Diseñado para El Séquito del Terror
- Optimizado para bajo consumo de recursos
- Inspirado en Recount y Skada

---

## Roadmap Futuro

### Versión 2.1 (Planeada)

- [ ] Exportación de datos a CSV
- [ ] Historial de combates persistente
- [ ] Gráficos de DPS en tiempo real
- [ ] Comparación de intentos de boss
- [ ] Más opciones de personalización visual

### Versión 2.2 (Planeada)

- [ ] Sistema de rankings
- [ ] Estadísticas avanzadas (crit %, miss %, etc.)
- [ ] Análisis de rotación
- [ ] Sugerencias de mejora automáticas

### Versión 3.0 (Futuro)

- [ ] Interfaz web para análisis
- [ ] Sincronización con base de datos externa
- [ ] Comparación con otros jugadores
- [ ] Sistema de achievements

---

## Contribuciones

### Desarrolladores

- **darck** - Desarrollador principal

### Agradecimientos

- **El Séquito del Terror** - Testing y feedback
- **Turtle WoW Community** - Soporte y sugerencias
- **Recount/Skada** - Inspiración
- **Omen** - Inspiración para threat system

---

## Licencia

TerrorMeter es de código abierto y gratuito para la comunidad de Turtle WoW.

---

**¡Por el Terror y la Gloria!** 🔥
