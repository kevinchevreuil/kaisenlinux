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
.TH ADDUSER 8 "Versión VERSIÓN" "Debian GNU/Linux" 
.SH NOMBRE
adduser, addgroup \- Añade un usuario o grupo al sistema
.SH SINOPSIS
\fBadduser\fP [opciones] [\-\-home DIRECTORIO] [\-\-shell CONSOLA]
[\-\-no\-create\-home] [\-\-uid ID] [\-\-firstuid ID] [\-\-lastuid ID] [\-\-ingroup
GRUPO | \-\-gid ID] [\-\-disabled\-password] [\-\-disabled\-login] [\-\-gecos GECOS]
[\-\-add_extra_groups] USUARIO
.PP
\fBadduser\fP \-\-system [opciones] [\-\-home DIRECTORIO] [\-\-shell CONSOLA]
[\-\-no\-create\-home] [\-\-uid ID] [\-\-group | \-\-ingroup GRUPO | \-\-gid ID]
[\-\-disabled\-password] [\-\-disabled\-login] [\-\-gecos GECOS] USUARIO
.PP
\fBaddgroup\fP [opciones] [\-\-gid ID] grupo
.PP
\fBaddgroup\fP \-\-system [opciones] [\-\-gid ID] grupo
.PP
\fBadduser\fP [opciones] usuario grupo
.SS "OPCIONES COMUNES"
.br
[\-\-quiet] [\-\-debug] [\-\-force\-badname] [\-\-help|\-h] [\-\-version] [\-\-conf
FICHERO]
.SH DESCRIPCIÓN
.PP
\fBadduser\fP y \fBaddgroup\fP añaden usuarios y grupos al sistema de acuerdo a
las opciones de la línea de órdenes y a la configuración en
\fI/etc/adduser.conf\fP. Ofrecen una interfaz más sencilla para programas de
bajo nivel como \fBuseradd\fP, \fBgroupadd\fP y \fBusermod\fP, seleccionando valores
para el identificador de usuario (UID) e identificador de grupo de usuarios
(GID) conforme a las normas de Debian. También crean un directorio personal
(«/home/USUARIO») con la configuración predeterminada, ejecutan un script
personalizado y otras funcionalidades. \fBadduser\fP y \fBaddgroup\fP pueden
ejecutarse de cinco maneras distintas:
.SS "Añadir un usuario normal"
Si se invoca con un argumento que no es ninguna opción y sin la opción
\fB\-\-system\fP o \fB\-\-group\fP, \fBadduser\fP añadirá un usuario normal.

\fBadduser\fP elegirá el primer UID disponible dentro del rango especificado
para usuarios normales en el fichero de configuración. Puede elegir uno
manualmente usando la opción \fB\-\-uid\fP.

Puede modificar el rango especificado en el fichero de configuración usando
las opciones \fB\-\-firstuid\fP y \fB\-\-lastuid.\fP

By default, each user in Debian GNU/Linux is given a corresponding group
with the same name.  Usergroups allow group writable directories to be
easily maintained by placing the appropriate users in the new group, setting
the set\-group\-ID bit in the directory, and ensuring that all users use a
umask of 002.  If this option is turned off by setting \fBUSERGROUPS\fP to
\fIno\fP, all users' GIDs are set to \fBUSERS_GID\fP.  Users' primary groups can
also be overridden from the command line with the \fB\-\-gid\fP or \fB\-\-ingroup\fP
options to set the group by id or name, respectively.  Also, users can be
added to one or more groups defined in adduser.conf either by setting
ADD_EXTRA_GROUPS to 1 in adduser.conf, or by passing \fB\-\-add_extra_groups\fP
on the commandline.

\fBadduser\fP creará los directorios personales de acuerdo con \fBDHOME\fP,
\fBGROUPHOMES\fP, y \fBLETTERHOMES\fP. El directorio personal se puede especificar
mediante la opción de línea de órdenes \fB\-\-home\fP, y la consola mediante la
opción \fB\-\-shell\fP. El bit set\-group\-ID del directorio personal está
habilitado si \fBUSERGROUPS\fP es \fIyes\fP, de forma que cualquier fichero creado
en el directorio personal del usuario tendrá el grupo correcto.

\fBadduser\fP copiará los ficheros desde \fBSKEL\fP en el directorio personal y
preguntará por la información del campo gecos y por la clave. El campo gecos
también se puede definir con la opción \fB\-\-gecos\fP. Con la opción
\fB\-\-disabled\-login\fP, la cuenta se creará pero estará deshabilitada hasta que
se proporcione una clave. La opción \fB\-\-disabled\-password\fP no establecerá la
clave, pero todavía será posible trabajar con la cuenta, por ejemplo
mediante claves SSH RSA.

Si existe el fichero \fB/usr/local/sbin/adduser.local\fP, se ejecutará después
de que la cuenta de usuario esté lista, posibilitando realizar ajustes
locales. Los argumentos que se pasan a \fBadduser.local\fP son:
.br
nombre\-usuario UID GID directorio\-personal
.br
La variable de entorno VERBOSE se define de acuerdo a la siguiente regla:
.TP  
0 if 
\fB\-\-quiet\fP is specified
.TP  
1 if neither 
\fB\-\-quiet\fP nor \fB\-\-debug\fP is specified
.TP  
2 if 
\fB\-\-debug\fP is specified

(The same applies to the variable DEBUG, but DEBUG is deprecated and will be
removed in a later version of \fBadduser\fP.)

.SS "Añadir un usuario del sistema"
If called with one non\-option argument and the \fB\-\-system\fP option,
\fBadduser\fP will add a system user. If a user with the same name already
exists in the system uid range (or, if the uid is specified, if a user with
that uid already exists), adduser will exit with a warning. This warning can
be suppressed by adding \fB\-\-quiet\fP.

\fBadduser\fP elegirá el primer UID disponible en el rango especificado en el
fichero de configuración para usuarios del sistema (FIRST_SYSTEM_UID y
LAST_SYSTEM_UID). Si desea un UID específico, lo puede especificar con la
opción \fB\-\-uid\fP.

Por omisión, los usuarios del sistema se añaden al grupo \fBnogroup\fP. Para
añadir el nuevo usuario del sistema a un grupo existente, use las opciones
\fB\-\-gid\fP o \fB\-\-ingroup\fP. Para añadir el nuevo usuario del sistema a un grupo
con su mismo ID, use la opción \fB\-\-group\fP.

El directorio personal se crea con las mismas normas que para los usuarios
normales. Los nuevos usuarios del sistema tendrán como consola
\fI/usr/sbin/nologin\fP (a menos que se modifique con la opción \fB\-\-shell\fP), y
tienen la clave deshabilitada. Los ficheros de configuración esqueleto no se
copian.
.SS "Añadir un grupo de usuarios"
Si se invoca \fBadduser\fP con la opción \fB\-\-group\fP y sin las opciones
\fB\-\-system\fP o \fBaddgroup\fP respectivamente, añadirá un grupo de usuarios.


Se elegirá un GID dentro del rango especificado en el fichero de
configuración para los GID de sistema (FIRST_GID y LAST_GID). Puede anular
este comportamiento introduciendo el GID con la opción \fB\-\-gid\fP.

El grupo se creará sin usuarios.
.SS "Añadir un grupo del sistema"
Si se invoca \fBadduser\fP con la opción \fB\-\-system\fP se añadirá un grupo del
sistema.

Se elegirá un GID dentro del rango especificado en el fichero de
configuración para los GID del sistema (FIRST_SYSTEM_GID,
LAST_SYSTEM_GID). Puede especificar el GID con la opción \fB\-\-gid\fP, anulando
este comportamiento.

El grupo se creará sin usuarios.
.SS "Añadir un usuario existente a un grupo existente"
Si se invoca con dos argumentos que no sean opciones, \fBadduser\fP añadirá un
usuario existente a un grupo existente.
.SH OPCIONES
.TP 
\fB\-\-conf FICHERO\fP
Usa FICHERO en vez de \fI/etc/adduser.conf\fP.
.TP 
\fB\-\-disabled\-login\fP
No ejecuta passwd para establecer la clave. El usuario no podrá usar la
cuenta hasta que se establezca una clave.
.TP 
\fB\-\-disabled\-password\fP
Como «\-\-disabled\-login», pero todavía es posible usar la cuenta, por ejemplo
mediante claves SSH RSA, pero no usando autenticación de claves.
.TP 
\fB\-\-force\-badname\fP
By default, user and group names are checked against the configurable
regular expression \fBNAME_REGEX\fP specified in the configuration file. This
option forces \fBadduser\fP and \fBaddgroup\fP to apply only a weak check for
validity of the name.  \fBNAME_REGEX\fP is described in \fBadduser.conf\fP(5).
.TP 
\fB\-\-gecos GECOS\fP
Especifica el nuevo campo gecos para la entrada generada. \fBadduser\fP no
solicitará esta información si se proporciona esta opción.
.TP 
\fB\-\-gid ID\fP
Cuando se crea un grupo, esta opción fuerza el nuevo GID al número
dado. Cuando se crea un usuario la opción añade el usuario a ese grupo.
.TP 
\fB\-\-group\fP
Cuando se combina con \fB\-\-system\fP, se crea un grupo con el ID y nombre del
usuario del sistema. Si no se combina con \fB\-\-system\fP, se crea un grupo con
el nombre dado. Ésta es la acción predeterminada si el programa se invoca
como \fBaddgroup\fP.
.TP 
\fB\-\-help\fP
Muestra unas instrucciones breves.
.TP 
\fB\-\-home DIRECTORIO\fP
Usa DIRECTORIO para el directorio personal, en vez del predeterminado
especificado en el fichero de configuración. Si el directorio no existe, se
crea y se copian los ficheros de esqueleto.
.TP 
\fB\-\-shell CONSOLA\fP
Usar CONSOLA como la consola de entrada del usuario, en vez del
predeterminado especificado en el fichero de configuración.
.TP 
\fB\-\-ingroup GRUPO\fP
Add the new user to GROUP instead of a usergroup or the default group
defined by \fBUSERS_GID\fP in the configuration file.  This affects the users
primary group.  To add additional groups, see the \fBadd_extra_groups\fP
option.
.TP 
\fB\-\-no\-create\-home\fP
No crea el directorio personal, incluso si no existe.
.TP 
\fB\-\-quiet\fP
Elimina los mensajes informativos, sólo muestra avisos y errores.
.TP 
\fB\-\-debug\fP
Muestra más información, útil si desea encontrar el origen de un problema
con adduser.
.TP 
\fB\-\-system\fP
Crea un usuario del sistema o grupo.
.TP 
\fB\-\-uid ID\fP
Fuerza el nuevo identificador de usuario al número dado. \fBadduser\fP fallará
si el UID ya está en uso.
.TP 
\fB\-\-firstuid ID\fP
Modifica el primer UID del rango del cual se eligen los UID (anula el valor
de \fBFIRST_UID\fP definido en el fichero de configuración).
.TP 
\fB\-\-lastuid ID\fP
Modifica el último UID del rango del cual se eligen los UID (\fBLAST_UID\fP).
.TP 
\fB\-\-add_extra_groups\fP
Añade un nuevo usuario a los grupos adicionales definidos en el fichero de
configuración.
.TP 
\fB\-\-version\fP
Muestra la versión e información acerca del copyright.

.SH "VALORES DE SALIDA"

.TP 
\fB0\fP
El usuario definido ya existe. Puede tener dos causas: El usuario se ha
creado mediante adduser, o el usuario ya existía en el sistema antes de
invocar adduser. Si adduser devuelve 0, invocar adduser por segunda vez con
los mismos parámetros también devuelve 0.
.TP 
\fB1\fP
Ha fallado la creación de un usuario o grupo porque ya existía con un
UID/GID diferente del especificado. El nombre de usuario o grupo ha sido
rechazado por no coincidir con la expresión regular configurada. Consulte
adduser.conf(5). Una señal ha cancelado la ejecución de adduser.
.br
O por otras razones no documentadas que se muestran en el intérprete de
órdenes. Puede entonces considerar eliminar \fB\-\-quiet\fP para que adduser sea
más informativo.

.SH FICHEROS
.TP  
/etc/adduser.conf
El fichero de configuración predeterminado de adduser y addgroup.
.TP 
/usr/local/sbin/adduser.local
Optional custom add\-ons.

.SH "VÉASE TAMBIÉN"
\fBadduser.conf\fP(5), \fBdeluser\fP(8), \fBgroupadd\fP(8), \fBuseradd\fP(8),
\fBusermod\fP(8), Debian Policy 9.2.2.

.SH TRADUCTOR
Traducción de Rubén Porras Campo <debian-l10n-spanish@lists.debian.org>
adduser.8 et .5.conf a la fin
.SH COPYRIGHT
Copyright (C) 1997, 1998, 1999 Guy Maor. Modifications de Roland
Bauerschmidt y Marc Haber. Parches adicionales por Joerg Hoh y Stephen Gran.
.br
Copyright (C) 1995 Ted Hajek, con una gran aportación del \fBadduser\fP
original de Debian
.br
Copyright (C) 1994 Ian Murdock.  \fBadduser\fP es software libre; lea la
Licencia Pública General de GNU versión 2 o posterior para las condiciones
de copia.  \fINo\fP hay garantía.
