# Legislatur_50_Koalitionen
Zum Abschluss der 50. Legislatur haben wir eine Analyse durchgeführt, um die Mehrheitsverhältnisse im Nationalrat zu untersuchen

Die Analyse findet in drei Teilen statt:

1. Abfragen der benötigten Daten aus dem offiziellen API des Parlaments (R-Script)
2. Auswerten dieser Rohdaten aufbereiten für die Schritte 3 und 4
3. Übereinstimmung der einzelnen Parlamentarier und Fraktionen mit der Mehrheit analysieren (GoogleSheet)
4. Koalitionen untersuchen GoogleSheet

## 1. Abfrage der Daten aus der API
In einer ersten Abfrage wurde die Liste aller Abstimmungen im Nationalrat der Betrachteten Legislaturperioden (49 & 50) der API angefragt.
(--> https://ws.parlament.ch/odata.svc/Vote)

In einem zweiten Schritt wurden die Voten aller Parlamentarier zu diesen Abstimmungen von der API abgefragt.
(--> https://ws.parlament.ch/odata.svc/Voting)

Die Resultate beider Anfragen werden als .csv Datei im  zwischengespeichert.
voteIds.csv  
votes_49.csv  
votes_50.csv  


## 2. Aufbereitung der Daten
Dei Daten wird in zwei Versionen aufbereitet:
- Mit allen Abstimmungen in diesen Zeitraum
- Nur Mit Schluss- und Gesamtabstimmungen berücksichtigt
Jeweils für die 49 und die 50 Legislaturperiode getrennt. das Skript muss mehrmals ausgeführt werden mit den jeweiligen Werten angepasst.

## 3. 

## 4. Analyse der Koalitionen
(--> GoogleSheet)

Es wurde untersucht, in welchen Koalitionen Mehrheitsverhältnisse zustande kamen.

Damit eine Mehrheit einer bestimmten Koaliton zugeordnet werden kann, wurde folgendes Kriterium angewendet: Die Koalitionspartner müssen jeweils mit mindestens 75% der anwesenden Fraktionsmitglieder zur Mehrheit beitragen und die Gegner der Koalition dürfen zu höchstens 25% zur Mehrheit beitragen. Dabei wurden auch Mehrheiten berücksichtigt welche zu einer Ablehnung einer Vorlage geführt haben. Für die Koalitionsbildung wurden nur die Bundesratsparteien berücksichtigt (mit ausnahme der Grünen in der Links-Grünen Koalition). Das Abstimmungsverhalten der anderen Fraktionen wurde nicht berücksichtigt.

Folgende Koalitionen wurden untersucht:

**Links-Grün:**
	SP mind. 75% der Fraktionstimmen
	FDP und SVP max. 25% der Fraktionstimmen
	CVP max. 75% der Fraktionstimmen (für Abgrenzung gegenüber Mitte-Links)

**Mitte - Links:**
  SP und CVP min. 75% der Fraktionstimmen
  FDP und SVP max. 25% der Fraktionstimmen

**Alle gegen die SVP oder Koalition der Vernunft:** 
  SP, CVP und FDP  min. 75% der Fraktionstimmen
  SVP max. 25% der Fraktionstimmen

**Grosse Koalition:**
  SP, SVP, CVP und FDP min. 75% der Fraktionstimmen

**Mitte-Rechts:**
  CVP, FDP und SVP min. 75% der Fraktionstimmen
  SP max. 25% der Fraktionstimmen

**Rechts:**
  FDP und SVP min. 75% der Fraktionstimmen
  SP max. 25% der Fraktionstimmen
  CVP max. 75% der Fraktionstimmen (für Abgrenzung gegenüber Mitte-Rechts)

**Unheilige Allianz:**
	SP und SVP min. 75%
	FDP und CVP max. 25%

**Mitte-Allianz:**
  CVP und FDP min. 75% der Fraktionstimmen
  SP und SVP max. 25% der Fraktionstimmen
  
**SVP-CVP:**
  SVP und CVP min. 75% der Fraktionstimmen
  FDP und SP max.  25% der Fraktionstimmen
 
