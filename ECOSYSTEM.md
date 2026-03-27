# El Ecosistema del Terror - Manual de Inteligencia Colectiva
> **Versión del Documento:** 9.3.0 [God-Tier]
> **Componente:** TerrorMeter (El Sistema Nervioso)
> **Arquitecto:** DarckRovert / Elnazzareno

## 🌐 ¿Qué es el Ecosistema?
No has instalado addons separados. Has instalado una **Red Neural de Combate** de 10 piezas construida a medida para Turtle WoW.
Estos componentes interactúan en tiempo real mediante canales de comunicación ocultos para sincronizar la información táctica, la sanación, y la economía de toda la banda.

---

## 🗺️ Diagrama de Arquitectura de la Mente de Enjambre (SquadMind)

```mermaid
graph TD
    %% Estilos
    classDef core fill:#2C0000,stroke:#FF0000,stroke-width:2px,color:#fff;
    classDef combat fill:#4B0082,stroke:#9370DB,stroke-width:2px,color:#fff;
    classDef intel fill:#003366,stroke:#00BFFF,stroke-width:2px,color:#fff;
    classDef ui fill:#004d00,stroke:#00ff00,stroke-width:2px,color:#fff;
    classDef extern fill:#404040,stroke:#808080,stroke-width:1px,color:#fff;

    %% Nodos Core
    TSAI["🧠 TerrorSquadAI<br/>(Comandante Táctico)"]:::core
    WCS["🔮 WCS_Brain<br/>(Vínculo Maestro)"]:::core

    %% Nodos Combate
    TM["📊 TerrorMeter<br/>(Sistema Nervioso / Threat)"]:::combat
    HB["💚 HealBot<br/>(Soporte Vital)"]:::combat
    BW["👁️ BigWigs + TerrorLink<br/>(Detección Jefes)"]:::combat
    DT["⏱️ DoTimer<br/>(Reloj Biológico)"]:::combat

    %% Nodos Inteligencia & Logística
    AUX["💰 aux-addon<br/>(Mercado & Logística)"]:::intel
    ATLAS["🗺️ Atlas-TW<br/>(Estrategia Dungeon)"]:::intel
    PFQ["📜 pfQuest<br/>(Inteligencia de Entorno)"]:::intel

    %% Nodos UI
    PFUI["🖥️ pfUI<br/>(HUD Premium)"]:::ui

    %% Conexiones principales
    WCS <==>|OnPlayerAction / Sugerencias| TSAI
    
    %% Conexiones con TerrorMeter
    TM ==>|Envía Datos de Amenaza Crítica| TSAI
    TM ==>|Alerta de Pérdida de Agro (ToT)| HB
    TSAI ==>|Alerta al DPS Stop| PFUI
    
    %% Jugadores conectados
    SquadA(("🎮 Jugador A<br/>(Tanque)")):::extern
    SquadB(("🎮 Jugador B<br/>(Healer)")):::extern
    SquadC(("🎮 Jugador C<br/>(DPS)")):::extern

    %% Conexión de Red Séquito
    SquadA -.->|TerrorNet SYNC| TM
    SquadB -.->|TerrorNet SYNC| TM
    SquadC -.->|TerrorNet SYNC| TM
```

---

## 🧩 El Rol de TerrorMeter en el Ecosistema

TerrorMeter es el **Sistema Nervioso** de la banda. Mientras otros addons solo muestran números, TerrorMeter se comunica activamente:

1. **Alerta a TerrorSquadAI (El Cerebro)**: Si un DPS está al 90% de superar en amenaza al Tanque, TerrorMeter le grita a TerrorSquadAI.
2. **Reacción de TerrorSquadAI**: TSAI envía una advertencia a la pantalla del DPS: *"¡ALTO AL FUEGO! Modera tu DPS."*
3. **Alerta a HealBot (El Soporte Vital)**: Si el DPS finalmente roba el Aggro, TerrorMeter notifica a HealBot.
4. **Respuesta de los Healers**: El cuadro del DPS en HealBot se ilumina en ROJO (Alerta de Agro ToT), indicando a los Healers que preparen escudos de inmediato.

Esta integración en tiempo real permite prevenir wipes antes de que ocurran, coordinando a tanques, healers y DPS sin necesidad de instrucciones por voz.

---

> *"No pienses como un jugador, piensa como un enjambre."* — **El Séquito del Terror**
