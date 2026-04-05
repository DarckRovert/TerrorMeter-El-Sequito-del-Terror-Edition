# Preguntas Frecuentes — TerrorMeter v9.3.0

**¿Por qué el DPS no coincide con el de otros addons?**
TerrorMeter filtra el daño de mascotas y los daños ambientales (venenos de suelo, fuego de mazmorra) que otros addons pueden contar como daño del jugador. Nuestro método es más preciso.

**¿Funciona en raids de 40 jugadores?**
Sí. El parser está optimizado para manejar logs masivos. El impacto de rendimiento es menor al 1% de FPS.

**¿Por qué mi healer aparece con 0 DPS?**
Cambia el modo a HPS (/tm modo hps) — los healers aparecerán con sus métricas de sanación.

**¿Puedo compartir los resultados con mi raid?**
Sí: /tm report publica un resumen de los top 5 en el canal de raid.

**¿Cómo reseteo solo los datos de un boss?**
TerrorMeter segmenta automáticamente por encuentro. Usa el selector de segmento en la parte inferior de la ventana.

**La ventana desaparece al recargar.**
Usa /tm lock para fijar la posición. Luego recarga — la posición se guarda en SavedVariables.

**¿Conflicto con otros medidores de daño?**
TerrorMeter es compatible con la mayoría de medidores. Si hay conflicto, desactiva el addon rival y usa solo TerrorMeter.