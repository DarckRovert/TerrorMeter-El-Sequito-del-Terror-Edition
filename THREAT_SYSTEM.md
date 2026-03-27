# Sistema de Amenaza — TerrorMeter v9.3.0

## ¿Cómo se calcula la Amenaza?

TerrorMeter usa un modelo de amenaza basado en los coeficientes documentados de WoW 1.12.1 (Vanilla).

### Coeficientes Básicos

| Tipo de acción | Coeficiente de amenaza |
|---|---|
| Daño físico | 1.0× daño infligido |
| Daño mágico ofensivo | 1.0× daño infligido |
| Sanación | 0.5× puntos curados |
| Taunt (provocar) | Iguala al máximo de amenaza del grupo |
| Bendición de Salvación | Reduce la amenaza en un 30% |
| Benedición de Santuario | Reduce la amenaza en un 30% |

### Multiplicadores por Clase

| Clase | Multiplicador |
|---|---|
| Guerrero (Tank) | 1.495× en postura defensiva |
| Paladín (Tank) | 1.495× con escudo |
| Druida (Flight Form) | 1.0× |
| Warlock | 0.8× base |
| Mago | 0.8× base |
| Sacerdote | 0.5× base (sanación) |

## Indicadores Visuales

| Color | Significado |
|---|---|
| 🟢 Verde | Amenaza < 60% del tank |
| 🟡 Amarillo | Amenaza 60–80% del tank (precaución) |
| 🟠 Naranja | Amenaza 80–100% del tank (peligro) |
| 🔴 Rojo | Amenaza > 100% (estás generando agro) |

## Limitaciones

- En Vanilla WoW 1.12.1 la API no expone la amenaza real del servidor.
- TerrorMeter usa una estimación basada en el combat log, que puede diferir en ±5% del valor real.
- Para máxima precisión, úsalo en combinación con el addon de tank del clan.