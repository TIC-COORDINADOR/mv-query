--TOTAL
SELECT A.ID_REPOR ID_INFORME, 
                  nvl (C.ID_MOV_VNT, '0' )ID_MOV_VNT, 
                  NOMBRE (A.ID_PACIENTE) PACIENTE, 
                  TO_CHAR (A.FECHA, 'DD/MM/YYYY') || ' - ' || TO_CHAR (A.HORA_, 'hh:mi am') FECHA_OPE, 
                  NVL (NOMBRE (A.CIRUJANO), '--') CIRUJANO, 
                  NVL(C.GLOSA, 'Proceso Antiguo')    PROCEDIMIENTO, 
                  NVL(C.ID_ARTICULO, 'Proceso Antiguo') ID_SERVICIO, 
                  NVL (ID_NIVEL(C.ID_ARTICULO), '0' ) ID_NIVEL, 
                       '0' BANDERA 
            FROM CIRU_REPOPE A, VENT_REGDET C 
            WHERE A.ID_REPOR = C.ID_MOVART(+) 
                  AND TO_CHAR (A.FECHA, 'YYYY-MM') = '2024-05' --MES DINAMICO
            UNION 
            SELECT A.ID_INFORME ID_INFORME, 
                nvl (C.ID_MOV_VNT, '00' )ID_MOV_VNT, 
                NOMBRE (A.ID_PACIENTE) PACIENTE, 
                TO_CHAR (A.FECHA_OPERACION, 'DD/MM/YYYY') || ' - ' || TO_CHAR (A.HORA_OPERACION, 'hh:mi am') FECHA_OPE, 
                NVL (NOMBRE (A.ID_MEDICO), '--') CIRUJANO, 
                NVL(C.GLOSA, 'Proceso Antiguo')    PROCEDIMIENTO, 
                NVL(C.ID_ARTICULO, '00') ID_SERVICIO, 
                NVL (ID_NIVEL(C.ID_ARTICULO), '00' ) ID_NIVEL, 
                     '0' BANDERA 
            FROM CIRU_ENDOSCOPIA A, VENT_REGDET C 
            WHERE     A.ID_INFORME = C.ID_MOVART(+) 
                AND TO_CHAR (A.FECHA_OPERACION, 'YYYY-MM') = '2024-05'  --MES DINAMICO
            UNION 
            SELECT A.ID_REPORTE ID_INFORME, 
                nvl (C.ID_MOV_VNT, '000' )ID_MOV_VNT, 
                NOMBRE (A.ID_PACIENTE) PACIENTE, 
                TO_CHAR (A.FECHA_OPERACION, 'DD/MM/YYYY') || ' - ' || TO_CHAR (A.HORA_OPERACION, 'hh:mi am') FECHA_OPE, 
                NVL (NOMBRE (A.ID_MEDICO), '--') CIRUJANO, 
                NVL(C.GLOSA, 'Proceso Antiguo')    PROCEDIMIENTO, 
                NVL(C.ID_ARTICULO, '000') ID_SERVICIO, 
                NVL (ID_NIVEL(C.ID_ARTICULO), '000' ) ID_NIVEL, 
                     '0' BANDERA 
            FROM CIRUGIA_PROCEDIMIENTO_MENOR A, VENT_REGDET C 
            WHERE     A.ID_REPORTE = C.ID_MOVART(+) 
                AND TO_CHAR (A.FECHA_OPERACION, 'YYYY-MM') = '2024-05' ; --MES DINAMICO
