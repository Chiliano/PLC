(*
 * non revisionato
**)



PROGRAM _INIT

END_PROGRAM


PROGRAM _CYCLIC

    VAR
        pulsante_carico_ricetta := "ingresso_1";
        finecorsa_passo         := "ingresso_2";
        ricetta : ARRAY[0..10]  := "ingresso_3";

        nr_posizione : INT := 0;
        posizione;
        appoggio1;
        appoggio2;

        mappa : ARRAY[0..10] OF ARRAY[1..10] := [
            pos_1 : ARRAY[0..10] OF INT, pos_2 : ARRAY[0..10] OF INT, pos_3 : ARRAY[0..10] OF INT,
            pos_4 : ARRAY[0..10] OF INT, pos_5 : ARRAY[0..10] OF INT, pos_6 : ARRAY[0..10] OF INT,
            pos_7 : ARRAY[0..10] OF INT, pos_8 : ARRAY[0..10] OF INT, pos_9 : ARRAY[0..10] OF INT,
            pos_10 : ARRAY[0..10] OF INT
        ];
    END_VAR

    IF nr_posizione >= 10 THEN
        nr_posizione := 0;
    END_IF;

    prima_colonna_vuota.col1 := mappa[nr_posizione];


    IF pulsante_carico_ricetta AND prima_colonna_vuota() THEN
        // Scrive nella prima colonna
        scrivi_colonna.colonna_vuota := mappa[0];
        scrivi_colonna.ricetta := ricetta;
        scrivi_colonna();
        nr_posizione := nr_posizione + 1;       // Sposto l'offset sulla prossima colonna libera 

    ELSIF pulsante_carico_ricetta AND NOT prima_colonna_vuota() THEN
        // Scala le colonne di 1
        posizione := nr_posizione;
        IF posizione >= 2 THEN
            FOR i := 0 TO nr_posizione DO
                appoggio1 := mappa[posizione];
                appoggio2 := mappa[posizione - 1];
                FOR x := 0 TO 10 DO
                    appoggio1[x] := appoggio2[x];
                END_FOR;
                posizione := posizione - 1;
            END_FOR;
        END_IF;

        // scive la nuova ricetta nella 1a colonna
        scrivi_colonna.colonna_vuota := mappa[0];
        scrivi_colonna();
        nr_posizione := nr_posizione + 1;
    END_IF;


    FUNCTION prima_colonna_vuota : BOOL
        (*
         * Ritorna 1 se la l'array ricevuto in input è vuoto
        **)
        VAR_INPUT
            col1: ARRAY[1..10] OF INT;
        END_VAR

        VAR
            vuota : BOOL := 1;
        END_VAR

        FOR i := 0 TO 10 DO
            IF col1[i] == 0 THEN
                vuota := 0;
            END_IF;
        END_FOR;
        RETURN vuota;
    END_FUNCTION

    FUNCTION scrivi_colonna : INT
        (* 
         * Copia un array su un'altro array
        **)
        VAR_INPUT
            colonna_vuota : ARRAY[1..10] OF INT;
            ricetta : ARRAY[1..10] OF INT;
        END_VAR

        FOR x := 0 TO 10 DO
            colonna_vuota[x] := ricetta[x];
        END_FOR;
        RETURN 1;
    END_FUNCTION

END_PROGRAM


PROGRAM _EXIT

END_PROGRAM
