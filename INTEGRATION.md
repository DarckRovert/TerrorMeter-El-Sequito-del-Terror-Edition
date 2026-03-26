# TerrorMeter - Guía de Integraciones

## 🔗 Terror Ecosystem

TerrorMeter es parte del **Terror Ecosystem**, un conjunto de addons que trabajan juntos para proporcionar la mejor experiencia de raid/dungeon posible.

```
┌─────────────────────────────────────────────────────────────┐
│                     TERROR ECOSYSTEM                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────┐         ┌──────────────┐                 │
│  │ WCS_Brain    │◄───────►│TerrorSquadAI │                 │
│  │ (Master/DQN) │         │ (AI Suggest) │                 │
│  └──────┬───────┘         └──────┬───────┘                 │
│         │                        │                         │
│         ▼                        ▼                         │
│  ┌──────────────┐         ┌──────────────┐                 │
│  │ TerrorMeter  │         │   pfUI / HB  │                 │
│  │ (DPS/Threat) │         │ (Interface)  │                 │
│  └──────────────┘         └──────────────┘                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🤖 Integración con TerrorSquadAI

### ¿Qué es TerrorSquadAI?

TerrorSquadAI es un addon de inteligencia artificial que proporciona sugerencias en tiempo real durante combate basándose en los datos de TerrorMeter.

### Características de la Integración

#### 1. Envío de Datos de Threat

TerrorMeter envía automáticamente:
- Threat actual del jugador
- Threat % relativo al tank
- DPS actual
- Quién es el tank

#### 2. Sugerencias Inteligentes

TerrorSquadAI analiza los datos y genera sugerencias:

**Cuando threat > 90%:**
```
⚠️ ALERTA: Threat crítico (95%)
💡 Sugerencia: Reduce DPS inmediatamente
```

**Cuando threat 70-90%:**
```
⚠️ PRECAUCIÓN: Threat alto (85%)
💡 Sugerencia: Reduce DPS al 50%
```

**Sugerencias específicas por clase:**
- **Rogue:** "Usa Feint para reducir threat"
- **Mage:** "Deja de castear por 2 segundos"
- **Hunter:** "Considera usar Feign Death"

#### 3. Coordinación de Alertas

- TerrorMeter muestra alertas visuales
- TerrorSquadAI proporciona sugerencias textuales
- Trabajan juntos para prevenir pulls accidentales

### Comandos de Integración

```lua
/tmi status              # Ver estado de integración
/tmi ai                  # Ver info de TerrorSquadAI
/tmi sendthreat          # Enviar datos manualmente
/tmi toggle terrorai     # Activar/desactivar integración
```

### Configuración

La integración se activa automáticamente cuando ambos addons están instalados. No requiere configuración manual.

---

## 🐉 Integración con BigWigs

### ¿Qué es BigWigs?

BigWigs es un addon de boss mods que proporciona alertas y timers para boss fights.

### Características de la Integración

#### 1. Detección Automática de Boss Fights

TerrorMeter detecta cuando BigWigs inicia un boss fight:
```
[TerrorMeter] Boss fight iniciado: Ragnaros
```

#### 2. Análisis de DPS por Fase

Durante boss fights, TerrorMeter rastrea DPS por cada fase:

**Ejemplo: Ragnaros**
```
Fase 1 (Sons of Flame): 450 DPS
Fase 2 (Submerge): 0 DPS
Fase 3 (Emerge): 520 DPS
```

#### 3. Resumen Automático

Al derrotar al boss, TerrorMeter muestra un resumen:
```
╔═══════════════════════════════════════╗
║     RAGNAROS DERROTADO!               ║
╠═══════════════════════════════════════╣
║ Fase 1: 450 DPS (2:30)                ║
║ Fase 2: 0 DPS (0:45)                  ║
║ Fase 3: 520 DPS (1:15)                ║
║ ─────────────────────────────────     ║
║ Total: 380 DPS (4:30)                 ║
╚═══════════════════════════════════════╝
```

#### 4. Rastreo de Habilidades

TerrorMeter registra cuando BigWigs detecta habilidades importantes:
- Timers de habilidades
- Fases del boss
- Eventos especiales

### Comandos de Integración

```lua
/tmi status              # Ver estado de integración
/tmi phases              # Ver DPS por fase
/tmi boss                # Ver info del boss actual
/tmi resetphases         # Resetear datos de fases
/tmi toggle bigwigs      # Activar/desactivar integración
```

### Beneficios

1. **Análisis detallado** - Saber en qué fase hiciste más/menos DPS
2. **Optimización** - Identificar fases donde puedes mejorar
3. **Reportes precisos** - Compartir DPS por fase con la raid
4. **Historial** - Comparar diferentes intentos del mismo boss

---

## ⏱️ Integración con DoTimer

### ¿Qué es DoTimer?

DoTimer es un addon que rastrea DoTs (Damage over Time) y HoTs (Healing over Time) en objetivos.

### Características de la Integración

#### 1. Lectura de DoTs Activos

TerrorMeter lee los DoTs activos desde DoTimer:
```
Objetivo: Ragnaros
DoTs activos:
- Corruption (12s restantes)
- Curse of Agony (18s restantes)
- Immolate (8s restantes)
```

#### 2. Cálculo de DPS Proyectado

TerrorMeter calcula el DPS que generarán tus DoTs:
```
DPS Actual: 450
DPS Proyectado (DoTs): 180
DPS Total Estimado: 630
```

#### 3. Alertas de DoTs Expirando

Cuando un DoT importante está por expirar (<3s):
```
⚠️ ALERTA: Corruption expirando en 2s
💡 Sugerencia: Reaplica Corruption
```

#### 4. Base de Datos de DoTs Importantes

TerrorMeter conoce los DoTs importantes por clase:

**Warlock:**
- Corruption
- Curse of Agony
- Immolate
- Siphon Life

**Priest (Shadow):**
- Shadow Word: Pain
- Vampiric Embrace

**Druid:**
- Moonfire
- Insect Swarm

**Hunter:**
- Serpent Sting

**Rogue:**
- Rupture
- Garrote

### Comandos de Integración

```lua
/tmi status              # Ver estado de integración
/tmi dots                # Ver DoTs activos
/tmi dotdps              # Ver DPS proyectado
/tmi toggle dotimer      # Activar/desactivar integración
```

### Beneficios

1. **Nunca pierdas uptime** - Alertas cuando DoTs expiran
2. **DPS optimizado** - Saber cuánto DPS vienen de DoTs
3. **Priorización** - Saber qué DoT reaplicar primero
4. **Integración con TerrorSquadAI** - Sugerencias de qué DoT aplicar

---

## 🔄 Flujo de Datos del Ecosystem

### Durante Combate

```
1. TerrorMeter parsea combat log
   ↓
2. Calcula DPS y Threat
   ↓
3. Lee DoTs desde DoTimer
   ↓
4. Detecta fase de boss desde BigWigs
   ↓
5. Envía datos a TerrorSquadAI
   ↓
6. TerrorSquadAI genera sugerencias
   ↓
7. Alertas visuales en TerrorMeter
```

### Ejemplo Práctico

**Escenario:** Warlock en Ragnaros

```
[BigWigs] Ragnaros - Fase 1 iniciada
[TerrorMeter] Rastreando DPS para Fase 1
[DoTimer] Corruption aplicado (18s)
[TerrorMeter] DPS: 450, Threat: 75%
[TerrorSquadAI] ✓ Threat seguro, continúa DPS

... 15 segundos después ...

[DoTimer] Corruption expirando en 3s
[TerrorMeter] ⚠️ Corruption expirando
[TerrorSquadAI] 💡 Reaplica Corruption

... jugador reaplica Corruption ...

[TerrorMeter] DPS: 480, Threat: 88%
[TerrorSquadAI] ⚠️ Threat alto, reduce DPS

... jugador reduce DPS ...

[BigWigs] Ragnaros - Fase 2 (Submerge)
[TerrorMeter] Fase 1 completada: 465 DPS
[TerrorMeter] Rastreando DPS para Fase 2
```

---

## ⚙️ Configuración de Integraciones

### Verificar Estado

```lua
/tmi status
```

**Salida esperada:**
```
╔═══════════════════════════════════════╗
║   TERRORMETER INTEGRATION STATUS      ║
╠═══════════════════════════════════════╣
║ TerrorSquadAI: ✓ Detected             ║
║ BigWigs:       ✓ Detected             ║
║ DoTimer:       ✓ Detected             ║
╚═══════════════════════════════════════╝
```

### Activar/Desactivar Integraciones

```lua
/tmi toggle terrorai     # Toggle TerrorSquadAI
/tmi toggle bigwigs      # Toggle BigWigs
/tmi toggle dotimer      # Toggle DoTimer
```

### Resetear Datos

```lua
/tmi resetphases         # Resetear datos de fases (BigWigs)
/tm reset                # Resetear todos los datos
```

---

## 📊 Beneficios del Ecosystem Completo

### Para DPS

1. **Optimización de rotación** - Sugerencias de TerrorSquadAI
2. **Manejo de threat** - Alertas de TerrorMeter
3. **Uptime de DoTs** - Alertas de DoTimer
4. **Análisis por fase** - Datos de BigWigs

### Para Tanks

1. **Monitoreo de threat del raid** - Ver quién está cerca de pullear
2. **Sugerencias de rotación** - TerrorSquadAI optimiza threat generation
3. **Alertas de habilidades** - BigWigs + TerrorMeter

### Para Healers

1. **Manejo de threat** - Evitar overheal y threat excesivo
2. **Análisis de HPS** - Por fase de boss
3. **Sugerencias de eficiencia** - TerrorSquadAI

### Para Raid Leaders

1. **Análisis completo** - DPS por fase, threat, DoTs
2. **Identificar problemas** - Quién está pulleando, quién no usa DoTs
3. **Optimización del raid** - Datos precisos para mejorar

---

## 🛠️ Instalación del Ecosystem Completo

### Paso 1: Instalar TerrorMeter

```
Interface/AddOns/TerrorMeter/
```

### Paso 2: Instalar TerrorSquadAI

```
Interface/AddOns/TerrorSquadAI/
```

### Paso 3: Instalar BigWigs (Opcional)

```
Interface/AddOns/BigWigs/
```

### Paso 4: Instalar DoTimer (Opcional)

```
Interface/AddOns/DoTimer/
```

### Paso 5: Verificar

```lua
/reload
/tmi status
```

---

## ❓ Preguntas Frecuentes

### ¿Necesito todos los addons?

No. TerrorMeter funciona perfectamente solo. Las integraciones son opcionales y se activan automáticamente si los otros addons están instalados.

### ¿Funcionan las integraciones en TBC?

Sí, todas las integraciones funcionan tanto en Vanilla (1.12.1) como en TBC (2.4.3).

### ¿Puedo desactivar una integración?

Sí, usa `/tmi toggle [addon]` para desactivar integraciones específicas.

### ¿Las integraciones afectan el rendimiento?

No significativamente. El overhead es mínimo (<1% CPU).

### ¿Otros jugadores necesitan los mismos addons?

Para sincronización de threat, sí necesitan TerrorMeter. Para las demás funciones, no.

---

## 🔗 Ver También

- [README.md](README.md) - Guía principal
- [COMMANDS.md](COMMANDS.md) - Lista de comandos
- [THREAT_SYSTEM.md](THREAT_SYSTEM.md) - Sistema de threat
- [FAQ.md](FAQ.md) - Preguntas frecuentes
- [../TERROR_ECOSYSTEM.md](../TERROR_ECOSYSTEM.md) - Documentación completa del ecosystem

---

**¡El poder del Terror Ecosystem a tu disposición!** 🔥
