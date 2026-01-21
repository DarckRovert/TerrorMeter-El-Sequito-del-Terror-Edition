# TerrorMeter - Lista Completa de Comandos

## 💻 Comandos Principales

### Comandos Básicos

| Comando | Descripción |
|---------|-------------|
| `/tm` | Mostrar/ocultar ventana principal |
| `/terrormeter` | Alias de `/tm` |
| `/tmeter` | Alias de `/tm` |
| `/tm toggle` | Alternar visibilidad de la ventana |
| `/tm reset` | Resetear todos los datos (DPS, threat, segmentos) |
| `/tm report [chat]` | Reportar estadísticas al chat especificado |

### Comandos de Visualización

| Comando | Descripción |
|---------|-------------|
| `/tm mode` | Cambiar entre Current (combate actual) y Overall (sesión) |
| `/tm segment [n]` | Ver segmento específico (n = número de combate) |
| `/tm visible [0/1]` | Mostrar (1) u ocultar (0) ventana |
| `/tm lock [0/1]` | Bloquear (1) o desbloquear (0) ventana |

### Comandos de Configuración Visual

| Comando | Descripción | Valores |
|---------|-------------|----------|
| `/tm scale [n]` | Cambiar escala de ventana | 0.5 - 2.0 |
| `/tm alpha [n]` | Cambiar transparencia | 0.0 - 1.0 |
| `/tm rows [n]` | Cambiar número de filas visibles | 5 - 20 |
| `/tm height [n]` | Altura de las barras | Cualquier número |
| `/tm texture [n]` | Textura de barras | 1 - 4 |
| `/tm pastel [0/1]` | Usar colores pastel | 0 = No, 1 = Sí |
| `/tm backdrop [0/1]` | Mostrar fondo y borde | 0 = No, 1 = Sí |

### Comandos de Rastreo

| Comando | Descripción |
|---------|-------------|
| `/tm trackall [0/1]` | Rastrear todas las unidades cercanas (no solo party/raid) |

---

## 🔥 Comandos de Threat

### Sistema de Threat

| Comando | Descripción |
|---------|-------------|
| `/tmthreat bar` | Mostrar/ocultar barra de threat personal |
| `/tmthreat alert` | Activar/desactivar alertas de threat |
| `/tmthreat sync` | Activar/desactivar sincronización de threat |
| `/tmthreat status` | Ver estado del sistema de threat |
| `/tmthreat reset` | Resetear datos de threat |

### Alertas de Threat

Las alertas se activan automáticamente según tu nivel de threat:

- 🟢 **Verde** (<70%): Threat seguro
- 🟡 **Amarillo** (70-90%): Precaución, reducir DPS
- 🔴 **Rojo** (>90%): Peligro crítico, PARAR DPS

---

## 🔗 Comandos de Integración

### Estado de Integraciones

| Comando | Descripción |
|---------|-------------|
| `/tmi status` | Ver estado de todas las integraciones |
| `/tmi toggle [addon]` | Activar/desactivar integración específica |

### Integración con BigWigs

| Comando | Descripción |
|---------|-------------|
| `/tmi phases` | Ver DPS por fase de boss |
| `/tmi boss` | Ver información del boss actual |
| `/tmi resetphases` | Resetear datos de fases |

### Integración con DoTimer

| Comando | Descripción |
|---------|-------------|
| `/tmi dots` | Ver lista de DoTs activos |
| `/tmi dotdps` | Ver DPS proyectado por DoTs |

### Integración con TerrorSquadAI

| Comando | Descripción |
|---------|-------------|
| `/tmi ai` | Ver estado de integración con TerrorSquadAI |
| `/tmi sendthreat` | Enviar datos de threat manualmente |

---

## 📢 Comandos de Reporte

### Sintaxis de Reporte

```
/tm report [canal]
```

### Canales Disponibles

| Canal | Descripción |
|-------|-------------|
| `whisper` | Enviar a un jugador específico (te pedirá el nombre) |
| `party` | Enviar al grupo |
| `raid` | Enviar a la raid |
| `guild` | Enviar al guild |
| `say` | Decir en voz alta (chat local) |
| `officer` | Enviar al chat de oficiales |

### Ejemplos

```
/tm report party        # Reportar al grupo
/tm report raid         # Reportar a la raid
/tm report guild        # Reportar al guild
```

### Formato de Reporte

El reporte incluye:
- Top 10 jugadores por DPS/HPS
- Duración del combate
- Modo actual (Current/Overall)
- Segmento actual (si aplica)

---

## 🔍 Comandos de Debug

### Diagnóstico

| Comando | Descripción |
|---------|-------------|
| `/tm debug` | Activar/desactivar modo debug |
| `/tm version` | Ver versión del addon |
| `/tm info` | Ver información del addon |

---

## 📊 Ejemplos de Uso

### Configuración Inicial

```lua
/tm                      # Abrir ventana
/tm scale 1.2            # Aumentar tamaño 20%
/tm alpha 0.8            # 80% de opacidad
/tm rows 15              # Mostrar 15 filas
/tm lock 1               # Bloquear ventana
```

### Durante Raid

```lua
/tmthreat bar            # Activar barra de threat
/tmthreat alert          # Activar alertas
/tmi status              # Verificar integraciones
/tm mode                 # Cambiar a Current para ver combate actual
```

### Después de Boss Fight

```lua
/tmi phases              # Ver DPS por fase
/tm report raid          # Reportar a la raid
/tm segment 1            # Ver primer combate
```

### Personalización Visual

```lua
/tm texture 3            # Cambiar textura de barras
/tm pastel 1             # Activar colores pastel
/tm backdrop 1           # Mostrar fondo
/tm height 20            # Barras más altas
```

---

## ⌨️ Atajos de Teclado

Actualmente TerrorMeter no tiene atajos de teclado configurados por defecto. Puedes usar macros para crear tus propios atajos:

### Macro de Toggle

```lua
/tm toggle
```

### Macro de Reporte Rápido

```lua
/tm report party
```

### Macro de Threat

```lua
/tmthreat bar
/tmthreat alert
```

---

## 📝 Notas Importantes

1. **Comandos sensibles a mayúsculas:** No, todos los comandos funcionan en minúsculas o mayúsculas
2. **Valores numéricos:** Deben ser números válidos dentro del rango especificado
3. **Comandos en combate:** Todos los comandos funcionan durante combate
4. **Persistencia:** La configuración se guarda automáticamente

---

## 🔗 Ver También

- [README.md](README.md) - Guía principal
- [INTEGRATION.md](INTEGRATION.md) - Integraciones con otros addons
- [THREAT_SYSTEM.md](THREAT_SYSTEM.md) - Sistema de threat
- [FAQ.md](FAQ.md) - Preguntas frecuentes

---

**¡Por el Terror y la Gloria!** 🔥
