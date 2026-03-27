# TerrorMeter — v9.3.0 [God-Tier] ⚔️📊

**El Sistema Nervioso del Raid — "El Séquito del Terror"**

TerrorMeter no es solo un medidor de daño; es un sistema de telemetría de combate completo diseñado para evitar wipes por exceso de amenaza. Calcula la amenaza real usando las fórmulas de Vanilla WoW (1.12), sincroniza los datos con todo el grupo, y los comparte con la red de IA del clan.

- **Autores originales**: Shino, Phanx, Vgit
- **Edición Séquito**: DarckRovert (Elnazzareno)
- **Versión**: 9.3.0 [God-Tier]
- **Compatibilidad**: Turtle WoW 1.12 (Lua 5.0)

---

## 🚀 Características Principales

### 1. Sistema de Threat (Amenaza) Real
- **Cálculo Exacto**: Usa las fórmulas de Vanilla WoW para calcular amenaza (Stances, Modificadores, Habilidades, Snarls).
- **Sincronización**: Comparte datos con otros usuarios de TerrorMeter para saber exactamente quién tiene el agro.
- **No es estimación**: Distingue entre un Guerrero en Actitud Defensiva y uno en Batalla.
- **60+ modificadores**: Habilidades de todas las clases con su valor de amenaza exacto.

### 2. Medidor de DPS/HPS
- Muestra Daño, Sanación, Daño Recibido, Disipaciones, Interrupciones.
- Compatible con mascotas y guardianes (Animal Companion, Imp, etc.).
- Múltiples modos de vista: Overall, Current Segment, Per-Boss.

### 3. Alertas Inteligentes de Amenaza
- **Barra Visual**: Se pone **ROJA** cuando estás al 90%+ del agro del tanque.
- **Sonidos**: Emite advertencia auditiva justo antes del pull de agro.
- **Umbral configurable**: 70% (advertencia), 90% (crítico).

### 4. Localización Dual (v9.3.0)
| Idioma | Locale | Labels |
|--------|--------|--------|
| Español | esES / esMX | Daño, Sanación, Amenaza, Actual, Total |
| Inglés | enUS (todos los demás) | Damage, Heal, Threat, Current, Overall |

- Archivos: `locale_en.lua` (base) y `locale_es.lua` (override automático para esES/esMX).

---

## 🌐 Integración Terror Ecosystem

TerrorMeter es un componente vital de la red táctica del clan:

| Integración | Función |
|-------------|---------|
| **TerrorSquadAI** | Envía datos de DPS/amenaza para decisiones tácticas |
| **WCS_Brain** | Proporciona datos de amenaza para que la IA de Warlock ajuste su DPS |
| **HealBot** | Muestra estado de amenaza de cada aliado en el frame de sanación |
| **pfUI** | Integración con los frames de unidad del clan |

> **¿Por qué TerrorMeter y no Omen?** TerrorMeter integra DPS y Threat en una sola ventana, y se comunica con la IA del escuadrón. Omen no habla con TerrorSquadAI ni con WCS_Brain.

---

## 🎮 Guía de Uso

### Ventana Principal
- Click en **"Mode"** para cambiar entre Threat, DPS, Healing, etc.
- **Click Derecho** en la barra de título para opciones rápidas.
- Las filas de jugadores muestran porcentaje de amenaza relativo al tanque.

### Comandos de Amenaza
```
/tmthreat bar      — Muestra/Oculta la barra de amenaza personal
/tmthreat sync     — Activa la sincronización con el grupo (vital para raids)
```

### Comandos Generales
```
/tm                — Muestra/Oculta la ventana principal
/tm reset          — Borra los datos del segmento actual
/tm report [canal] — Reporta los datos al chat (party, raid, guild)
```

---

## 📋 Preguntas Frecuentes

**¿Funciona si juego solo?**
Sí, calcula tu amenaza personal contra el mob, pero la sincronización requiere grupo.

**¿Cómo activo la sincronización?**
Con `/tmthreat sync`. Todos los miembros del grupo con TerrorMeter deben activarla.

**¿Afecta el rendimiento (FPS)?**
Mínimamente. Usa parsing de Combat Log con throttling. En raids de 40 personas el impacto es menor al 1%.

---

## 📈 Changelog

### v9.3.0 [God-Tier]
- Localización dual implementada (esES/esMX + enUS) via `locale_en.lua` / `locale_es.lua`
- UI labels localizados con variables `TM_L` para todas las views y botones
- Integración con TerrorSquadAI v9.3.0 (40 Grand Slots / TerrorBoard)
- Versión unificada con ecosistema v9.3.0 God-Tier

### v3.0 [Séquito Edition]
- Motor de rendimiento optimizado para raids de 40 personas
- Sincronización de amenaza en tiempo real

---

*Creado para El Séquito del Terror — Turtle WoW.*
*Ver `THREAT_SYSTEM.md` para los detalles matemáticos del cálculo de amenaza.*

---

## ?? Comunidad y Gobernanza

Este proyecto es parte del ecosistema **El S�quito del Terror**. Nos comprometemos a mantener un ambiente sano y profesional:

- ?? **[C�digo de Conducta](./CODE_OF_CONDUCT.md)**: Nuestras normas de convivencia.
- ?? **[Gu�a de Contribuci�n](./CONTRIBUTING.md)**: C�mo ayudar a expandir este addon.
- ??? **[Licencia](./LICENSE)**: Este proyecto est� bajo la Licencia MIT.

---
