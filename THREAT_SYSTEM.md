# TerrorMeter - Sistema de Threat

## 💥 Introducción

El sistema de threat de TerrorMeter es un cálculo REAL de amenaza que utiliza multiplicadores precisos por stance, forma, y habilidades específicas. No es una estimación basada en DPS, sino un cálculo exacto basado en las mecánicas de Vanilla WoW.

---

## 📊 Cómo Funciona el Threat

### Concepto Básico

En World of Warcraft, cada acción que realizas genera **threat** (amenaza) en los enemigos. El enemigo atacará al jugador con más threat en su tabla de amenaza.

**Regla de Oro:**
- Si estás en **melee range**: Necesitas **110%** del threat del tank para pullear
- Si estás en **ranged**: Necesitas **130%** del threat del tank para pullear

---

## ⚔️ Cálculo de Threat por Daño

### Daño Base

```
Threat Base = Daño Realizado
```

Cada punto de daño genera 1 punto de threat (antes de multiplicadores).

### Multiplicadores por Stance/Form

| Clase | Stance/Form | Multiplicador |
|-------|-------------|---------------|
| Warrior | Defensive Stance | x1.3 |
| Warrior | Battle Stance | x0.8 |
| Warrior | Berserker Stance | x0.8 |
| Druid | Bear Form | x1.3 |
| Druid | Cat Form | x0.71 |
| Paladin | Righteous Fury | x1.6 |

### Ejemplo

```
Warrior en Defensive Stance hace 100 de daño:
Threat = 100 * 1.3 = 130 threat

Mage hace 100 de daño:
Threat = 100 * 1.0 = 100 threat
```

---

## 🛡️ Threat por Habilidad

Algunas habilidades generan threat adicional además del daño:

### Warrior

| Habilidad | Threat Adicional | Notas |
|-----------|------------------|-------|
| Sunder Armor | +260 | Por stack |
| Heroic Strike | +145 | Más el daño |
| Shield Slam | +250 | Más el daño |
| Revenge | +315 | Más el daño |
| Shield Bash | +180 | Más el daño |
| Taunt | Iguala threat | Dura 3 segundos |

### Druid

| Habilidad | Threat Adicional | Notas |
|-----------|------------------|-------|
| Maul | +322 | Más el daño |
| Swipe | +285 | Más el daño |
| Growl | Iguala threat | Dura 3 segundos |
| Faerie Fire (Feral) | +108 | Por cast |

### Paladin

| Habilidad | Threat Adicional | Notas |
|-----------|------------------|-------|
| Holy Shield | +180 | Por bloqueo |
| Blessing of Salvation | -30% threat | Reduce threat generado |
| Righteous Fury | x1.6 | Multiplicador global |

### Rogue

| Habilidad | Threat Adicional | Notas |
|-----------|------------------|-------|
| Feint | -600 threat | Reduce threat instantáneo |

---

## ❤️ Threat por Curación

### Cálculo de Healing Threat

```
Threat por Curación = (Curación Efectiva * 0.5) / Número de Enemigos
```

### Ejemplo

```
Priest cura 1000 HP con 3 enemigos en combate:
Threat = (1000 * 0.5) / 3 = 166.67 threat por enemigo
```

### Notas Importantes

1. **Overheal no genera threat** - Solo la curación efectiva cuenta
2. **Se divide entre enemigos** - Más enemigos = menos threat por enemigo
3. **Multiplicador 0.5** - La curación genera la mitad de threat que el daño

---

## 🔄 Sincronización de Threat

### Cómo Funciona

1. **Cada jugador** con TerrorMeter calcula su propio threat
2. **Cada 2 segundos** durante combate, envía sus datos al grupo
3. **TerrorMeter recibe** datos de otros jugadores
4. **Calcula automáticamente** quién es el tank (más threat)
5. **Muestra tu %** de threat relativo al tank

### Detección Automática de Tank

```lua
Tank = Jugador con más threat en el grupo
```

No necesitas configurar quién es el tank, TerrorMeter lo detecta automáticamente.

### Protocolo de Sincronización

```lua
-- Mensaje enviado cada 2 segundos:
{
  player = "NombreJugador",
  threat = 12500,
  threatPercent = 85.5,
  dps = 450
}
```

---

## ⚠️ Sistema de Alertas

### Niveles de Alerta

| Nivel | % Threat | Color | Acción Recomendada |
|-------|----------|-------|----------------------|
| Seguro | <70% | 🟢 Verde | Continuar DPS normal |
| Precaución | 70-90% | 🟡 Amarillo | Reducir DPS |
| Crítico | >90% | 🔴 Rojo | PARAR DPS inmediatamente |

### Alertas Visuales

**Barra de Threat Personal:**
```
┌────────────────────────────────────────┐
│ Threat: 85% [█████████████████   ] │
└────────────────────────────────────────┘
```

La barra cambia de color según tu nivel de threat.

### Alertas Sonoras

- **Sonido de advertencia** cuando threat > 90%
- Se reproduce cada 5 segundos mientras estés en peligro
- Ayuda a prevenir pulls accidentales

---

## 🎯 Estrategias de Manejo de Threat

### Para DPS

1. **Espera 2-3 segundos** después del pull antes de hacer DPS full
2. **Observa tu barra de threat** constantemente
3. **Si llegas a amarillo:** Reduce DPS al 50%
4. **Si llegas a rojo:** PARA completamente por 2-3 segundos
5. **Usa habilidades de reducción de threat:**
   - Rogue: Feint
   - Mage: Invisibility (emergencia)
   - Hunter: Feign Death

### Para Tanks

1. **Usa habilidades de threat** en rotación:
   - Warrior: Sunder Armor, Shield Slam, Revenge
   - Druid: Maul, Swipe, Faerie Fire (Feral)
   - Paladin: Holy Shield con Righteous Fury
2. **Mantén Defensive Stance/Bear Form/Righteous Fury** activo
3. **Usa Taunt** cuando alguien esté por pullear
4. **Comunica al grupo** si necesitan reducir DPS

### Para Healers

1. **Espera que el tank genere threat** antes de curar
2. **Usa curaciones más pequeñas y frecuentes** en lugar de grandes heals
3. **Blessing of Salvation** en Paladins reduce threat 30%
4. **Posiciónate lejos** para beneficiarte del 130% threshold

---

## 📊 Ejemplos Prácticos

### Ejemplo 1: Warrior Tank vs Mage DPS

```
Warrior Tank (Defensive Stance):
- Hace 100 de daño con Heroic Strike
- Threat = (100 + 145) * 1.3 = 318.5 threat

Mage DPS:
- Hace 500 de daño con Fireball
- Threat = 500 * 1.0 = 500 threat

Threat % del Mage = (500 / 318.5) * 100 = 157%
⚠️ PELIGRO! El Mage pulleará (necesita 130% en ranged)
```

### Ejemplo 2: Druid Tank con Maul

```
Druid Tank (Bear Form):
- Hace 200 de daño con Maul
- Threat = (200 + 322) * 1.3 = 678.6 threat

Rogue DPS (melee):
- Hace 600 de daño
- Threat = 600 * 1.0 = 600 threat

Threat % del Rogue = (600 / 678.6) * 100 = 88.4%
🟡 PRECAUCIÓN! Reducir DPS
```

### Ejemplo 3: Priest Healing

```
Priest cura 2000 HP con 5 enemigos:
- Threat = (2000 * 0.5) / 5 = 200 threat por enemigo

Tank tiene 5000 threat:
- Threat % del Priest = (200 / 5000) * 100 = 4%
🟢 SEGURO
```

---

## 🔧 Comandos de Threat

### Activar Sistema

```lua
/tmthreat bar          # Mostrar barra de threat
/tmthreat alert        # Activar alertas
/tmthreat sync         # Activar sincronización
```

### Diagnóstico

```lua
/tmthreat status       # Ver estado del sistema
/tmthreat reset        # Resetear datos de threat
```

---

## 📝 Notas Técnicas

### Limitaciones

1. **Requiere combat log** - Aumenta el rango a 200 yardas para mejores resultados
2. **Solo jugadores con TerrorMeter** - La sincronización solo funciona entre jugadores con el addon
3. **Taunt no se sincroniza** - El efecto de Taunt es temporal y local
4. **Threat tables separadas** - Cada enemigo tiene su propia tabla de threat

### Precisión

El sistema de threat de TerrorMeter es **altamente preciso** porque:
- Usa multiplicadores exactos de Vanilla WoW
- Calcula threat por habilidad específica
- Detecta stances/forms automáticamente
- Sincroniza datos en tiempo real

### Diferencias con Omen

TerrorMeter NO es Omen, pero ofrece:
- ✅ Cálculos precisos de threat
- ✅ Sincronización entre jugadores
- ✅ Alertas visuales y sonoras
- ❌ No muestra threat de otros jugadores en la ventana principal
- ❌ No muestra múltiples objetivos simultáneamente

---

## 🔗 Integración con TerrorSquadAI

Cuando TerrorSquadAI está instalado:

1. **TerrorMeter envía datos de threat** a TerrorSquadAI
2. **TerrorSquadAI analiza** la situación
3. **Genera sugerencias inteligentes:**
   - "Reduce DPS, threat crítico!"
   - "Usa Feint para reducir threat"
   - "Espera que el tank genere más threat"

Ver [INTEGRATION.md](INTEGRATION.md) para más detalles.

---

## ❓ Preguntas Frecuentes

### ¿Por qué mi threat no se sincroniza?

1. Verifica que `/tmthreat sync` esté activado
2. Asegúrate de estar en party/raid
3. Otros jugadores deben tener TerrorMeter instalado

### ¿Por qué las alertas no suenan?

1. Verifica que `/tmthreat alert` esté activado
2. Revisa el volumen de sonidos del juego
3. Asegúrate de estar en combate

### ¿Cómo sé quién es el tank?

TerrorMeter detecta automáticamente al jugador con más threat como el tank. No necesitas configurarlo.

### ¿Funciona en solo?

Sí, el cálculo de threat funciona en solo, pero la sincronización obviamente requiere estar en grupo.

---

## 🔗 Ver También

- [README.md](README.md) - Guía principal
- [COMMANDS.md](COMMANDS.md) - Lista de comandos
- [INTEGRATION.md](INTEGRATION.md) - Integraciones
- [FAQ.md](FAQ.md) - Preguntas frecuentes

---

**¡Domina el threat y nunca más pulees accidentalmente!** 🔥
