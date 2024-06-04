SELECT count(*)
FROM 
    hosp_int hi join 
    cred_ctacte cuenta on hi.id_ctacte = cuenta.id_ctacte JOIN 
    hosp_int_hab hib on (hib.id_int = hi.id_int and hib.estado = '1')
WHERE 
    hi.estado in ('1', '2', 'P') and
    ('202405' BETWEEN to_char(hi.fecha, 'YYYYMM') and to_char(hi.fecha_alta, 'YYYYMM')) or 
    (to_char(hi.fecha, 'YYYYMM') <= '202405' and hi.fecha_alta is null);
