(*
 * non revisionato
**)



PROGRAM _INIT

END_PROGRAM



PROGRAM _CYCLIC

    VAR
        A := "ingresso_1";
        B := "ingresso_2";
        reset := "ingresso_3";

        conteggio : INT := 0;

        "uscita_1" := led[0];
        "uscita_2" := led[1];
        "uscita_3" := led[2];
        "uscita_4" := led[3];
        "uscita_5" := led[4];
        "uscita_6" := led[5];
        "uscita_7" := led[6];
        "uscita_8" := led[7];
        "uscita_9" := led[8];
        "uscita_10" := led[9];
    END_VAR


    contatore.A := A;
    contatore.B := B;
    contatore.conteggio := conteggio;
    contatore();

    IF contatore.conteggio MOD 100 THEN
        FOR x := 0 TO conteggio BY 100 DO
            led[x] := 0;
        END_FOR;
    END_IF;

    IF reset OR contatore.conteggio MOD 2000 == 0 THEN
        FOR x := 0 TO 9 DO
           led[x] := 0;
        END_FOR;
    END_IF;


    FUNCTION_BLOCK contatore
        VAR_INPUT
            A : BOOL;
            B : BOOL;
            conteggio : INT;
        END_VAR
        VAR
            orario: BOOL := 0;
        END_VAR

        CASE fase OF
        0:
            IF NOT A AND NOT B THEN
                fase := 10;
            END_IF;
        10:
            IF A XOR B THEN
                IF A AND NOT B THEN
                    orario := 1;
                ELSIF NOT A AND B THEN
                    orario := 0;
                END_IF;
                fase := 20;
            END_IF;
        20:
            IF A AND B THEN
                fase := 30;
            END_IF;
        30:
            IF A XOR B THEN
                fase := 40;
            END_IF;
        40:
            IF orario THEN
                conteggio := conteggio + 1;
            ELSE
                conteggio := conteggio - 1;
            END_IF;
            fase := 0;

    END_FUNCTION_BLOCK


END_PROGRAM



PROGRAM _EXIT

END_PROGRAM
