# TerrorMeter (Sistema de Amenaza y DPS) - v3.0 Séquito del Terror Edition

TerrorMeter no es solo un medidor de daño; es un sistema de telemetría de combate completo diseñado para evitar "Wipes" por exceso de agro. Es el "Sistema Nervioso" de tu raid.

## 🚀 Características Principales

### 1. Sistema de Threat (Amenaza) Real
*   **Cálculo Exacto**: Usa las fórmulas de Vanilla WoW (1.12) para calcular amenaza (Stances, Modificadores, Habilidades).
*   **Sincronización**: Comparte datos con otros usuarios de TerrorMeter para saber exactamente quién tiene el agro.
*   **No es solo estimación**: Sabe la diferencia entre un Guerrero en Actitud Defensiva y uno en Batalla.

### 2. Medidor de DPS/HPS
*   Muestra Daño, Sanación, Daño Recibido, Disipaciones, etc.
*   Compatible con mascotas y guardianes.

### 3. Alertas Inteligentes
*   **Barra de Amenaza**: Se pone ROJA cuando estás a punto de quitarle el agro al tanque.
*   **Sonidos**: Emite una advertencia auditiva si superas el umbral de seguridad (90% del agro del tanque).

## 🎮 Guía de Uso

### Ventana Principal
*   Click en el botón **"Mode"** para cambiar entre Threat, DPS, Healing, etc.
*   **Click Derecho** en la barra de título para opciones rápidas.

### Comandos de Amenaza
*   `/tmthreat bar` - Muestra/Oculta la barra de amenaza personal.
*   `/tmthreat sync` - Activa la sincronización con el grupo (Vital para raids).

### Otros Comandos
*   `/tm` - Muestra/Oculta la ventana principal.
*   `/tm reset` - Borra los datos actuales.
*   `/tm report [canal]` - Reporta los datos al chat (party, raid, guild).

## 🌐 Integración Terror Ecosystem (Séquito Edition)

TerrorMeter es un componente vital del ecosistema táctico del clan:
*   **Sincronización Total**: Comparte datos de amenaza con todo el escuadrón.
*   **IA Táctica**: Envía datos a `TerrorSquadAI` y `WCS_Brain` para optimizar el DPS del clan sin riesgo.
*   **Ecosistema 10/10**: Parte de la red de 10 addons unificados (pfUI, HealBot, Atlas, etc.).

## 🔧 Preguntas Frecuentes

**¿Por qué necesito esto si tengo Omen?**
TerrorMeter integra DPS y Threat en uno solo, y además se comunica con la IA del escuadrón. Omen no habla con TerrorSquadAI.

**¿Funciona si juego solo?**
Sí, calcula tu amenaza personal contra el mob, pero la sincronización requiere grupo.

---
*Creado para El Séquito del Terror.*
*Ver `THREAT_SYSTEM.md` para detalles matemáticos del cálculo de agro.*
