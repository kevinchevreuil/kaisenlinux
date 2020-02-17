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
.\"
.\" Russian verison:
.\"   Alexey Mahotkin <alexm@hsys.msk.ru>, 2001
.\"   Yuri Kozlov <kozlov.y@gmail.com>, 2005
.\"

.TH deluser.conf 5 "Версия VERSION" "Debian GNU/Linux" 
.SH NAME
/etc/deluser.conf \- файл настройки для \fBdeluser(8)\fP и \fBdelgroup(8)\fP.
.SH ОПИСАНИЕ
Файл \fI/etc/deluser.conf\fP содержит установки по умолчанию для программ
\fBdeluser(8)\fP и \fBdelgroup(8)\fP. В каждой строке содержится по одному
значение в формате \fIпараметр\fP = \fIзначение\fP. Значение можно помещать в
двойные или одинарные кавычки. Строки комментария должны иметь знак фунта
(#) в начале строки.

Команды \fBdeluser(8)\fP и \fBdelgroup(8)\fP также читают \fI/etc/adduser.conf,\fP
смотрите \fBadduser.conf(5);\fP настройки в \fIdeluser.conf\fP могут быть изменены
настройками из \fIadduser.conf.\fP

Действующие параметры настройки:
.TP 
\fBREMOVE_HOME\fP
Удалять домашний каталог и хранилище почты удаляемого
пользователя. Значениями могут быть 0 (не удалять) или 1 (удалять).
.TP 
\fBREMOVE_ALL_FILES\fP
Стирать все файлы в системе, принадлежащие удаляемому пользователю. Если
этот параметр включён, то \fBREMOVE_HOME\fP бесполезен. Значениями могут быть 0
или 1.
.TP 
\fBBACKUP\fP
Если \fBREMOVE_HOME\fP или \fBREMOVE_ALL_FILES\fP включены, то перед удалением
делается резервная копия всех файлов. Будет создан архивный файл с именем
имя_пользователя.tar(.gz|.bz2) в каталоге, указанном в \fBBACKUP_TO\fP. Из
возможных методов сжатия выбирается лучший. Значениями могут быть 0 или 1.
.TP 
\fBBACKUP_TO\fP
Если \fBBACKUP\fP включён, то в \fBBACKUP_TO\fP указывается каталог, куда будет
производиться резервное копирование. По умолчанию используется текущий
каталог.
.TP 
\fBNO_DEL_PATHS\fP
Список регулярных выражений разделённых пробелами. Все файлы, которые будут
удаляться в случае удаления домашнего каталога или принадлежащие
пользователю, сначала сравниваются с этими регулярными выражениями. Если
обнаруживается совпадение, то файл не удаляется. По умолчанию в список
входят системные каталоги, остаётся только /home.

Другими словами: по умолчанию только файлы внутри /home, принадлежащие
заданному пользователю, будут удаляться.

.TP 
\fBONLY_IF_EMPTY\fP
Удалять группу, только если в ней нет пользователей. По умолчанию 0.
.TP 
\fBEXCLUDE_FSTYPES\fP
Регулярное выражение, описывающее файловые системы, которые нужно исключить
из поиска при удалении файлов пользователя. По умолчанию
"(proc|sysfs|usbfs|devpts|tmpfs|afs)".

.SH ФАЙЛЫ
\fI/etc/deluser.conf\fP
.SH "СМОТРИТЕ ТАКЖЕ"
\fBadduser.conf\fP(5), \fBdelgroup\fP(8), \fBdeluser(8)\fP
