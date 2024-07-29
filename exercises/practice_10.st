(*
 * non revisonato
**)



PROGRAM _INIT

END_PROGRAM


PROGRAM _CYCLIC

    VAR
        start_button := "ingresso_1";
        stop_button := "ingresso_2";
        sensore_imbuto_alto := "ingresso_3";                 // Sensore parte alta dell'imbuto 
        sensore_imbuto_basso := "ingresso_4";                // Sensore parte bassa dell'imbuto

        "uscita_1" := cilindro_valvola_ingersso_imbuto;      // Per rempimento imbuto
        "uscita_2" := cilindro_valvola_uscita_imbuto;        // Per svutamento imbuto
        "uscita_2" := motore_nasto_trasportatore;
        "uscita_2" := forno_cottura;

    END_VAR

    IF start_button AND NOT stop_button THEN
        start_ciclo.sensore_imbuto_basso := sensore_imbuto_basso;
        start_ciclo.sensore_imbuto_basso := sensore_imbuto_basso;
        start_ciclo.cilindro_valvola_ingersso_imbuto := cilindro_valvola_uscita_imbuto;
        start_ciclo.cilindro_valvola_uscita_imbuto := cilindro_valvola_uscita_imbuto;
        start_ciclo.motore_nasto_trasportatore := motore_nasto_trasportatore;
        start_ciclo.forno_cottura := forno_cottura;
        start_ciclo();
    ELSIF stop_button AND NOT start_button THEN
        stop_ciclo.cilindro_valvola_ingersso_imbuto := cilindro_valvola_uscita_imbuto;
        stop_ciclo.cilindro_valvola_uscita_imbuto := cilindro_valvola_uscita_imbuto;
        stop_ciclo.motore_nasto_trasportatore := motore_nasto_trasportatore;
        stop_ciclo.forno_cottura := forno_cottura;
        stop_ciclo();
    END_IF;


    FUNCTION_BLOCK start_ciclo
        (*
         * Avvia il ciclo produttivo del forno
        **)
        VAR_INPUT
            sensore_imbuto_alto: BOOL;
            sensore_imbuto_basso: BOOL;

            cilindro_valvola_ingersso_imbuto: BOOL;
            cilindro_valvola_uscita_imbuto: BOOL;
            motore_nasto_trasportatore: BOOL;
            forno_cottura: BOOL;
        END_VAR
        VAR
            fase := 0;
            timer_nastro := 0;
            timer_forno := 0;
        END_VAR

        IF sistem_bit_1sec AND motore_nasto_trasportatore THEN
            timer_nastro := timer_nastro + 1;
        ELSIF sistem_bit_1sec AND forno_cottura THEN
            timer_forno := timer_forno + 1;
        END_IF;

        CASE fase OF
            0:
                (*
                 * Controllo riempimento/svuotamento imbuto
                 * 
                 * Entry point
                **)
                IF NOT sensore_imbuto_alto AND NOT sensore_imbuto_basso THEN
                    cilindro_valvola_uscita_imbuto := 0;
                    cilindro_valvola_ingersso_imbuto := 1;
                ELSIF sensore_imbuto_alto AND sensore_imbuto_basso THEN
                    cilindro_valvola_ingersso_imbuto := 0;
                    cilindro_valvola_uscita_imbuto := 1;
                    fase := 10;
                END_IF;

            10:
                (*
                 * Avvio e arresto nastro trasportatore per ingresso forno
                 *
                 * Entrata → fase 0 (riempimento/svuotamento imbuto)
                 * Uscita → fase 20 (forno cottura)
                **)
                IF NOT motore_nasto_trasportatore AND timer_nastro == 0 THEN
                    motore_nasto_trasportatore := 1;
                ELSIF motore_nasto_trasportatore AND timer_nastro == 15 THEN
                    motore_nasto_trasportatore := 0;
                    timer_nastro := 0;
                    fase := 20;
                END_IF;

            20:
                (*
                 * Accensione e spegnimento forno cottura
                 *
                 * Entrata → fase 20 (nastro trasportatore per ingresso forno)
                 * Uscita → fase 30 (nastro trasportatore per uscita forno)
                **)
                IF NOT forno_cottura THEN
                    forno_cottura := 1;
                ELSIF forno_cottura AND timer_forno == 10 THEN
                    forno_cottura := 0;
                    timer_forno := 0;
                    fase := 30;
                END_IF;

            30:
                (*
                 * Avvio e arresto nastro trasportatore per uscita forno
                 *
                 * Entrata → fase 30 (forno cottura)
                 * Uscita → fase 0 (riempimento/svuotamento imbuto)
                **)
                IF NOT motore_nasto_trasportatore THEN
                    motore_nasto_trasportatore := 1;
                ELSIF motore_nasto_trasportatore AND timer_nastro == 10 THEN
                    motore_nasto_trasportatore := 0;
                    timer_nastro := 0;
                    fase := 0;
                END_IF;

        END_CASE;

    END_FUNCTION_BLOCK


    FUNCTION_BLOCK stop_ciclo
        (*
         * Ferma il ciclo produttivo del forno
        **)
        VAR_INPUT
            cilindro_valvola_ingersso_imbuto: BOOL;
            cilindro_valvola_uscita_imbuto: BOOL;
            motore_nasto_trasportatore: BOOL;
            forno_cottura: BOOL;
        END_VAR

            cilindro_valvola_ingersso_imbuto := 0;
            cilindro_valvola_uscita_imbuto := 0;
            motore_nasto_trasportatore =: 0;
            forno_cottura := 0;

    END_FUNCTION_BLOCK

END_PROGRAM


PROGRAM _EXIT

END_PROGRAM