//QUERY SALUD OCUPACIONAL
SELECT
    id_ctacte,
    nro_ctacte,
    id_personal,
    nombre(id_personal)              paciente,
    to_char(fecha_ini, 'DD/MM/YYYY') fecha_ini,
    to_char(fecha_fin, 'DD/MM/YYYY') fecha_fin,
    nombre(id_empresa)               empresa,
    id_empresa,
    id_compania,
    decode(tchk, '2', 'Preventivo', '1', 'Ocupacional',
           '-')                      tchk,
    observacion,
    decode(estado, '1', 'Activa', '2', 'Facturada',
           '0', 'Cerrada', '5', 'CI', '3',
           'Desactivada')            estado,
    lower(login(id_personal_user))   login
FROM
    cred_ctacte
WHERE
    id_tipo_ate IN ( '04', '9' )
    AND punto NOT IN ( '22' )
    AND punto IN ('53')
    AND substr(nro_ctacte, 1, 3) <> '999'
    AND TO_DATE(fecha_ini) BETWEEN TO_DATE('01/06/2024', 'DD/MM/YYYY') AND TO_DATE('30/06/2024', 'DD/MM/YYYY')
ORDER BY
    paciente ASC;
