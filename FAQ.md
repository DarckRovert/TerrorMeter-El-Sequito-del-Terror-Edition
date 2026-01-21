# TerrorMeter - Preguntas Frecuentes (FAQ)

## 📊 General

### ¿Qué es TerrorMeter?

TerrorMeter es un addon avanzado de medición de DPS/HPS con sistema de threat en tiempo real, sincronización entre jugadores, y alertas visuales inteligentes.

### ¿Es compatible con Vanilla y TBC?

Sí, TerrorMeter funciona en:
- Vanilla WoW (1.12.1)
- The Burning Crusade (2.4.3)

### ¿Es gratuito?

Sí, TerrorMeter es completamente gratuito y de código abierto.

### ¿Funciona en Turtle WoW?

Sí, TerrorMeter fue diseñado específicamente para Turtle WoW.

---

## 🛠️ Instalación

### ¿Cómo instalo TerrorMeter?

1. Copia la carpeta `TerrorMeter` a `Interface/AddOns/`
2. Reinicia WoW o ejecuta `/reload`
3. Usa `/tm` para abrir la ventana

### ¿Dónde está la carpeta AddOns?

```
World of Warcraft/Interface/AddOns/
```

### El addon no aparece en la lista de addons

1. Verifica que la carpeta se llame exactamente `TerrorMeter`
2. Asegúrate de que los archivos `.toc` estén presentes
3. Reinicia WoW completamente (no solo `/reload`)

### ¿Necesito otros addons?

No. TerrorMeter funciona perfectamente solo. Las integraciones con TerrorSquadAI, BigWigs y DoTimer son opcionales.

---

## 💻 Uso Básico

### ¿Cómo abro la ventana?

```lua
/tm
```

### La ventana no muestra nada

Entra en combate. TerrorMeter solo muestra datos durante y después del combate.

### ¿Cómo reseteo los datos?

```lua
/tm reset
```

### ¿Cómo reporto al grupo?

```lua
/tm report party      # Para party
/tm report raid       # Para raid
```

### ¿Qué es "Current" vs "Overall"?

- **Current:** Muestra solo el combate actual
- **Overall:** Muestra todos los combates de la sesión

Cambia con `/tm mode` o click en el botón "Mode".

### ¿Cómo veo combates anteriores?

```lua
/tm segment 1         # Ver primer combate
/tm segment 2         # Ver segundo combate
```

---

## 🔥 Sistema de Threat

### ¿Cómo activo el threat meter?

```lua
/tmthreat bar         # Mostrar barra de threat
/tmthreat alert       # Activar alertas
```

### ¿Qué significan los colores?

- 🟢 **Verde** (<70%): Threat seguro
- 🟡 **Amarillo** (70-90%): Precaución, reducir DPS
- 🔴 **Rojo** (>90%): Peligro crítico, PARAR DPS

### Mi threat no se sincroniza

1. Verifica: `/tmthreat sync`
2. Asegúrate de estar en party/raid
3. Otros jugadores deben tener TerrorMeter instalado

### ¿Cómo sé quién es el tank?

TerrorMeter detecta automáticamente al jugador con más threat como el tank.

### Las alertas no suenan

1. Verifica: `/tmthreat alert`
2. Revisa el volumen de sonidos del juego
3. Asegúrate de estar en combate

### ¿El threat es preciso?

Sí. TerrorMeter usa cálculos REALES con multiplicadores exactos de Vanilla WoW.

---

## 🔗 Integraciones

### ¿Cómo verifico las integraciones?

```lua
/tmi status
```

### TerrorSquadAI no se detecta

1. Asegúrate de que TerrorSquadAI esté instalado
2. Ejecuta `/reload`
3. Verifica con `/tmi status`

### BigWigs no se detecta

1. Asegúrate de que BigWigs esté instalado y habilitado
2. Ejecuta `/reload`
3. Verifica con `/tmi status`

### DoTimer dice "Not Found"

1. Asegúrate de que DoTimer esté instalado
2. Ejecuta `/reload`
3. Verifica con `/tmi status`

### ¿Cómo veo DPS por fase de boss?

```lua
/tmi phases
```

Requiere BigWigs instalado.

### ¿Cómo veo DoTs activos?

```lua
/tmi dots
```

Requiere DoTimer instalado.

---

## ⚙️ Configuración

### ¿Cómo cambio el tamaño de la ventana?

```lua
/tm scale 1.5         # 150% del tamaño normal
/tm scale 0.8         # 80% del tamaño normal
```

### ¿Cómo cambio la transparencia?

```lua
/tm alpha 0.8         # 80% opaco
/tm alpha 1.0         # 100% opaco
```

### ¿Cómo bloqueo la ventana?

```lua
/tm lock 1            # Bloquear
/tm lock 0            # Desbloquear
```

### ¿Cómo cambio el número de filas?

```lua
/tm rows 15           # Mostrar 15 filas
```

### ¿Cómo cambio la textura de las barras?

```lua
/tm texture 1         # Textura 1
/tm texture 2         # Textura 2
/tm texture 3         # Textura 3
/tm texture 4         # Textura 4
```

### ¿Cómo activo colores pastel?

```lua
/tm pastel 1          # Activar
/tm pastel 0          # Desactivar
```

---

## 🐛 Problemas Comunes

### El DPS parece bajo

1. **Aumenta el rango del combat log:**
   ```lua
   /run for _,n in pairs({"Party", "PartyPet", "FriendlyPlayers", "FriendlyPlayersPets", "HostilePlayers", "HostilePlayersPets", "Creature" }) do SetCVar("CombatLogRange"..n, 200) end
   ```

2. **Verifica que estés en modo "Current"** para ver el combate actual

3. **Asegúrate de estar haciendo daño** - TerrorMeter solo cuenta daño registrado en el combat log

### No veo a otros jugadores

1. Aumenta el rango del combat log (ver arriba)
2. Asegúrate de estar en party/raid
3. Verifica: `/tm trackall 1` para rastrear todos

### La ventana desapareció

```lua
/tm visible 1
```

### La ventana está fuera de la pantalla

1. Desbloquea: `/tm lock 0`
2. Resetea posición: `/tm reset` (esto resetea TODO)
3. O edita manualmente `SavedVariables/TerrorMeter.lua`

### Errores de Lua

1. Asegúrate de tener la última versión
2. Desactiva otros addons para verificar conflictos
3. Reporta el error a darck en Turtle WoW

### El addon consume mucha memoria

TerrorMeter es muy eficiente, pero si notas problemas:

1. Resetea datos regularmente: `/tm reset`
2. Reduce el rango del combat log
3. Desactiva integraciones no usadas

---

## 📊 Rendimiento

### ¿Cuánta memoria usa?

TerrorMeter usa aproximadamente 1-3 MB de memoria, dependiendo de cuántos datos estén almacenados.

### ¿Afecta el FPS?

No significativamente. El overhead es mínimo (<1% CPU).

### ¿Puedo usarlo en raids de 40 personas?

Sí, TerrorMeter está optimizado para raids grandes.

---

## 🔄 Sincronización

### ¿Cómo funciona la sincronización?

Cada jugador con TerrorMeter comparte sus datos de threat cada 2 segundos durante combate.

### ¿Todos necesitan TerrorMeter?

Para sincronización de threat, sí. Para las demás funciones, no.

### ¿Funciona entre facciones?

No. Solo funciona dentro de tu party/raid.

### ¿Genera lag?

No. Los mensajes son muy pequeños y se envían solo durante combate.

---

## 🎯 Uso Avanzado

### ¿Cómo optimizo mi DPS con TerrorMeter?

1. **Usa modo "Current"** para ver DPS del combate actual
2. **Compara segmentos** para ver mejoras
3. **Usa integración con DoTimer** para mantener uptime de DoTs
4. **Analiza DPS por fase** con BigWigs
5. **Maneja threat** para evitar parar DPS

### ¿Cómo uso TerrorMeter como tank?

1. **Activa threat meter:** `/tmthreat bar`
2. **Monitorea tu threat** vs el raid
3. **Usa sugerencias de TerrorSquadAI** para optimizar rotación
4. **Comunica al raid** cuando necesiten reducir DPS

### ¿Cómo uso TerrorMeter como healer?

1. **Monitorea HPS** en lugar de DPS
2. **Maneja threat de curación** con la barra de threat
3. **Analiza eficiencia** por fase de boss

### ¿Puedo crear macros con TerrorMeter?

Sí, todos los comandos funcionan en macros:

```lua
/tm toggle
/tmthreat bar
/tm report party
```

---

## 📝 Datos y Estadísticas

### ¿Dónde se guardan los datos?

```
WTF/Account/[ACCOUNT]/SavedVariables/TerrorMeter.lua
```

### ¿Puedo exportar datos?

Actualmente no hay función de exportación, pero puedes copiar el archivo `TerrorMeter.lua`.

### ¿Cuántos segmentos se guardan?

TerrorMeter guarda todos los segmentos de la sesión actual. Se resetean al cerrar WoW.

### ¿Puedo ver estadísticas históricas?

No actualmente. Los datos se resetean al cerrar WoW.

---

## 🔗 Comparación con Otros Addons

### TerrorMeter vs Recount

| Característica | TerrorMeter | Recount |
|-----------------|-------------|----------|
| DPS/HPS | ✅ | ✅ |
| Threat Meter | ✅ | ❌ |
| Sincronización | ✅ | ✅ |
| Alertas de Threat | ✅ | ❌ |
| Integraciones | ✅ | ❌ |
| Memoria | Baja | Media |

### TerrorMeter vs Omen

| Característica | TerrorMeter | Omen |
|-----------------|-------------|-------|
| Threat Meter | ✅ | ✅ |
| DPS/HPS | ✅ | ❌ |
| Alertas Visuales | ✅ | ✅ |
| Múltiples Objetivos | ❌ | ✅ |
| Integraciones | ✅ | ❌ |

### ¿Puedo usar TerrorMeter con Recount?

Sí, pero no es recomendado ya que ambos parsean el combat log. Mejor usa solo TerrorMeter.

### ¿Puedo usar TerrorMeter con Omen?

Sí, pero TerrorMeter ya incluye threat meter, así que Omen sería redundante.

---

## 👥 Soporte

### ¿Dónde reporto bugs?

Contacta a **darck** en Turtle WoW.

### ¿Dónde sugiero nuevas características?

Contacta a **darck** en Turtle WoW.

### ¿Hay un Discord?

Contacta a **El Séquito del Terror** en Turtle WoW para más información.

### ¿Puedo contribuir al código?

Sí, el addon es de código abierto. Contacta a darck.

---

## 🔗 Ver También

- [README.md](README.md) - Guía principal
- [COMMANDS.md](COMMANDS.md) - Lista completa de comandos
- [THREAT_SYSTEM.md](THREAT_SYSTEM.md) - Sistema de threat
- [INTEGRATION.md](INTEGRATION.md) - Integraciones
- [CHANGELOG.md](CHANGELOG.md) - Historial de cambios

---

**¡Por el Terror y la Gloria!** 🔥
