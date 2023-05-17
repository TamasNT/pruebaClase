-- 1
SELECT NombreCliente, LimiteCredito
FROM Clientes
WHERE LimiteCredito = (
  SELECT MAX(LimiteCredito)
  FROM Clientes
)

-- 2
SELECT NombreCliente, 
(SELECT CONCAT(Nombre, ' ', Apellido1, ' ', Apellido2) 
FROM Empleados 
WHERE Empleados.CodigoEmpleado = Clientes.CodigoEmpleadoRepVentas) as Representante 
FROM clientes;

-- 3
SELECT (SELECT CONCAT(e.Nombre, ' ', e.Apellido1) FROM Empleados e WHERE e.CodigoEmpleado = c.CodigoEmpleadoRepVentas) AS Representante, c.NombreCliente
FROM Clientes c
WHERE c.CodigoCliente NOT IN (SELECT DISTINCT p.CodigoCliente FROM Pagos p);

-- 4
SELECT LineaDireccion1 AS 'Sede de Oficina', Ciudad
FROM Oficinas
WHERE CodigoOficina IN (
    SELECT CodigoOficina
    FROM Empleados
    WHERE CodigoEmpleado IN (
        SELECT CodigoEmpleadoRepVentas
        FROM Clientes
        WHERE Ciudad = 'FUENLABRADA'
    )
);

-- 5
SELECT SUM(cantidad*precioUnidad) AS cuantia_pedido, codigoPedido,
(SELECT fechaPedido FROM pedidos WHERE codigoPedido IN(
SELECT codigoPedido FROM detallepedidos WHERE codigoPedido= (
SELECT codigoPedido FROM detallepedidos
GROUP BY codigoPedido HAVING SUM(cantidad*precioUnidad)
ORDER BY SUM(cantidad*precioUnidad) DESC LIMIT 1
)
)
) AS fechaPedido,
(SELECT nombrecliente FROM clientes WHERE codigoCliente IN (
SELECT codigoCliente FROM pedidos WHERE codigoPedido IN(
SELECT codigoPedido FROM detallepedidos WHERE codigoPedido= (
SELECT codigoPedido FROM detallepedidos
GROUP BY codigoPedido HAVING SUM(cantidad*precioUnidad)
ORDER BY SUM(cantidad*precioUnidad) DESC LIMIT 1)
)
)
) AS nombreCliente
FROM detallepedidos WHERE codigoPedido=(SELECT codigoPedido FROM detallepedidos
GROUP BY codigoPedido HAVING SUM(cantidad*precioUnidad)
ORDER BY SUM(cantidad*precioUnidad) DESC LIMIT 1
);

-- 6
SELECT Nombre, Apellido1, Apellido2, Email
FROM Empleados
WHERE CodigoEmpleado IN (
  SELECT CodigoEmpleado
  FROM Empleados
  WHERE CodigoJefe = (
    SELECT CodigoEmpleado
    FROM Empleados
    WHERE Nombre = 'Alberto' AND Apellido1 = 'Soria'
  )
);


-- 7
SELECT COUNT(*) AS Clientes
FROM Clientes
WHERE CodigoCliente ;
     

-- 8
SELECT e.CodigoEmpleado, 
       (SELECT COUNT(*) FROM Clientes c WHERE c.CodigoEmpleadoRepVentas = e.CodigoEmpleado) as NumeroClientes
FROM Empleados e
WHERE e.Puesto = 'Representante Ventas'
HAVING NumeroClientes > 0;


-- 9
SELECT Nombre, PrecioVenta
FROM Productos
WHERE PrecioVenta = (
    SELECT MAX(PrecioVenta)
    FROM Productos
);


-- 10 error
SELECT Productos.Nombre, SUM(DetallePedidos.Cantidad) AS Cantidad
FROM DetallePedidos
JOIN Productos ON DetallePedidos.CodigoProducto = Productos.CodigoProducto
GROUP BY DetallePedidos.CodigoProducto
ORDER BY Cantidad DESC
LIMIT 1;


-- 11
SELECT 
  NombreCliente,
  (SELECT CONCAT(Nombre, ' ', Apellido1) FROM Empleados WHERE CodigoEmpleado = Clientes.CodigoEmpleadoRepVentas) AS Representante,
  (SELECT Ciudad FROM Oficinas WHERE CodigoOficina = (SELECT CodigoOficina FROM Empleados WHERE CodigoEmpleado = Clientes.CodigoEmpleadoRepVentas)) AS Ciudad
FROM clientes
ORDER BY Ciudad ASC;
