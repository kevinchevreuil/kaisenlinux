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
.TH adduser.conf 5 "Versión VERSIÓN" "Debian GNU/Linux" 
.SH NOMBRE
/etc/adduser.conf \- Fichero de configuración para \fBadduser(8)\fP y
\fBaddgroup(8)\fP.
.SH DESCRIPCIÓN
El fichero \fI/etc/adduser.conf\fP contiene las preferencias para los programas
\fBadduser(8)\fP, \fBaddgroup(8)\fP, \fBdeluser(8)\fP y \fBdelgroup(8)\fP. Cada línea
tiene una opción con la forma \fIopción\fP = \fIvalor\fP. Se permiten comillas
simples o dobles alrededor del valor. Los comentarios deben comenzar con el
signo #.

Las opciones de configuración válidas son:
.TP 
\fBDSHELL\fP
La consola para todos los usuarios nuevos. Por omisión es \fI/bin/bash\fP.
.TP 
\fBDHOME\fP
El directorio donde se deben crear los nuevos directorios de los
usuarios. Por omisión \fI/home\fP.
.TP 
\fBGROUPHOMES\fP
Si es \fIyes\fP, los directorios personales se crearán como
\fI/home/[nombregrupo]/usuario\fP. Por omisión es \fIno\fP.
.TP 
\fBLETTERHOMES\fP
Si es \fIyes\fP, los directorios personales tendrán un directorio extra con la
primera letra del nombre de usuario. Por ejemplo: \fI/home/u/user\fP. Por
omisión es \fIno\fP.
.TP 
\fBSKEL\fP
El directorio de donde se copian los ficheros de configuración esqueleto del
usuario. Por omisión es \fI/etc/skel\fP.
.TP 
\fBFIRST_SYSTEM_UID\fP y \fBLAST_SYSTEM_UID\fP
define un rango de números de identificador de usuario (UID) inclusivo en el
cual se pueden asignar números UID de sistema de forma dinámica. El valor
por omisión es \fI100\fP \- \fI999\fP. Tenga en cuenta que el software de sistema,
como usuarios asignados por el paquete base\-passwd, pueden suponer que los
números UID menores de 100 no están asignados.
.TP 
\fBFIRST_UID\fP y \fBLAST_UID\fP
especifica un rango dinámico de identificadores para usuarios normales
(ambos incluidos). Por omisión es \fI1000\fP \- \fI59999\fP.
.TP 
\fBFIRST_SYSTEM_GID\fP y \fBLAST_SYSTEM_GID\fP
define un rango inclusivo de números GID del cual se pueden asignar
dinámicamente los GID del sistema. El valor por omisión es \fI100\fP \- \fI999\fP.
.TP 
\fBFIRST_GID\fP y \fBLAST_GID\fP
define un rango inclusivo de números GID del cual se pueden asignar
dinámicamente números GID de grupo normales. El valor por omisión es \fI1000\fP
\- \fI59999\fP.
.TP 
\fBUSERGROUPS\fP
Si es \fIyes\fP, entonces cada usuario creado tendrá su propio grupo. Si es
\fIno\fP, cada usuario creado tendrá como grupo aquél cuyo GID es \fBUSERS_GID\fP
(lea más abajo). Por omisión es \fIyes\fP.
.TP 
\fBUSERS_GID\fP
Si \fBUSERGROUPS\fP es \fIno\fP, entonces \fBUSERS_GID\fP es el GID dado para todos
los usuarios creados. El valor por omisión es \fI100\fP.
.TP 
\fBDIR_MODE\fP
Si es un valor válido (p. ej. 0755 o 755), los directorios creados tendrán
los permisos especificados como umask. De lo contrario se usará 0755 por
omisión.
.TP 
\fBSETGID_HOME\fP
Si es \fIyes\fP, los directorios personales para los usuarios con su propio
grupo ( \fIUSERGROUPS=yes\fP ) tendrán activado el bit setgid. Este fue el
comportamiento predeterminado de adduser hasta la versión
3.13. Desafortunadamente tenía algunos efectos secundarios indeseados, por
eso esto ya no se hace a menos que se especifique lo contrario. De todas
formas, todavía puede activarlo aquí.
.TP 
\fBQUOTAUSER\fP
Si se establece a cualquier valor no nulo, los nuevos usuarios tendrán las
mismas cuotas que ese usuario. Por omisión está vacío.
.TP 
\fBNAME_REGEX\fP
Los nombres de grupo y usuario se comparan con esta expresión regular. Si el
nombre no coincide con la expresión regular, adduser rechazará crear
usuarios y grupos a menos que se defina «\-\-force\-badname». Si se define
«\-\-force\-badname», sólo se realizarán comprobaciones débiles. El valor por
omisión, más conservador, es ^[a\-z][\-a\-z0\-9]*$.
.TP 
\fBSKEL_IGNORE_REGEX\fP
Los ficheros en «/etc/skel/» se comparan con esta expresión regular, y no se
copia al directorio personal recién creado si coinciden. Por omisión, está
definido con la expresión regular que coincide con los ficheros dejados por
ficheros de configuración no fusionados (dpkg\-(old|new|dist)).
.TP 
\fBADD_EXTRA_GROUPS\fP
Definir esto con un valor distinto de cero (el valor predeterminado) causará
que adduser añada usuarios no del sistema recién creados a la lista de
grupos definidos por EXTRA_GROUPS (a continuación).
.TP 
\fBEXTRA_GROUPS\fP
This is the list of groups that new non\-system users will be added to.  By
default, this list is 'dialout cdrom floppy audio video plugdev users
games'.
.SH NOTAS
.TP 
\fBVALID NAMES\fP
adduser y addgroup imponen la conformidad con IEEE Std 1003.1\-2001, que
permite sólo la aparición de los siguientes caracteres en nombres de usuario
y grupo: letras, dígitos, guiones bajos, puntos, signos de arroba (@) y
guiones. El nombre no puede empezar con un guión. Se permite usar el signo
«$» al final de nombres de usuario (en conformidad con samba).

Puede definir una comprobación adicional con el parámetro de configuración
NAME_REGEX para forzar una norma local.

.SH FICHEROS
\fI/etc/adduser.conf\fP
.SH "VÉASE TAMBIÉN"
\fBaddgroup\fP(8), \fBadduser\fP(8), \fBdelgroup\fP(8), \fBdeluser\fP(8),
\fBdeluser.conf\fP(5)
.SH TRADUCTOR
Traducción de Rubén Porras Campo <debian-l10n-spanish@lists.debian.org>
adduser.8 et .5.conf a la fin
