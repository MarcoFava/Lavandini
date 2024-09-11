# Parole chiave del progetto

Le seguenti sono le **parole chiave** del nostro progetto (o da considerare):

- `administrative_regions_Trentino`
- `df_corrente_dec`
- `df_corrente_nov`
- `df_meteo`
- `df_precipitazioni`
- `df_social`
- `df_ubicazioni`
- `gdf`
- `gdf_com`
- (e altri, I guess?)

## Struttura di alcuni DataFrame

- **`df_corrente`** avrà le colonne: `LINESET`, `time`, `corrente`
- **`df_precipitazioni`**: `time`, `cellId`, `pioggia`

*(Nota su novembre: nel file EDA fanno cose bruttissime che non ho capito perché sono troppo stupido)*

# Linee elettriche

1. Creo un vettore con i nomi delle linee elettriche (da `df_ubicazioni` con colonna `LINESET` (?)) e definisco la costante `conv_kWh`, con cui trasformo la corrente istante per istante nelle linee in potenza media misurata in kWh assorbita dalla rete.
   
2. **Tensione trifase** associata alle ubicazioni civili: 240V (RMS)  
   -> `conv_kWh = 240 x 3600 / 1000 = 240 x 3.6`

# Da Timestep a Data

- Creare una funzione che trasforma i timestep in date: `anno-mese-giorno...`  
  (format='%Y%m%d%H%M', I guess).
- Trasformare le colonne del tempo dei DataFrame in colonne di date.

# Richiesta dell'EDA: Aree con consumi maggiori

1. Associo il consumo medio mensile delle linee elettriche con i quadratini delle linee.
2. Calcolo la corrente pesata sulle ubicazioni dei quadratini (non ho capito), e sommo se ci sono più contributi (da più reti).
3. Plotto il risultato -> Merge con la griglia del Trentino.
4. **Attenzione:** Devono avere lo stesso sistema di coordinate (confini regioni amministrative e griglia Trentino) -> scelgo una proiezione.
5. Evidenzio i confini.

# Richiesta dell'EDA: Linee elettriche con maggiori variazioni di consumi (giornata/mese)

### Mese

1. Calcolo la "derivata" fra un giorno e l'altro (consumo medio totale della giornata) (vedi Mattedo).
2. Seleziono una soglia minima per isolare solo alcune linee.
3. Plot dei valori per visualizzare (necessario? o forse sì).
4. Plot con le linee elettriche colorate in questione sulla mappa del Trentino.

### Giornata

- Stesso procedimento ma con i vari timestep. Si può fare sui singoli timestep o sulle ore.
- Plot come sopra.

# Stazioni meteo

1. Plotto le stazioni meteo sulla mappa del Trentino (utile per le predizioni di ML per associare quadratini e dati meteo).
2. Costruisco un `GeoDataFrame` con le posizioni delle stazioni meteo (Mattedo: creano una funzione per farlo?).
3. Proietto sul sistema di coordinate corretto.

# Social Pulse

Procedimento analogo a quello per le stazioni meteo.

# Costruzione del DataFrame 'definitivo' con features

1. **Feature 'corrente pesata'**: Calcolata come indicato nella riga 23.
2. **Feature 'geometry'**: Prendo le coordinate spaziali dei quadratini -> Merge con `GeoDataFrame` (?)
3. To be continued...

# Unisco posizioni stazioni meteo

1. Spatial join tra la mappa/griglia del Trentino e il `GeoDataFrame` dei comuni (per associare stazioni meteo ai comuni).
2. Spatial join tra stazione meteo e comune associato.
3. Nel DataFrame definitivo dovrebbe comparire una **feature 'COMUNE'**.
4. Se ci sono `NaN`, significa che il comune/quadratino non ha una stazione meteo.

### Rimozione feature

1. Rimuovo la feature `geometry` che ora è inutile (abbiamo il `gdf` e i comuni).
2. Rimuovo i quadratini senza stazioni meteo nella regione amministrativa.

# Unisco dati precipitazioni

1. **Attenzione alle date**: devono essere dello stesso tipo.
2. Merge -> Feature `pioggia`.
3. Sostituisco i `NaN` con 0 (o non ci sono dati o non ha piovuto).

# Unisco features stazioni meteo (temperatura, vento, precipitazioni)

1. Creo un DataFrame delle stazioni con i dati (temp, vento, precipitazioni).
2. Merge con il DataFrame delle precipitazioni (o con il principale?).
3. **Attenzione:** Timestep di 15 minuti (contro i 10 dei consumi elettrici).
4. Sostituisco i `NaN` con una funzione di riempimento tipo `ffill()` nel DataFrame finale.
5. **Attenzione:** sempre al formato/tipo della data nei vari DataFrame quando li unisci.

# Pulizia DataFrame

1. Elimino colonne (features) non più necessarie: `lineset`, ubicazioni varie e `corrente` (sono già inglobate nella corrente pesata).
2. Elimino righe identiche.

# Unisco dati Social Pulse

1. Converto data e ora del DataFrame `social`.
2. Spatial join tra DataFrame e mappa.
3. Unisco i due DataFrame e aggiungo la colonna `tweet` (per indicare se c'è stato un tweet in un luogo).

# Ordino e chiudo DataFrame

1. Ordino per `CellId`.
2. Ordino per data e ora.
3. Sostituisco i `NaN` con `ffill()` o simile.
4. Salvo in formato `.csv`.
