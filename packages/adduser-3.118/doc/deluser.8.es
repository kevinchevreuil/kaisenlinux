.\" Someone tell emacs that this is an -*- nroff -*- source file.
.\" Copyright 1997, 1998, 1999 Guy Maor.
.\" Adduser and this manpage are copyright 1995 by Ted Hajek,
.\" With much borrowing from the original adduser copyright 1994 by
.\" Ian Murdock.
.\" This is free software; see the GNU General Public License version
.\" 2 or later for copying conditions.  There is NO warranty.
.\"*******************************************************************
.\"
.\" This file was generated with po4a. Translate the source file.
.\"
.\"*******************************************************************
.TH DELUSER 8 "Versión VERSIÓN" "Debian GNU/Linux" 
.SH NOMBRE
deluser, delgroup \- Elimina un usuario o grupo del sistema
.SH SINOPSIS
\fBdeluser\fP [opciones] [\-\-force] [\-\-remove\-home] [\-\-remove\-all\-files]
[\-\-backup] [\-\-backup\-to DIRECTORIO] usuario
.PP
\fBdeluser\fP \-\-group [opciones] grupo
.br
\fBdelgroup\fP [opciones] [\-\-only\-if\-empty] grupo
.PP
\fBdeluser\fP [opciones] usuario grupo
.SS "OPCIONES COMUNES"
.br
[\-\-quiet] [\-\-system] [[\-\-help] [\-\-version] [\-\-conf FICHERO]
.SH DESCRIPCIÓN
.PP
\fBdeluser\fP y \fBdelgroup\fP eliminan usuarios y grupos del sistema de acuerdo a
las opciones en línea de órdenes y a la configuración en
\fI/etc/deluser.conf\fP y \fI/etc/adduser.conf\fP. Proporcionan una interfaz más
sencilla para los programas \fBuserdel\fP y \fBgroupdel\fP, eliminado
opcionalmente el directorio personal o incluso todos los ficheros del
sistema pertenecientes al usuario, ejecutar un script personalizado, y otras
características. \fBdeluser\fP y \fBdelgroup\fP pueden ejecutarse de tres maneras:
.SS "Eliminar un usuario normal"
Si se invoca con un argumento que no es ninguna opción y sin la opción
\fB\-\-group\fP, \fBdeluser\fP eliminará un usuario normal.

Por omisión, \fBdeluser\fP eliminará el usuario, pero no su directorio personal
ni su directorio de cola de correo (n.t. mail spool) o cualquier otro
fichero del sistema perteneciente al usuario. Puede usar la opción
\fB\-\-remove\-home\fP para eliminar el directorio personal y de cola de correo.

La opción \fB\-\-remove\-all\-files\fP elimina todos los ficheros pertenecientes al
usuario en el sistema. Tenga en cuenta que si activa ambas opciones
\fB\-\-remove\-home\fP no tiene ningún efecto porque \fB\-\-remove\-all\-files\fP es una
opción más general.

Si quiere hacer una copia de seguridad de todos los ficheros antes de
eliminarlos use la opción \fB\-\-backup\fP que creará un fichero
nombreusuario.tar (.gz|.bz2) en el directorio especificado por la opción
\fB\-\-backup\-to\fP (el directorio de trabajo actual de forma
predeterminada). Ambas opciones, la de eliminación y la de copias de
seguridad se pueden especificar como predeterminadas en el fichero
«/etc/deluser.conf». Consulte \fBdeluser.conf(5)\fP para más detalles.

Si desea eliminar la cuenta del usuario «root» (UID 0), use el parámetro
\fB\-\-force\fP; esto puede evitar la eliminación accidental del usuario «root».

Si existe el fichero \fB/usr/local/sbin/deluser.local\fP, este se ejecutará
después de eliminar la cuenta de usuario de forma que se pueda realizar
algún ajuste local. Los argumentos que se pasan a \fBdeluser.local\fP son:
.br
nombre\-usuario UID GID directorio\-personal

.SS "Eliminar un grupo"
Si se invoca \fBdeluser\fP con la opción \fB\-\-group\fP , o se invoca \fBdelgroup\fP,
se eliminará un grupo.

Advertencia: No se puede eliminar el grupo primario de un usuario existente.

Si se usa la opción \fB\-\-only\-if\-empty\fP, el grupo no se elimina en caso de
que todavía tenga algún miembro.

.SS "Elimina un usuario de un grupo específico"
Si se invoca con dos argumentos que no sean opciones, \fBdeluser\fP eliminará
el usuario del grupo especificado.
.SH OPCIONES
.TP 
\fB\-\-conf FICHERO\fP
Usa FICHERO en lugar de los ficheros predeterminados \fI/etc/deluser.conf\fP y
\fI/etc/adduser.conf\fP.
.TP 
\fB\-\-group\fP
Elimina un grupo. La opción predeterminada si se invoca como \fIdelgroup\fP.
.TP 
\fB\-\-help\fP
Muestra unas instrucciones breves.
.TP 
\fB\-\-quiet\fP
Suprime mensajes indicadores de progreso.
.TP 
\fB\-\-system\fP
Sólo elimina si el usuario/grupo es un usuario/grupo del sistema. Esto evita
borrar accidentalmente usuarios/grupos que no sean del sistema. Además, si
el usuario no existe, no se devuelve ningún valor de error. Esta opción está
diseñado para su uso en los scripts de desarrollador de paquetes de Debian.
.TP 
\fB\-\-only\-if\-empty\fP
Only remove if no members are left.
.TP 
\fB\-\-backup\fP
Crea una copia de respaldo de todos los ficheros contenidos en el directorio
personal del usuario y el fichero de cola de correo a un fichero llamado
«/$user.tar.bz2» o «/$user.tar.gz».
.TP 
\fB\-\-backup\-to\fP
No ubica las copias de respaldo en «/», sino en el directorio definido por
este parámetro. Define «\-\-backup» de forma implícita.
.TP 
\fB\-\-remove\-home\fP
Elimina el directorio personal del usuario y su cola de correo. Si se define
«\-\-backup», los ficheros se eliminarán después de realizar la copia de
respaldo.
.TP 
\fB\-\-remove\-all\-files\fP
Elimina todos los ficheros del sistema propiedad de este usuario. Nota:
«remove\-home» ya no tiene efecto. Si se define «\-\-backup», se eliminarán los
ficheros después de realizar la copia de respaldo.
.TP 
\fB\-\-version\fP
Muestra la versión e información acerca del copyright.
.SH "VALOR DE SALIDA"
.TP 
\fB0\fP
La acción se ha ejecutado correctamente.
.TP 
\fB1\fP
El usuario a eliminar no es una cuenta del sistema. No se ha realizado
ninguna acción.
.TP 
\fB2\fP
El usuario no existe. No se ha realizado ninguna acción.
.TP 
\fB3\fP
El grupo no existe. No se ha realizado ninguna acción.
.TP 
\fB4\fP
Se ha detectado un error interno. No se ha realizado ninguna acción.
.TP 
\fB5\fP
El grupo a eliminar no está vacío. No se ha realizado ninguna acción.
.TP 
\fB6\fP
El usuario no pertenece al grupo especificado. No se ha realizado ninguna
acción.
.TP 
\fB7\fP
No puede eliminar un usuario de su grupo primario. No se ha realizado
ninguna acción.
.TP 
\fB8\fP
El paquete requerido perl no está instalado. Este paquete es necesario para
realizar las acciones solicitadas. No se ha realizado ninguna acción.
.TP 
\fB9\fP
Se requiere el parámetro «\-\-force» para eliminar la cuenta del usuario
«root». No se ha realizado ninguna acción.

.SH FICHEROS
\fI/etc/deluser.conf\fP Default configuration file for deluser and delgroup
.TP 
\fI/usr/local/sbin/deluser.local\fP
Optional custom add\-ons.

.SH "VÉASE TAMBIÉN"
\fBadduser\fP(8), \fBdeluser.conf\fP(5), \fBgroupdel\fP(8), \fBuserdel\fP(8)

.SH TRADUCTOR
Traducción de Rubén Porras Campo <debian-l10n-spanish@lists.debian.org>
adduser.8 et .5.conf a la fin
.SH COPYRIGHT
Copyright (C) 2000 Roland Bauerschmidt. Modificaciones (C) 2004 Marc Haber y
Joerg Hoh. Esta página de manual y el programa deluser se basan en adduser,
el cual es:
.br
Copyright (C) 1997, 1998, 1999 Guy Maor.
.br
Copyright (C) 1995 Ted Hajek, con una gran aportación del \fBadduser\fP
original de Debian
.br
Copyright (C) 1994 Ian Murdock.  \fBadduser\fP es software libre; lea la
Licencia Pública General de GNU versión 2 o posterior para las condiciones
de copia.  \fINo\fP hay garantía.
