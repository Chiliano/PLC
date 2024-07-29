(*
 * non revisionato
**)



PROGRAM _INIT

END_PROGRAM



PROGRAM _CYCLIC

    VAR
        pulsante := "ingresso_1";
        "uscita_1" := led[0]
        "uscita_2" := led[1]
        "uscita_3" := led[2]
        "uscita_4" := led[3]
        "uscita_5" := led[4]
        "uscita_6" := led[5]
        "uscita_7" := led[6]
        "uscita_8" := led[7]
        "uscita_9" := led[8]
        "uscita_10" := led[9]
        fase : INT := 0;
    END_VAR

    IF pulsante THEN
        CASE fase OF
            0:
                led[fase] := 1;
                fase := fase + 1;
            1:
                led[fase] := 1;
                fase := fase + 1;
            2:
                led[fase] := 1;
                fase := fase + 1;
            3:
                led[fase] := 1;
                fase := fase + 1;
            4:
                led[fase] := 1;
                fase := fase + 1;
            5:
                led[fase] := 1;
                fase := fase + 1;
            6:
                led[fase] := 1;
                fase := fase + 1;
            7:
                led[fase] := 1;
                fase := fase + 1;
            8:
                led[fase] := 1;
                fase := fase + 1;
            9:
                led[fase] := 1;
                fase := fase + 1;
            10:
                FOR x := 0 TO 9 DO
                    led[x] := 0;
                END_FOR;
                fase := 0;

        END_CASE;
        

END_PROGRAM



PROGRAM _EXIT

END_PROGRAM
