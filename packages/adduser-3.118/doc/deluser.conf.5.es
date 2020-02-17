.\" Hey, Emacs!  This is an -*- nroff -*- source file.
.\" Adduser and this manpage are copyright 1995 by Ted Hajek
.\"
.\" This is free software; see the GNU General Public Lisence version 2
.\" or later for copying conditions.  There is NO warranty.
.\"*******************************************************************
.\"
.\" This file was generated with po4a. Translate the source file.
.\"
.\"*******************************************************************
.TH deluser.conf 5 "Versión VERSIÓN" "Debian GNU/Linux" 
.SH NOMBRE
/etc/deluser.conf \- Fichero de configuración para \fBdeluser(8)\fP y
\fBdelgroup(8)\fP
.SH DESCRIPCIÓN
El fichero \fI/etc/deluser.conf\fP contiene las preferencias de los programas
\fBdeluser(8)\fP y \fBdelgroup(8)\fP. Cada opción tiene la forma \fIopción\fP =
\fIvalor\fP. Se permiten comillas simples o dobles alrededor del valor. Los
comentarios deben comenzar con el signo #.

\fBdeluser(8)\fP and \fBdelgroup(8)\fP also read \fI/etc/adduser.conf,\fP see
\fBadduser.conf(5);\fP settings in \fIdeluser.conf\fP may overwrite settings made
in \fIadduser.conf.\fP

Las opciones de configuración válidas son:
.TP 
\fBREMOVE_HOME\fP
Determina si se elimina el directorio personal y de correo (n.t. mail spool)
del usuario. El valor puede ser 1 (elimina) o cero (no elimina).
.TP 
\fBREMOVE_ALL_FILES\fP
Elimina todos los ficheros del sistema pertenecientes al usuario
eliminado. Si la opción está activada \fBREMOVE_HOME\fP no tiene efecto. Puede
valer 1 o 0.
.TP 
\fBBACKUP\fP
Si \fBREMOVE_HOME\fP o \fBREMOVE_ALL_FILES\fP está activado, se realizará una
copia de respaldo de todos los ficheros antes de eliminarlos. La copia de
respaldo creada se nombrará nombreusuario.tar(.gz|.bz2) por omisión, en el
directorio especificado por la opción \fBBACKUP_TO\fP. El método de compresión
se selecciona entre los mejores disponibles. Los valores pueden ser 1 o
cero.
.TP 
\fBBACKUP_TO\fP
Si \fBBACKUP\fP está activado, \fBBACKUP_TO\fP especifica el directorio donde se
escribe la copia de seguridad. El valor predeterminado es el directorio
actual.
.TP 
\fBNO_DEL_PATHS\fP
Una lista de expresiones regulares separadas por espacios. Todos los
ficheros a eliminar durante la eliminación de directorios personales, o de
ficheros propiedad del usuario, se comparan con estas expresiones
regulares. El fichero no se eliminará si se detecta una coincidencia. El
comportamiento predeterminado es una lista de directorios del sistema,
omitiendo sólo «/home».

En otras palabras: Por omisión, sólo se eliminarán los ficheros bajo la
carpeta «/home» que pertenezcan a ese usuario específico.

.TP 
\fBONLY_IF_EMPTY\fP
Only delete a group if there are no users belonging to this group. Defaults
to 0.
.TP 
\fBEXCLUDE_FSTYPES\fP
Una expresión regular que describe todos los sistemas de ficheros a excluir
al buscar los ficheros de un usuario a eliminar. El valor predeterminado es
«(proc|sysfs|usbfs|devpts|tmpfs|afs)».

.SH FICHEROS
\fI/etc/deluser.conf\fP
.SH "VÉASE TAMBIÉN"
\fBadduser.conf\fP(5), \fBdelgroup\fP(8), \fBdeluser(8)\fP
.SH TRADUCTOR
Traducción de Rubén Porras Campo <debian-l10n-spanish@lists.debian.org>
adduser.8 et .5.conf a la fin
