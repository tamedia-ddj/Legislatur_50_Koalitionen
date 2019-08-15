# Mehrheitsfähige Koalitionen im Nationalrat
Zum Abschluss der 50. Legislatur hat das Tamedia-Datenteam für die Sonntagszeitung eine Analyse durchgeführt, um die Mehrheitsverhältnisse im Nationalrat des Schweizer Parlaments zu untersuchen. Grundlage waren alle Abstimmungen im Nationalrat in der Legislatur 49 und 50 (bis und mit Sommersession 2019). Für die Koalitionsanalyse wurde nur die Untergruppe der als Schlus- und Gesamtabstimmungen kategorisierten Abstimmungen gesondert betrachtet.  

Die Analyse findet in vier Teilen statt:

1. Abfragen der benötigten Daten aus dem offiziellen API des Parlaments (R-Script)
2. Aufbereiten dieser Rohdaten für die Schritte 3 und 4 (R-Script)
3. Übereinstimmung der einzelnen Parlamentarier und Fraktionen mit der Mehrheit im Parlament analysieren (GoogleSheet)
4. Mehrheitsfähige Koalitionen untersuchen (GoogleSheet)

Es wurden Daten aus der offiziellen API des Schweizer Parlaments verwendet (https://ws.parlament.ch/odata.svc).

Die Erkenntnisse aus der Analyse wurden am 11.08.2019 [in der Sonntagszeitung publiziert](https://www.tagesanzeiger.ch/sonntagszeitung/der-rechte-block-hat-sich-nicht-durchgesetzt/story/12812505 "Artikel in der Sonntagszeitung").

## 1. Abfrage der Daten aus der API
--> R-Script "1_Abfrage_API.R"

In einer ersten Abfrage wurde die Liste aller Abstimmungen im Nationalrat der betrachteten Legislaturperioden (49 & 50) von der API angefragt.
(--> https://ws.parlament.ch/odata.svc/Vote)

In einem zweiten Schritt wurden die Voten aller Parlamentarier zu diesen Abstimmungen von der API abgefragt.
(--> https://ws.parlament.ch/odata.svc/Voting)

Die Resultate beider Anfragen werden als .csv Datei exportiert:
- voteIds.csv  (--> Liste mit den Ids aller Abstimmungen)
- votes_49.csv  (--> Liste mit Voten von allen Parlamentariern der Legislatur 49) --> Zipfile aus Platzgründen
- votes_50.csv  (--> Liste mit Voten von allen Parlamentariern der Legislatur 50) --> Zipfile aus Platzgründen


## 2. Aufbereitung der Daten
--> R-Script "2_Aufbereitung_Daten.R"

Die Dateien votes49/50.csv aus dem vorhergehenden Schritt werden eingelesen und weiter aufbereitet.

Für jeden Parlamentarier wird ausgerechnet, wie häufig er mit der Mehrheit abstimmt. Eine Abstimmung gilt als angenommen, wenn mehr als 50% der Ja/Nein Stimmen dafür sind. Enthaltungen werden nicht berücksichtigt. Sollte bei einer Abstimmung die Stimme der Nationalratspräsidentin ausschlaggebend sein oder ein anderes Annahmekriterium gelten, wird dies nicht berücksichtigt.

Das Skript muss mehrmals ausgeführt werden (mit den jeweiligen Parametern angepasst) um die 4 Datensätze (jeweils für Legislatur 49 und 50 und für alle bzw. nur die Schluss- und Gesamtabstimmungen) zu erzeugen. Die Datensätze werden in 4 separaten .csv Dateien abgespeichert:  
- ranking_leg49_alleAbstimmungen.csv
- ranking_leg49_nurGesamtabstimmungen.csv
- ranking_leg50_alleAbstimmungen.csv
- ranking_leg50_nurGesamtabstimmungen.csv

Diese .csv Dateien werden dann im Schritt 3 mit GoogleSheets weiter analysiert.

Weiter wird die Zustimmungen der einzelnen Fraktionen zu den Abstimmungen berechnet. Für die Zustimmung der Fraktion wird die Anzahl Ja-Stimmen im Verhältniss zu den anwesenden Fraktionsmitglieder berechnet. Die Enthaltungen werden also ebenfalls berücksichtigt. Folgenden Dateien werden ausgegeben:  
- Koalitionen_leg49_nurGesamt.csv
- Koalitionen_leg50_nurGesamt.csv

Diese .csv Dateien werden dann im Schritt 4 mit GoogleSheets weiter analysiert.

## 3. Übereinstimmung der Parlamentarier mit der Mehrheit
--> GoogleSheets   
> https://docs.google.com/spreadsheets/d/17SoKvGvH-wMdT2Cz0eQ4B4pQ9AoAh6qdsYaGqga4u8U/edit?usp=sharing

Eine Rangliste wird erstellt welche Parlamentarier am häufigsten mit der Mehrheit abstimmen. 

Dann werden diese Resultate auf die Fraktionen aggregiert. Daraus lässt sich ablesen in welcher Fraktion die Mitglieder am häufigsten mit der Mehrheit abstimmen.

## 4. Analyse der Koalitionen
--> GoogleSheets:  
> Legislatur 49: https://docs.google.com/spreadsheets/d/1zC8v8lA4EJtWysXh2ntNDnthv0dNE0xrY7bjQwrc8dc/edit?usp=sharing  
> Legislatur 50: https://docs.google.com/spreadsheets/d/1aF1Z3oJ8p-sxrXMDFnsVsXlX_N2eXMTf-klWMjCFC_c/edit?usp=sharing

Es wurde untersucht, in welchen Koalitionen Mehrheitsverhältnisse zustande kamen.

Damit eine Mehrheit einer bestimmten Koalition zugeordnet werden kann, wurde folgendes Kriterium angewendet: Die Koalitionspartner müssen jeweils mit mindestens 75% der anwesenden Fraktionsmitglieder zur Mehrheit beitragen und die Gegner der Koalition dürfen zu höchstens 25% zur Mehrheit beitragen. Dabei wurden auch Mehrheiten berücksichtigt, welche zu einer Ablehnung einer Vorlage geführt haben. Für die Koalitionsbildung wurden nur die Bundesratsparteien berücksichtigt (mit Ausnahme der Grünen in der Links-Grünen Koalition). Das Abstimmungsverhalten der anderen Fraktionen wurde nicht berücksichtigt. Diese Analyse wurde nur für die Schluss- und Gesamtabstimmungen gemacht.

Die untersuchten Koalitionen haben wir folgendermassen definiert:

**Links-Grün:**   
  SP und Grüne min. 75% der Fraktionstimmen   
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
  SP und SVP min. 75% der Fraktionstimmen  
  FDP und CVP max. 25% der Fraktionstimmen  

**Mitte-Allianz:**   
  CVP und FDP min. 75% der Fraktionstimmen   
  SP und SVP max. 25% der Fraktionstimmen
  
**SVP-CVP:**   
  SVP und CVP min. 75% der Fraktionstimmen   
  FDP und SP max.  25% der Fraktionstimmen
 
Die Koalitionen schliessen sich gegenseitig aus, das heisst jede Abstimmung wird maximal einer Koalition zugewiesen. Ein Teil der Abstimmung kann keiner der oben definierten Koalitionen zugewiesen werden. In diesem Fall wird von einer "Diffusen Mehrheit" ausgegangen.
