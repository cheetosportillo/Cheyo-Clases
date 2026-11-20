-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3307
-- Tiempo de generación: 20-11-2026 a las 00:41:16
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `sys_agua`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `afp`
--

CREATE TABLE `afp` (
  `id_afp` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `porcentaje` decimal(5,2) DEFAULT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `afp`
--

INSERT INTO `afp` (`id_afp`, `nombre`, `porcentaje`, `estado`) VALUES
(1, 'AFP Confía', 7.25, 1),
(2, 'AFP Crecer', 7.25, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `canton`
--

CREATE TABLE `canton` (
  `id_canton` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `canton`
--

INSERT INTO `canton` (`id_canton`, `nombre`, `estado`) VALUES
(1, 'CANTON VALLE NUEVO', 1),
(5, 'CASTON ISCANALES', 1),
(7, 'CANTON LA ESPERANZA', 1),
(8, 'CANTON EL ZOPE', 1),
(10, 'CANTON LOS INFIERNILLOS', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cargo`
--

CREATE TABLE `cargo` (
  `id_cargo` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cargo`
--

INSERT INTO `cargo` (`id_cargo`, `nombre`, `estado`) VALUES
(1, 'Administrador', 0),
(3, 'FONTANERO', 1),
(4, 'Atención al cliente', 1),
(8, 'LIMPIEZA', 1),
(9, 'CARGADOR', 1),
(10, 'GANADERO', 1),
(12, 'BOMBERO', 1),
(14, 'LECTOR', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `consumo`
--

CREATE TABLE `consumo` (
  `idconsumo` int(11) NOT NULL,
  `idmedidor` int(11) NOT NULL,
  `idempleado` int(11) NOT NULL,
  `fecha_lectura` date NOT NULL,
  `fecha_anterior` date DEFAULT NULL,
  `lectura_anterior` decimal(10,2) DEFAULT NULL,
  `lectura_actual` decimal(10,2) NOT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `aviso` text DEFAULT NULL,
  `mes` int(11) NOT NULL,
  `anio` int(11) NOT NULL,
  `estado` varchar(15) NOT NULL DEFAULT 'PENDIENTE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `consumo`
--

INSERT INTO `consumo` (`idconsumo`, `idmedidor`, `idempleado`, `fecha_lectura`, `fecha_anterior`, `lectura_anterior`, `lectura_actual`, `fecha_vencimiento`, `aviso`, `mes`, `anio`, `estado`) VALUES
(1, 3, 2, '2026-11-03', NULL, 12.50, 14.25, '2026-11-05', '', 9, 2026, 'PENDIENTE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contrato`
--

CREATE TABLE `contrato` (
  `idcontrato` int(11) NOT NULL,
  `ncontrato` text NOT NULL,
  `fecha` date NOT NULL,
  `monto` double NOT NULL,
  `prima` double NOT NULL,
  `idsocio` int(11) NOT NULL,
  `idempleado1` int(11) NOT NULL,
  `cargo1` text NOT NULL,
  `idempleado2` int(11) NOT NULL,
  `cargo2` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `contrato`
--

INSERT INTO `contrato` (`idcontrato`, `ncontrato`, `fecha`, `monto`, `prima`, `idsocio`, `idempleado1`, `cargo1`, `idempleado2`, `cargo2`) VALUES
(1, '1', '2026-11-12', 33.54, 0, 2, 3, 'PRESIDENTE ', 4, 'SECRETARIO'),
(2, '2', '2026-11-12', 35.21, 0, 4, 2, 'PRESIDENTE', 3, 'SECRETARIO');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado`
--

CREATE TABLE `empleado` (
  `idempleado` int(11) NOT NULL,
  `dui` varchar(20) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `apellido` varchar(150) NOT NULL,
  `telefono` varchar(30) NOT NULL,
  `num_isss` varchar(30) DEFAULT NULL,
  `nup` varchar(30) DEFAULT NULL,
  `sueldo` decimal(10,2) DEFAULT NULL,
  `fecha_ingreso` date DEFAULT NULL,
  `id_cargo` int(11) DEFAULT NULL,
  `id_afp` int(11) DEFAULT NULL,
  `id_renta` int(11) DEFAULT NULL,
  `id_canton` int(11) DEFAULT NULL,
  `id_estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleado`
--

INSERT INTO `empleado` (`idempleado`, `dui`, `nombre`, `apellido`, `telefono`, `num_isss`, `nup`, `sueldo`, `fecha_ingreso`, `id_cargo`, `id_afp`, `id_renta`, `id_canton`, `id_estado`) VALUES
(2, '65659815-4', 'YOSELYN NICOLEE', 'MONTANO', '1234-5678', '125483355511', '254589', 350.00, '2005-11-27', 12, 2, 1, 10, 1),
(3, '12545625-8', 'PERLA ROSMERY', 'PORTILLO LOPEZ', '5425-6585', '', '', 600.00, '2003-05-20', 1, 2, 1, 8, 1),
(4, '15469875-2', 'JOSE ', 'AYALA PEREZ', '4587-5226', '', '', 250.00, '1999-09-27', 14, 1, 1, 7, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empleado_ruta`
--

CREATE TABLE `empleado_ruta` (
  `idempleado_ruta` int(11) NOT NULL,
  `idempleado` int(11) NOT NULL,
  `idruta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empleado_ruta`
--

INSERT INTO `empleado_ruta` (`idempleado_ruta`, `idempleado`, `idruta`) VALUES
(1, 4, 9);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado_empleado`
--

CREATE TABLE `estado_empleado` (
  `id_estado` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estado_empleado`
--

INSERT INTO `estado_empleado` (`id_estado`, `nombre`, `estado`) VALUES
(1, 'Activo', 1),
(2, 'Inactivo', 1),
(3, 'Suspendido', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medidor`
--

CREATE TABLE `medidor` (
  `idmedidor` int(11) NOT NULL,
  `idcontrato` int(11) NOT NULL,
  `nmedidor` varchar(50) NOT NULL,
  `lectura_inicial` decimal(10,2) NOT NULL DEFAULT 0.00,
  `idcanton` int(11) NOT NULL,
  `idruta` int(11) NOT NULL,
  `direccion` text NOT NULL,
  `referencia` text NOT NULL,
  `estado` varchar(15) NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `medidor`
--

INSERT INTO `medidor` (`idmedidor`, `idcontrato`, `nmedidor`, `lectura_inicial`, `idcanton`, `idruta`, `direccion`, `referencia`, `estado`) VALUES
(3, 1, '1', 12.00, 7, 9, 'Vive por alla', 'Sebas', 'Activo');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `renta`
--

CREATE TABLE `renta` (
  `id_renta` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `renta`
--

INSERT INTO `renta` (`id_renta`, `nombre`, `estado`) VALUES
(1, 'Renta 2026', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ruta`
--

CREATE TABLE `ruta` (
  `idRuta` int(11) NOT NULL,
  `nombre` text NOT NULL,
  `descripcion` text NOT NULL,
  `version` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ruta`
--

INSERT INTO `ruta` (`idRuta`, `nombre`, `descripcion`, `version`) VALUES
(9, 'RUTA 110', 'SAN SALVADOR - SAN SEBASTINA\r\n', 0),
(10, 'RUTA 116', 'SAN SALVADOR - SAN VICENTE', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socio`
--

CREATE TABLE `socio` (
  `idsocio` int(11) NOT NULL,
  `dui` varchar(10) NOT NULL,
  `nombre` varchar(150) NOT NULL,
  `apellido` varchar(150) NOT NULL,
  `telefono` varchar(9) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `profesion` varchar(150) NOT NULL,
  `idcanton` int(11) NOT NULL,
  `nit` varchar(17) NOT NULL,
  `direccion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `socio`
--

INSERT INTO `socio` (`idsocio`, `dui`, `nombre`, `apellido`, `telefono`, `fecha_nacimiento`, `profesion`, `idcanton`, `nit`, `direccion`) VALUES
(2, '23256489-6', 'CAMILO ', 'HUEVARA PEREZ', '1254-7823', '1998-03-25', 'ABOGADO', 1, '1254-856858-563-2', 'VIVE DONDE NO LLEGA LA LUZ DEL SOL'),
(3, '25484125-4', 'ESTEFANO URRUTIA', 'SANCHEZ', '5885-6852', '1997-07-09', 'CONTADOR', 5, '5554-855845-266-2', 'VIVE POR ALLA DONDE ESTA LA MOLIENDA'),
(4, '12345678-9', 'RAMON', 'VILLANUEVA', '5458-8524', '1998-07-02', 'CURANDERO', 10, '5462-458752-123-2', 'VIVE EN LA VENCIDAD DEL CHAVO DEL 8');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarifa`
--

CREATE TABLE `tarifa` (
  `id_tarifa` int(11) NOT NULL,
  `desde` decimal(10,2) NOT NULL,
  `hasta` decimal(10,2) NOT NULL,
  `tipo` enum('FIJO','POR_METRO') NOT NULL DEFAULT 'FIJO',
  `precio` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tarifa`
--

INSERT INTO `tarifa` (`id_tarifa`, `desde`, `hasta`, `tipo`, `precio`) VALUES
(1, 0.00, 10.00, 'FIJO', 3.00),
(2, 11.00, 20.00, 'POR_METRO', 0.50),
(3, 21.00, 35.00, 'POR_METRO', 0.75),
(4, 36.00, 999.00, 'POR_METRO', 1.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tiraje`
--

CREATE TABLE `tiraje` (
  `idtiraje` int(10) UNSIGNED NOT NULL,
  `prefijo` smallint(5) UNSIGNED NOT NULL,
  `ultimo` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `estado` enum('Activo','Inactivo') NOT NULL DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tiraje`
--

INSERT INTO `tiraje` (`idtiraje`, `prefijo`, `ultimo`, `estado`) VALUES
(1, 2026, 0, 'Inactivo'),
(3, 2027, 0, 'Activo');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `afp`
--
ALTER TABLE `afp`
  ADD PRIMARY KEY (`id_afp`);

--
-- Indices de la tabla `canton`
--
ALTER TABLE `canton`
  ADD PRIMARY KEY (`id_canton`);

--
-- Indices de la tabla `cargo`
--
ALTER TABLE `cargo`
  ADD PRIMARY KEY (`id_cargo`);

--
-- Indices de la tabla `consumo`
--
ALTER TABLE `consumo`
  ADD PRIMARY KEY (`idconsumo`),
  ADD UNIQUE KEY `idmedidor_mes_anio` (`idmedidor`,`mes`,`anio`),
  ADD KEY `idmedidor` (`idmedidor`),
  ADD KEY `idempleado` (`idempleado`);

--
-- Indices de la tabla `contrato`
--
ALTER TABLE `contrato`
  ADD PRIMARY KEY (`idcontrato`),
  ADD KEY `idsocio` (`idsocio`),
  ADD KEY `idempleado1` (`idempleado1`);

--
-- Indices de la tabla `empleado`
--
ALTER TABLE `empleado`
  ADD PRIMARY KEY (`idempleado`),
  ADD UNIQUE KEY `dui_unico` (`dui`);

--
-- Indices de la tabla `empleado_ruta`
--
ALTER TABLE `empleado_ruta`
  ADD PRIMARY KEY (`idempleado_ruta`),
  ADD UNIQUE KEY `idempleado_2` (`idempleado`,`idruta`),
  ADD UNIQUE KEY `idempleado_3` (`idempleado`,`idruta`),
  ADD KEY `idempleado` (`idempleado`),
  ADD KEY `idruta` (`idruta`);

--
-- Indices de la tabla `estado_empleado`
--
ALTER TABLE `estado_empleado`
  ADD PRIMARY KEY (`id_estado`);

--
-- Indices de la tabla `medidor`
--
ALTER TABLE `medidor`
  ADD PRIMARY KEY (`idmedidor`),
  ADD KEY `idcontrato` (`idcontrato`),
  ADD KEY `idcanton` (`idcanton`),
  ADD KEY `idruta` (`idruta`);

--
-- Indices de la tabla `renta`
--
ALTER TABLE `renta`
  ADD PRIMARY KEY (`id_renta`);

--
-- Indices de la tabla `ruta`
--
ALTER TABLE `ruta`
  ADD PRIMARY KEY (`idRuta`);

--
-- Indices de la tabla `socio`
--
ALTER TABLE `socio`
  ADD PRIMARY KEY (`idsocio`),
  ADD UNIQUE KEY `dui_unico` (`dui`),
  ADD KEY `idx_socio_idcanton` (`idcanton`);

--
-- Indices de la tabla `tarifa`
--
ALTER TABLE `tarifa`
  ADD PRIMARY KEY (`id_tarifa`);

--
-- Indices de la tabla `tiraje`
--
ALTER TABLE `tiraje`
  ADD PRIMARY KEY (`idtiraje`),
  ADD UNIQUE KEY `uq_tiraje_prefijo` (`prefijo`),
  ADD KEY `idx_tiraje_estado` (`estado`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `afp`
--
ALTER TABLE `afp`
  MODIFY `id_afp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `canton`
--
ALTER TABLE `canton`
  MODIFY `id_canton` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `cargo`
--
ALTER TABLE `cargo`
  MODIFY `id_cargo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `consumo`
--
ALTER TABLE `consumo`
  MODIFY `idconsumo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `contrato`
--
ALTER TABLE `contrato`
  MODIFY `idcontrato` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `empleado`
--
ALTER TABLE `empleado`
  MODIFY `idempleado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `empleado_ruta`
--
ALTER TABLE `empleado_ruta`
  MODIFY `idempleado_ruta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `estado_empleado`
--
ALTER TABLE `estado_empleado`
  MODIFY `id_estado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `medidor`
--
ALTER TABLE `medidor`
  MODIFY `idmedidor` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `renta`
--
ALTER TABLE `renta`
  MODIFY `id_renta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `ruta`
--
ALTER TABLE `ruta`
  MODIFY `idRuta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `socio`
--
ALTER TABLE `socio`
  MODIFY `idsocio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tarifa`
--
ALTER TABLE `tarifa`
  MODIFY `id_tarifa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `tiraje`
--
ALTER TABLE `tiraje`
  MODIFY `idtiraje` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `socio`
--
ALTER TABLE `socio`
  ADD CONSTRAINT `fk_socio_canton` FOREIGN KEY (`idcanton`) REFERENCES `canton` (`id_canton`);

-- =====================================================
-- TABLAS NUEVAS (agregadas para pruebas)
-- =====================================================
CREATE TABLE `usuario` (
  `idusuario` int(11) NOT NULL AUTO_INCREMENT,
  `idempleado` int(11) NOT NULL,
  `rol` varchar(255) NOT NULL DEFAULT '',
  `usuario` varchar(255) NOT NULL,
  `clave` varchar(255) NOT NULL,
  PRIMARY KEY (`idusuario`),
  UNIQUE KEY `uq_usuario_empleado` (`idempleado`),
  CONSTRAINT `fk_usuario_empleado` FOREIGN KEY (`idempleado`) REFERENCES `empleado` (`idempleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `recibos` (
  `idrecibos` int(11) NOT NULL AUTO_INCREMENT,
  `idconsumo` int(11) NOT NULL,
  `nrecibo` varchar(30) NOT NULL,
  `fecha_generacion` date NOT NULL,
  `metros` decimal(10,2) NOT NULL DEFAULT 0.00,
  `precio_unitario` decimal(10,2) NOT NULL DEFAULT 0.00,
  `monto` decimal(10,2) NOT NULL DEFAULT 0.00,
  `pagado` decimal(10,2) NOT NULL DEFAULT 0.00,
  `pendiente` decimal(10,2) NOT NULL DEFAULT 0.00,
  `estado` varchar(15) NOT NULL DEFAULT 'PENDIENTE',
  PRIMARY KEY (`idrecibos`),
  UNIQUE KEY `uq_nrecibo` (`nrecibo`),
  KEY `idx_recibo_consumo` (`idconsumo`),
  CONSTRAINT `fk_recibo_consumo` FOREIGN KEY (`idconsumo`) REFERENCES `consumo` (`idconsumo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `pagos` (
  `idpago` int(11) NOT NULL AUTO_INCREMENT,
  `idrecibos` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `idempleado` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `fechareal` datetime NOT NULL,
  PRIMARY KEY (`idpago`),
  KEY `idx_pago_recibo` (`idrecibos`),
  CONSTRAINT `fk_pago_recibo` FOREIGN KEY (`idrecibos`) REFERENCES `recibos` (`idrecibos`),
  CONSTRAINT `fk_pago_empleado` FOREIGN KEY (`idempleado`) REFERENCES `empleado` (`idempleado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================
-- DATOS DE PRUEBA
-- =====================================================
INSERT INTO `usuario` (`idempleado`,`rol`,`usuario`,`clave`) VALUES
(2, 'admin, caja', '$2y$10$0Rsyc0gna/i0ZwBK7QDL5uepbSp8.vJ4h5R/Q1mAK7m3aynYsjaua', '$2y$10$boz2Coj7tYXqMLrco8BnhO6HX0tft2ZEqlK2AWN2q4Ib9hxV75m5u'),
(3, 'admin', '$2y$10$IrAUdu.zrv4GjFZW883NG.IdPqYs2Ewz00LOcrdop5khKfTHL8sii', '$2y$10$t4PDAfmE2eeq8pbz0DL9Me7RDorH7T6KGOvcM8KFLNJjVnJxnr0SW'),
(4, 'caja', '$2y$10$T6S9tvmQKXakhf18pI5paugZ5h48bC/LLfz4RoSTRvEkW7kC/hqge', '$2y$10$VBWm2gB0AtSLwNraZvkirulbdz42lkpXM2jaRejvj7dJhzkruUclq');
INSERT INTO `socio` (`idsocio`,`dui`,`nombre`,`apellido`,`telefono`,`fecha_nacimiento`,`profesion`,`idcanton`,`nit`,`direccion`) VALUES
(5, '53464097-2', 'MARIA ELENA', 'LOPEZ RIVAS', '7504-1791', '1969-09-04', 'COSTURERA', 1, '0474-711097-159-8', 'COLONIA CENTRO, CASA #10'),
(6, '21535642-6', 'JUAN CARLOS', 'HERNANDEZ', '7528-2144', '1980-02-18', 'AGRICULTOR', 5, '0534-161981-946-9', 'COLONIA CENTRO, CASA #11'),
(7, '94641177-9', 'ANA GABRIELA', 'MARTINEZ', '7163-7499', '1968-04-02', 'PROFESORA', 7, '0670-239643-396-6', 'COLONIA CENTRO, CASA #12'),
(8, '25809806-9', 'LUIS ALBERTO', 'RAMIREZ CRUZ', '7415-3961', '1971-10-19', 'MECANICO', 8, '0754-296997-481-1', 'COLONIA CENTRO, CASA #13'),
(9, '18427393-9', 'ROSA AMELIA', 'GARCIA', '7161-4374', '1996-11-18', 'COMERCIANTE', 10, '0537-914983-421-7', 'COLONIA CENTRO, CASA #14'),
(10, '58530762-4', 'PEDRO ANTONIO', 'FLORES', '7354-3945', '1980-02-19', 'ALBAÑIL', 1, '0407-650708-606-5', 'COLONIA CENTRO, CASA #15'),
(11, '48646352-9', 'CARMEN', 'ORELLANA DIAZ', '7174-2934', '1997-07-06', 'ENFERMERA', 5, '0875-458671-255-7', 'COLONIA CENTRO, CASA #16'),
(12, '99686414-1', 'JOSE MIGUEL', 'ARGUETA', '7882-6140', '1986-12-12', 'CARPINTERO', 7, '0708-620801-693-7', 'COLONIA CENTRO, CASA #17'),
(13, '22562241-4', 'SANDRA', 'MEJIA CASTRO', '7585-2064', '1968-12-23', 'AMA DE CASA', 8, '0417-778563-691-7', 'COLONIA CENTRO, CASA #18'),
(14, '61780050-5', 'OSCAR RENE', 'ALVARADO', '7123-8564', '1987-03-20', 'ELECTRICISTA', 10, '0219-617674-160-3', 'COLONIA CENTRO, CASA #19');
INSERT INTO `contrato` (`idcontrato`,`ncontrato`,`fecha`,`monto`,`prima`,`idsocio`,`idempleado1`,`cargo1`,`idempleado2`,`cargo2`) VALUES
(3, '3', '2026-05-02', 35.00, 10.00, 5, 3, 'PRESIDENTE', 4, 'SECRETARIO'),
(4, '4', '2026-05-08', 35.00, 10.00, 6, 3, 'PRESIDENTE', 4, 'SECRETARIO'),
(5, '5', '2026-05-18', 35.00, 10.00, 7, 3, 'PRESIDENTE', 4, 'SECRETARIO'),
(6, '6', '2026-07-23', 35.00, 10.00, 8, 3, 'PRESIDENTE', 4, 'SECRETARIO'),
(7, '7', '2026-07-15', 35.00, 10.00, 9, 3, 'PRESIDENTE', 4, 'SECRETARIO'),
(8, '8', '2026-07-15', 35.00, 10.00, 10, 3, 'PRESIDENTE', 4, 'SECRETARIO'),
(9, '9', '2026-06-02', 35.00, 10.00, 11, 3, 'PRESIDENTE', 4, 'SECRETARIO'),
(10, '10', '2026-05-27', 35.00, 10.00, 12, 3, 'PRESIDENTE', 4, 'SECRETARIO'),
(11, '11', '2026-06-23', 35.00, 10.00, 13, 3, 'PRESIDENTE', 4, 'SECRETARIO'),
(12, '12', '2026-06-05', 35.00, 10.00, 14, 3, 'PRESIDENTE', 4, 'SECRETARIO');
INSERT INTO `medidor` (`idmedidor`,`idcontrato`,`nmedidor`,`lectura_inicial`,`idcanton`,`idruta`,`direccion`,`referencia`,`estado`) VALUES
(4, 3, '4', 23.00, 1, 9, 'CALLE PRINCIPAL #12', 'FRENTE A LA TIENDA 4', 'Activo'),
(5, 4, '5', 7.00, 5, 10, 'CALLE PRINCIPAL #15', 'FRENTE A LA TIENDA 5', 'Activo'),
(6, 5, '6', 12.00, 7, 9, 'CALLE PRINCIPAL #18', 'FRENTE A LA TIENDA 6', 'Activo'),
(7, 6, '7', 12.00, 8, 10, 'CALLE PRINCIPAL #21', 'FRENTE A LA TIENDA 7', 'Activo'),
(8, 7, '8', 29.00, 10, 9, 'CALLE PRINCIPAL #24', 'FRENTE A LA TIENDA 8', 'Activo'),
(9, 8, '9', 27.00, 1, 10, 'CALLE PRINCIPAL #27', 'FRENTE A LA TIENDA 9', 'Activo'),
(10, 9, '10', 15.00, 5, 9, 'CALLE PRINCIPAL #30', 'FRENTE A LA TIENDA 10', 'Activo'),
(11, 10, '11', 2.00, 7, 10, 'CALLE PRINCIPAL #33', 'FRENTE A LA TIENDA 11', 'Activo'),
(12, 11, '12', 5.00, 8, 9, 'CALLE PRINCIPAL #36', 'FRENTE A LA TIENDA 12', 'Activo'),
(13, 12, '13', 14.00, 10, 10, 'CALLE PRINCIPAL #39', 'FRENTE A LA TIENDA 13', 'Activo'),
(14, 2, '14', 12.00, 10, 10, 'CALLE PRINCIPAL #42', 'FRENTE A LA TIENDA 14', 'Activo');
INSERT INTO `empleado_ruta` (`idempleado_ruta`,`idempleado`,`idruta`) VALUES
(2, 2, 10);
INSERT INTO `consumo` (`idconsumo`,`idmedidor`,`idempleado`,`fecha_lectura`,`fecha_anterior`,`lectura_anterior`,`lectura_actual`,`fecha_vencimiento`,`aviso`,`mes`,`anio`,`estado`) VALUES
(2, 4, 4, '2026-09-05', NULL, 23.00, 63.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(3, 4, 4, '2026-10-05', '2026-09-05', 63.00, 95.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(4, 4, 4, '2026-11-05', '2026-10-05', 95.00, 117.00, '2026-11-25', '', 10, 2026, 'PENDIENTE'),
(5, 5, 2, '2026-09-05', NULL, 7.00, 38.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(6, 5, 2, '2026-10-05', '2026-09-05', 38.00, 52.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(7, 5, 2, '2026-11-05', '2026-10-05', 52.00, 71.00, '2026-11-25', '', 10, 2026, 'PENDIENTE'),
(8, 6, 4, '2026-09-05', NULL, 12.00, 17.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(9, 6, 4, '2026-10-05', '2026-09-05', 17.00, 40.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(10, 6, 4, '2026-11-05', '2026-10-05', 40.00, 68.00, '2026-11-25', '', 10, 2026, 'PENDIENTE'),
(11, 7, 2, '2026-09-05', NULL, 12.00, 37.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(12, 7, 2, '2026-10-05', '2026-09-05', 37.00, 45.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(13, 7, 2, '2026-11-05', '2026-10-05', 45.00, 75.00, '2026-11-25', '', 10, 2026, 'PENDIENTE'),
(14, 8, 4, '2026-09-05', NULL, 29.00, 59.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(15, 8, 4, '2026-10-05', '2026-09-05', 59.00, 89.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(16, 8, 4, '2026-11-05', '2026-10-05', 89.00, 122.00, '2026-11-25', '', 10, 2026, 'PENDIENTE'),
(17, 9, 2, '2026-09-05', NULL, 27.00, 42.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(18, 9, 2, '2026-10-05', '2026-09-05', 42.00, 47.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(19, 9, 2, '2026-11-05', '2026-10-05', 47.00, 61.00, '2026-11-25', '', 10, 2026, 'PENDIENTE'),
(20, 10, 4, '2026-09-05', NULL, 15.00, 54.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(21, 10, 4, '2026-10-05', '2026-09-05', 54.00, 72.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(22, 10, 4, '2026-11-05', '2026-10-05', 72.00, 101.00, '2026-11-25', '', 10, 2026, 'PENDIENTE'),
(23, 11, 2, '2026-09-05', NULL, 2.00, 16.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(24, 11, 2, '2026-10-05', '2026-09-05', 16.00, 44.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(25, 11, 2, '2026-11-05', '2026-10-05', 44.00, 80.00, '2026-11-25', '', 10, 2026, 'PENDIENTE'),
(26, 12, 4, '2026-09-05', NULL, 5.00, 39.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(27, 12, 4, '2026-10-05', '2026-09-05', 39.00, 53.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(28, 12, 4, '2026-11-05', '2026-10-05', 53.00, 74.00, '2026-11-25', '', 10, 2026, 'PENDIENTE'),
(29, 13, 2, '2026-09-05', NULL, 14.00, 49.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(30, 13, 2, '2026-10-05', '2026-09-05', 49.00, 67.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(31, 13, 2, '2026-11-05', '2026-10-05', 67.00, 95.00, '2026-11-25', '', 10, 2026, 'PENDIENTE'),
(32, 14, 2, '2026-09-05', NULL, 12.00, 26.00, '2026-09-25', '', 8, 2026, 'PENDIENTE'),
(33, 14, 2, '2026-10-05', '2026-09-05', 26.00, 64.00, '2026-10-25', '', 9, 2026, 'PENDIENTE'),
(34, 14, 2, '2026-11-05', '2026-10-05', 64.00, 85.00, '2026-11-25', '', 10, 2026, 'PENDIENTE');
INSERT INTO `recibos` (`idrecibos`,`idconsumo`,`nrecibo`,`fecha_generacion`,`metros`,`precio_unitario`,`monto`,`pagado`,`pendiente`,`estado`) VALUES
(1, 2, '2027-00001', '2026-09-06', 40.00, 1.00, 40.00, 40.00, 40.00, 'PAGADO'),
(2, 3, '2027-00002', '2026-10-06', 32.00, 0.75, 24.00, 0.00, 24.00, 'PENDIENTE'),
(3, 5, '2027-00003', '2026-09-06', 31.00, 0.75, 23.25, 23.25, 23.25, 'PAGADO'),
(4, 6, '2027-00004', '2026-10-06', 14.00, 0.50, 7.00, 7.00, 7.00, 'PAGADO'),
(5, 8, '2027-00005', '2026-09-06', 5.00, 3.00, 3.00, 3.00, 3.00, 'PAGADO'),
(6, 9, '2027-00006', '2026-10-06', 23.00, 0.75, 17.25, 17.25, 17.25, 'PAGADO'),
(7, 11, '2027-00007', '2026-09-06', 25.00, 0.75, 18.75, 18.75, 18.75, 'PAGADO'),
(8, 12, '2027-00008', '2026-10-06', 8.00, 3.00, 3.00, 1.50, 3.00, 'PENDIENTE'),
(9, 14, '2027-00009', '2026-09-06', 30.00, 0.75, 22.50, 22.50, 22.50, 'PAGADO'),
(10, 15, '2027-00010', '2026-10-06', 30.00, 0.75, 22.50, 22.50, 22.50, 'PAGADO'),
(11, 17, '2027-00011', '2026-09-06', 15.00, 0.50, 7.50, 7.50, 7.50, 'PAGADO'),
(12, 18, '2027-00012', '2026-10-06', 5.00, 3.00, 3.00, 0.00, 3.00, 'PENDIENTE'),
(13, 20, '2027-00013', '2026-09-06', 39.00, 1.00, 39.00, 39.00, 39.00, 'PAGADO'),
(14, 21, '2027-00014', '2026-10-06', 18.00, 0.50, 9.00, 0.00, 9.00, 'PENDIENTE'),
(15, 23, '2027-00015', '2026-09-06', 14.00, 0.50, 7.00, 3.50, 7.00, 'PENDIENTE'),
(16, 24, '2027-00016', '2026-10-06', 28.00, 0.75, 21.00, 10.50, 21.00, 'PENDIENTE'),
(17, 26, '2027-00017', '2026-09-06', 34.00, 0.75, 25.50, 25.50, 25.50, 'PAGADO'),
(18, 27, '2027-00018', '2026-10-06', 14.00, 0.50, 7.00, 7.00, 7.00, 'PAGADO'),
(19, 29, '2027-00019', '2026-09-06', 35.00, 0.75, 26.25, 13.12, 26.25, 'PENDIENTE'),
(20, 30, '2027-00020', '2026-10-06', 18.00, 0.50, 9.00, 0.00, 9.00, 'PENDIENTE'),
(21, 32, '2027-00021', '2026-09-06', 14.00, 0.50, 7.00, 3.50, 7.00, 'PENDIENTE'),
(22, 33, '2027-00022', '2026-10-06', 38.00, 1.00, 38.00, 19.00, 38.00, 'PENDIENTE');
INSERT INTO `pagos` (`idpago`,`idrecibos`,`fecha`,`idempleado`,`monto`,`fechareal`) VALUES
(1, 1, '2026-09-24', 3, 40.00, '2026-09-24 10:52:00'),
(2, 3, '2026-09-20', 3, 23.25, '2026-09-20 14:14:00'),
(3, 4, '2026-10-12', 3, 7.00, '2026-10-12 10:14:00'),
(4, 5, '2026-09-23', 3, 3.00, '2026-09-23 10:16:00'),
(5, 6, '2026-10-12', 3, 17.25, '2026-10-12 14:34:00'),
(6, 7, '2026-09-21', 3, 18.75, '2026-09-21 16:39:00'),
(7, 8, '2026-10-24', 3, 1.50, '2026-10-24 16:25:00'),
(8, 9, '2026-09-11', 3, 22.50, '2026-09-11 15:40:00'),
(9, 10, '2026-10-13', 3, 22.50, '2026-10-13 09:13:00'),
(10, 11, '2026-09-15', 3, 7.50, '2026-09-15 08:06:00'),
(11, 13, '2026-09-15', 3, 39.00, '2026-09-15 08:04:00'),
(12, 15, '2026-09-14', 3, 3.50, '2026-09-14 13:38:00'),
(13, 16, '2026-10-11', 3, 10.50, '2026-10-11 09:54:00'),
(14, 17, '2026-09-17', 3, 25.50, '2026-09-17 12:05:00'),
(15, 18, '2026-10-21', 3, 7.00, '2026-10-21 13:47:00'),
(16, 19, '2026-09-12', 3, 13.12, '2026-09-12 16:01:00'),
(17, 21, '2026-09-18', 3, 3.50, '2026-09-18 08:48:00'),
(18, 22, '2026-10-20', 3, 19.00, '2026-10-20 09:44:00');
UPDATE `tiraje` SET `ultimo` = 22 WHERE `idtiraje` = 3;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
