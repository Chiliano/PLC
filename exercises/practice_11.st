(*
 * non revisionato
**)



PROGRAM _INIT

END_PROGRAM



PROGRAM _CYCLIC

    VAR
        rele[0] := "ingresso_1"
        rele[1] := "ingresso_2"
        rele[2] := "ingresso_3"
        rele[3] := "ingresso_4"
        rele[4] := "ingresso_5"
        rele[6] := "ingresso_6"
        rele[7] := "ingresso_7"
        rele[8] := "ingresso_8"
        rele[9] := "ingresso_9"
        rele[10] := "ingresso_10"

        "uscita_1" := motori[0];
        "uscita_2" := motori[1];
        "uscita_3" := motori[2];
        "uscita_4" := motori[3];
        "uscita_5" := motori[4];
        "uscita_6" := motori[5];
        "uscita_7" := motori[6];
        "uscita_8" := motori[7];
        "uscita_9" := motori[8];
        "uscita_10" := motori[9];
    END_VAR

    FOR x := 0 TO 9 BY 1 DO
        IF rele[0] THEN
            motori[x] := 0;
        ELSE
            motori[x] := 1;
        END_IF;
    END_FOR;

END_PROGRAM



PROGRAM _EXIT

END_PROGRAM
