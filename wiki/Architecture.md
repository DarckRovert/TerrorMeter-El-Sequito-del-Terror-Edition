# Arquitectura — TerrorMeter Sequito 🏗️

mermaid
graph TD
    LOG[Combat Log Events]
    PARSER[Parser Vanilla/TBC]
    THREAT[Threat Engine]
    SYNC[Sync Service]
    UI[Bar Window]

    LOG --> PARSER
    PARSER --> THREAT
    THREAT --> SYNC
    SYNC --> UI


## Componentes
- **parser-vanilla.lua**: Lógica de extracción de valores de amenaza del Log de Combate 1.12.
- **threat.lua**: Motor de cálculo de modificadores (Stance, Talents, Buffs).
- **sync.lua**: Sistema de mensajería P2P para sincronización en raid.
