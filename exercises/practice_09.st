(*
 * es 09
 * revisionato.
**)



PROGRAM _INIT
END_PROGRAM


PROGRAM _CYCLIC

    VAR

        (* 
         *  >>>>>>>>>>>>>> !-NOTA-BENE-! <<<<<<<<<<<<<<<
         *
         *  I PIANI SONO NOMINATI COME 1°, 2° E 3.
         *  IL PIANO TERRA CORRISPONDE AL 1° PIANO.
         *
         *  >>>>>>>>>>>>>> !-NOTA-BENE-! <<<<<<<<<<<<<<<
        **)



        // Contesto relativo al 1 piano dell'edificio
        "uscita_1" := led_piano_1;                       // LED di segnalazione movimento cabina (1 == movimento)
        pulsante_chiamata_piano_1 := "ingresso_1";       // Pulsante di chiamata della cabina
        sensore_arrivo_piano_1 := "ingresso_2";          // Sensore di arrivo della cabina (1 == cabina presente)

        // Contesto relativo al 2 piano dell'edificio
        "uscita_2" := led_piano_2;                       
        pulsante_chiamata_piano_2 := "ingresso_3";                    
        sensore_arrivo_piano_2 := "ingresso_4";                      

        // Contesto relativo al 3 piano dell'edificio
        "uscita_3" := led_piano_3;
        pulsante_chiamata_piano_3 := "ingresso_5";
        sensore_arrivo_piano_3 := "ingresso_6";

        // Contesto interno alla cabina dell'ascensore
        pulsante_cabina_piano_1 := "ingresso_7";           //
        pulsante_cabina_piano_2 := "ingresso_8";           // Pulsante destinazione cabina
        pulsante_cabina_piano_3 := "ingresso_9";           //
        sensore_chiusura_porte := "ingresso_10";           // Sensore chiusura porte (1 == chiuse)
        pulsante_allarme := "ingresso_11";                 // Pulsante di emergenza, attiva un allarme di 20s
        allarme_cabina := "uscita_8";

        // Contesto motori cabina
        "uscita_4" := motore_up;
        "uscita_5" := motore_down;

        // Contesto motori porte
        "uscita_6" := motore_porte_open;
        "uscita_7" := motore_porte_close;

        timer: INT := 0;
        timer_porta: INT := 0;

    END_VAR


    (*
     * Inizializzazione variabili funzione `movimento_cabina`
    **)
    // Led movimento cabina
    movimento_cabina.led_piano_1 := led_piano_1; 
    movimento_cabina.led_piano_2 := led_piano_2; 
    movimento_cabina.led_piano_3 := led_piano_3; 
    // Sensori presenza cabina
    movimento_cabina.sensore_arrivo_piano_1 := sensore_arrivo_piano_1; 
    movimento_cabina.sensore_arrivo_piano_2 := sensore_arrivo_piano_2; 
    movimento_cabina.sensore_arrivo_piano_3 := sensore_arrivo_piano_3; 
     // Porte cabina
    movimento_cabina.sensore_chiusura_porte := sensore_chiusura_porte; 
    movimento_cabina.motore_porte_open := motore_porte_open; 
    // Motori cabina
    movimento_cabina.motore_up := motore_up; 
    movimento_cabina.motore_down := motore_down; 


    (*
     * Chiamata della cabina da uno dei piani presenti.
    **)
    IF pulsante_chiamata_piano_1 THEN
        movimento_cabina.chiamta_esterna := TRUE;
        movimento_cabina.pulsante_chiamata := pulsante_chiamata_piano_1; 
        movimento_cabina.piano_chiamata := 1;
        movimento_cabina();
    ELSIF pulsante_chiamata_piano_2 THEN
        movimento_cabina.chiamta_esterna := TRUE;
        movimento_cabina.pulsante_chiamata := pulsante_chiamata_piano_2; 
        movimento_cabina.piano_chiamata := 2;
        movimento_cabina();
    ELSIF pulsante_chiamata_piano_3 THEN
        movimento_cabina.chiamta_esterna := TRUE;
        movimento_cabina.pulsante_chiamata := pulsante_chiamata_piano_3; 
        movimento_cabina.piano_chiamata := 3;
        movimento_cabina();
    END_IF;

    (*
     * Risposta della cabina da pulsante interno.
    **)
    IF pulsante_cabina_piano_1 AND NOT sensore_arrivo_piano_1 THEN
        movimento_cabina.chiamta_esterna := FALSE;
        movimento_cabina.pulsante_chiamata := pulsante_cabina_piano_1; 
        movimento_cabina.piano_chiamata := 1;
        movimento_cabina();
    ELSIF pulsante_cabina_piano_2 AND NOT sensore_arrivo_piano_2 THEN
        movimento_cabina.chiamta_esterna := FALSE;
        movimento_cabina.pulsante_chiamata := pulsante_cabina_piano_2; 
        movimento_cabina.piano_chiamata := 2;
        movimento_cabina();
    ELSIF pulsante_cabina_piano_3 AND NOT sensore_arrivo_piano_3 THEN
        movimento_cabina.chiamta_esterna := FALSE;
        movimento_cabina.pulsante_chiamata := pulsante_cabina_piano_3; 
        movimento_cabina.piano_chiamata := 3;
        movimento_cabina();
    END_IF;

    IF pulsante_allarme THEN
        allarme_cabina := 1;
        timer := 0;
    END_IF;

    IF sistem_bit_1sec THEN
        timer := timer + 1;
    END_IF;

    IF sistem_bit_1sec AND NOT sensore_chiusura_porte THEN
        timer_porta := timer_porta + 1;
    END_IF;

    IF timer == 20 AND allarme_cabina THEN
        allarme_cabina := 0;
        timer := 0;
    END_IF;

    // Chiusura porta ascensore automatica dopo 40 sec
    IF timer_porta > 40 AND NOT sensore_chiusura_porte AND NOT motore_porte_close THEN
        timer_porta := 0;
        motore_porte_close := 1;
    ELSIF sensore_chiusura_porte AND motore_porte_close THEN
        motore_porte_close := 0;
    END_IF;
 THEN
                        
                    

    FUNCTION_BLOCK movimento_cabina
    (*
     * Muove la cabina sui piani in base agli input dei pulsanti presenti in ogni piano.
    **)

        VAR_INPUT
            piano_chiamata: INT;
            chiamta_esterna: BOOL;
            pulsante_chiamata: BOOL;            // Pulsante di chiamata della cabina
            led_piano_1: BOOL;
            led_piano_2: BOOL;
            led_piano_3: BOOL;

            // Sensori presenza cabina
            sensore_arrivo_piano_1: BOOL;
            sensore_arrivo_piano_2: BOOL;
            sensore_arrivo_piano_3: BOOL;

            // Porte cabina
            sensore_chiusura_porte: BOOL;
            motore_porte_open: BOOL;

            // Motori cabina
            motore_up: BOOL;
            motore_down: BOOL;
        END_VAR

        VAR
            fase: INT := 0;                     // Variabile locale per i casi del CASE OF
        END_VAR



        IF pulsante_chiamata_piano AND NOT led_piano_1 AND NOT led_piano_2 AND NOT led_piano_3 THEN
            // Segnalo cabina in uso su tutti i piani
            led_piano_1 := TRUE;
            led_piano_2 := TRUE;
            led_piano_3 := TRUE;


            CASE fase OF

                0:
                    (* 
                     * Localizzazione della cabina fra i piani e reindirizzamento verso il piano di chiamata.
                     *
                     * Entrate → Case entry point
                     *
                     * Uscite  → Spostamenti cabina (30, 40, 50)
                     *           Apertura porte (10)
                    **)
                    IF sensore_arrivo_piano_1 AND NOT sensore_arrivo_piano_2 AND NOT sensore_arrivo_piano_3 THEN
                        // Chiamata da piano
                        IF piano_chiamata == 1 AND chiamta_esterna THEN
                            fase := 10;
                        ELSIF piano_chiamata == 2 AND chiamta_esterna THEN
                            fase := 50;
                        ELSIF piano_chiamata == 3 AND chiamta_esterna THEN
                            fase := 40;
                        // Chiamata da cabina
                        ELSIF piano_chiamata == 1 AND NOT chiamta_esterna THEN
                            fase := 0;
                        ELSIF piano_chiamata == 2 AND NOT chiamta_esterna THEN
                            fase := 20;
                        ELSIF piano_chiamata == 3 AND NOT chiamta_esterna THEN
                            fase := 20;
                        END_IF;
                    ELSIF NOT sensore_arrivo_piano_1 AND sensore_arrivo_piano_2 AND NOT sensore_arrivo_piano_3 THEN
                        // Chiamata da piano
                        IF piano_chiamata == 1 AND chiamta_esterna THEN
                            fase := 30;
                        ELSIF piano_chiamata == 2 AND chiamta_esterna THEN
                            fase := 10;
                        ELSIF piano_chiamata == 3 AND chiamta_esterna THEN
                            fase := 40;
                        // Chiamata da cabina
                        ELSIF piano_chiamata == 1 AND NOT chiamta_esterna THEN
                            fase := 0;
                        ELSIF piano_chiamata == 2 AND NOT chiamta_esterna THEN
                            fase := 20;
                        ELSIF piano_chiamata == 3 AND NOT chiamta_esterna THEN
                            fase := 20;
                        END_IF;
                    ELSIF NOT sensore_arrivo_piano_1 AND NOT sensore_arrivo_piano_2 AND sensore_arrivo_piano_3 THEN
                        // Chiamata da piano
                        IF piano_chiamata == 1 AND chiamta_esterna THEN
                            fase := 30;
                        ELSIF piano_chiamata == 2 AND chiamta_esterna THEN
                            fase := 50;
                        ELSIF piano_chiamata == 3 AND chiamta_esterna THEN
                            fase := 10;
                        // Chiamata da cabina
                        ELSIF piano_chiamata == 1 AND NOT chiamta_esterna THEN
                            fase := 0;
                        ELSIF piano_chiamata == 2 AND NOT chiamta_esterna THEN
                            fase := 20;
                        ELSIF piano_chiamata == 3 AND NOT chiamta_esterna THEN
                            fase := 20;
                        END_IF;
                    END_IF;

                10:
                    (*
                     * Apertura porte cabina.
                     *
                     * Entrata → Localizzazione e reindirizzamento (0)
                    **)
                    IF sensore_chiusura_porte AND NOT motore_porte_open THEN
                        motore_porte_open := 1;
                    ELSIF NOT sensore_chiusura_porte AND motore_porte_open THEN
                        motore_porte_open := 0;
                    END_IF;
                    fase := 0;

                20:
                    (*
                     * Chiusura porte cabina.
                     *
                     * Entrata → Localizzazione e reindirizzamento (0)
                    **)
                    IF NOT sensore_chiusura_porte AND NOT motore_porte_close THEN
                        motore_porte_close := 1;
                    ELSIF sensore_chiusura_porte AND motore_porte_close THEN
                        motore_porte_close := 0;
                    END_IF;
                    fase := 0;
                    // In fase 0 il movimento viene poi gestito come una chiamata a piano ma pertendo a porte chiuse
                    chiamta_esterna := TRUE;

                30: 
                    (*
                     * Spostamento cabina verso il 1° piano.
                     *
                     * Entrata → Localizzazione e reindirizzamento (0)
                     * 
                     * Uscita → Apertura porte (10)
                    **)
                    IF NOT motore_up AND NOT motore_down AND sensore_chiusura_porte THEN
                        motore_down := 1;
                    ELSIF NOT motore_up AND motore_down AND sensore_arrivo_piano_1 THEN
                        motore_down := 0;
                        fase := 10;
                    ELSIF motore_up OR motore_down AND NOT sensore_chiusura_porte THEN
                        // ALLARME PORTA CABINA APERTA
                    END_IF;

                40:
                    (*
                     * Spostamento cabina verso il 3° piano.
                     *
                     * Entrata → Localizzazione e reindirizzamento (0)
                     * 
                     * Uscita → Apertura porte (10)
                    **)
                    IF NOT motore_up AND NOT motore_down AND sensore_chiusura_porte THEN
                        motore_up := 1;
                    ELSIF motore_up AND NOT motore_down AND sensore_arrivo_piano_3 THEN
                        motore_up := 0;
                        fase := 10;
                    ELSIF motore_up OR motore_down AND NOT sensore_chiusura_porte THEN
                        // ALLARME PORTA CABINA APERTA
                    END_IF;

                50: 
                    (* 
                     * Spostamento cabina verso il 2° piano. La cabina si sporterà a partire dal basso o dall'alto.
                     *
                     * Entrata → Localizzazione e reindirizzamento (0)
                     * 
                     * Uscita → Apertura porte (10)
                    **)
                    IF NOT motore_up AND NOT motore_down THEN
                        IF sensore_arrivo_piano_3 AND NOT sensore_arrivo_piano_1 AND NOT sensore_arrivo_piano_2 THEN
                            motore_down := 1;
                        ELSIF sensore_arrivo_piano_1 AND NOT sensore_arrivo_piano_2 AND NOT sensore_arrivo_piano_3 THEN
                            motore_up := 1;
                        END_IF;
                    ELSIF motore_down AND NOT motore_up THEN
                        IF sensore_arrivo_piano_2 THEN
                            motore_down := 0;
                            fase := 10;
                        END_IF;
                    ELSIF NOT motore_down AND motore_up THEN
                        IF sensore_arrivo_piano_2 THEN
                            motore_up := 0;
                            fase := 10;
                        END_IF;

            END_CASE;

        END_IF; 

    END_FUNCTION_BLOCK

END_PROGRAM


PROGRAM _EXIT
END_PROGRAM
