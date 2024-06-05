SELECT DISTINCT
    to_char(c.fecha_cre, 'dd/mm/yyyy') AS fecha,
    to_char(c.fecha_cre, 'hh24:mi:ss') AS hora,
    nvl(to_char(a.hora, 'hh24:mi:ss'),
        '-')                           AS hora_triaje,
    c.id_pae,
    nhc(c.id_personal)                 AS nhc,
    nombre(c.id_personal)              AS paciente,
    sexo(c.id_personal)                AS sexo,
    fecha_nacimiento(c.id_personal)    fecha_nacimiento,
    edad(c.id_personal)                AS edad,
    telefono(c.id_personal)            AS telefono,
    nombre(c.id_compania)              AS compania,
    substr(direccion(c.id_personal),
           0,
           60)                         AS direccion,
    a.relato                           AS motivo_consulta,
    to_char((
        SELECT
            hora_primera_atencion
        FROM
            (
                SELECT
                    bz.id_pae, az.fecha hora_primera_atencion
                FROM
                         mov_det_temp_emer az
                    INNER JOIN mov_temp_emer bz ON(az.id_mov = bz.id_mov)
                WHERE
                    az.pagado IS NULL
                UNION
                SELECT
                    ax.id_pae, ax.fecha hora_primera_atencion
                FROM
                         vent_registro ax
                    INNER JOIN vent_regdet bx ON(ax.id_mov_vnt = bx.id_mov_vnt)
                WHERE
                    NOT EXISTS(
                        SELECT
                            id_articulo
                        FROM
                            articulos xx
                        WHERE
                                xx.id_almart = bx.id_almart
                            AND id_almacen = '1'
                    )
                        AND bx.estado = 'V'
                        AND id_personal_pedido IS NOT NULL
                UNION
                SELECT
                    c.id_pae, c.hora_inicio_atencion hora_primera_atencion
                FROM
                    dual
            )
        WHERE
            id_pae = c.id_pae
        ORDER BY
            hora_primera_atencion ASC, id_pae
        FETCH FIRST 1 ROW ONLY
    ),
            'hh24:mi:ss')              AS hora_atencion,
    round(60 * 24 *((
        SELECT
            hora_primera_atencion
        FROM
            (
                SELECT
                    bz.id_pae, az.fecha hora_primera_atencion
                FROM
                         mov_det_temp_emer az
                    INNER JOIN mov_temp_emer bz ON(az.id_mov = bz.id_mov)
                WHERE
                    az.pagado IS NULL
                UNION
                SELECT
                    ax.id_pae, ax.fecha hora_primera_atencion
                FROM
                         vent_registro ax
                    INNER JOIN vent_regdet bx ON(ax.id_mov_vnt = bx.id_mov_vnt)
                WHERE
                    NOT EXISTS(
                        SELECT
                            id_articulo
                        FROM
                            articulos xx
                        WHERE
                                xx.id_almart = bx.id_almart
                            AND id_almacen = '1'
                    )
                        AND bx.estado = 'V'
                        AND id_personal_pedido IS NOT NULL
                UNION
                SELECT
                    c.id_pae, c.hora_inicio_atencion hora_primera_atencion
                FROM
                    dual
            )
        WHERE
            id_pae = c.id_pae
        ORDER BY
            hora_primera_atencion ASC, id_pae
        FETCH FIRST 1 ROW ONLY
    ) - c.fecha_cre),
          2)                           AS tiempo_de_espera_decimal,
    nvl(d.nombre, '-')                 AS nombre,
    nvl(to_char(c.fecha_fmed, 'dd/mm/yyyy'),
        '-')                           fecha_fin_medico,
    nvl(to_char(c.fecha_fmed, 'hh24:mi:ss'),
        '-')                           hora_fin_medico,
    nombre(c.id_medico_atiende)        AS medico,
    nombre(c.id_medico_atiende2)       AS medico2,
    nombre(c.id_medico_atiende3)       AS medico3,
    nombre(c.id_med_fin)               AS medico_alta,
    (
        SELECT
            medicos_interconsultas_pae(c.id_pae)
        FROM
            dual
    )                                  medicos_interconsultas,
    c.id_medico_atiende                AS firma,
    nvl(nombre(c.id_enf_fin),
        '-')                           AS enfermera,
    b.id_prioridad_emer,
    b.id_regdia,
    c.id_pae                           AS id
FROM
    hc_ficha           a,
    arch_regist_diario b,
    pac_emer           c,
    adm_destinos       d,
    vent_registro      e
WHERE
        a.id_regate = b.id_regdia
    AND b.id_pae = c.id_pae
    AND b.id_pae = e.id_pae (+)
    AND b.destino = d.id (+)
    AND to_char(b.fecha, 'yyyymm') >= '202405'
    AND a.hora IS NOT NULL
    AND c.estado NOT IN ( 'A' )
ORDER BY
    fecha ASC
