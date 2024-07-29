(*
 * non revisionato
**)



PROGRAM _INIT

END_PROGRAM



PROGRAM _CYCLIC

    VAR
        A := "ingresso_1";
        B := "ingresso_2";
        conteggio : INT := 0;
    END_VAR

    contatore.A := A;
    contatore.B := B;
    contatore.conteggio := conteggio;
    contatore();

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
