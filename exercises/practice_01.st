(*
    EXERCISE 01

    Author: Chiliano Arcarese
    Revised by IVAN
*)



PROGRAM _INIT

END_PROGRAM



PROGRAM _CYCLIC

    VAR
        ingresso_rele := "ingresso_1";
        "uscita_1" := uscita_motore;
    END_VAR

    IF ingresso_rele AND uscita_motore THEN
        uscita_motore := 0;
    END_IF;

END_PROGRAM



PROGRAM _EXIT

END_PROGRAM
