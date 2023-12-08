Usage
-------------------

- `./.envrc` -> confirm by typing 'y' + ENTER
- `poetry run python ba_xai/app.py` (explicitly entering the venv in advance is not required)

Notes
-------------------

Also was steht an?

Diese Woche:
Ich möchte eine funktionierende Oberfläche haben
Ich möchte Daten hochladen können.
Wenn ich eine Datei ausgewählt habe möchte ich dass sich das Uploadfeld in den Namen der Datei verändert
Die Daten sollen auf csv dateien überpfüft werden und sonst abgelehnt werden
Die Daten sollen an das Backend weitergeleitet werden
Ich möchte das LGBM mit den Daten trainieren können
Ich möchte mit den Testdaten vorhersagen
Ich möchte die Vorhersagen anzeigen.



weiteres:
Ich möchte die Möglichkeit haben, die Parameter des LGBM zu verändern


Zum Schreiben:
Es ist kein Problem wenn da nichts passiert diese Woche

mögliche ToDo:


Wichtige Code segmente:
lgb.LGBMRegressor(
            verbose=-1, **self.parameters, importance_type="gain"
        ) #self.parameters betrifft nur die Hyperparameter

wichtig ist: 
x, y, sample_weights = self._get_training_data(hourly_sales)
self.model.fit(x, y, sample_weight=sample_weights)




README:
Was wird erwartet?
Als Eingabe für die Daten werden nur csv Dateien akzeptiert.
Die Trainingsdaten müssen eine spalte date, welches den index angibt haben. Diese wird nur für intere Zwecke verwendet
Die Trainingsdaten müssen eine spalte yhat, welche die vorhergesagten Werte enthält haben.

Die Testdaten müssen eine spalte date, welches den index angibt haben. Diese wird nur für intere Zwecke verwendet
Die Testdaten dürfen keine spalte yhat haben und müssen sonst mit den Trainingsdaten spalten übereinstimmen.