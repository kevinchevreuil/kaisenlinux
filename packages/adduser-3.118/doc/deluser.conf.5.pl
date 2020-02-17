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
.TH deluser.conf 5 "wersja VERSION" "Debian GNU/Linux" 
.SH NAZWA
/etc/deluser.conf \- plik konfiguracyjny programów \fBdeluser(8)\fP i
\fBdelgroup(8)\fP.
.SH OPIS
Plik \fI/etc/deluser.conf\fP zawiera domyślne wartości konfiguracji programów
\fBdeluser(8)\fP oraz \fBdelgroup(8)\fP. Każda opcja ma postać \fIopcja\fP =
\fIwartość\fP. Dozwolone jest ujmowanie wartości w apostrofy lub
cudzysłowy. Linie komentarza muszą zaczynać się od znaku hasha (#).

\fBdeluser(8)\fP i \fBdelgroup(8)\fP czytają także plik \fI/etc/adduser.conf\fP
(patrz \fBadduser.conf(5)\fP). Ustawienia w pliku \fIdeluser.conf\fP mogą
nadpisywać ustawienia z pliku \fIadduser.conf.\fP.

Poprawne są następujące opcje:
.TP 
\fBREMOVE_HOME\fP
Usuwa katalog domowy oraz plik zawierający przychodzącą pocztę
użytkownika. Wartością tej opcji może być 0 (nie usuwaj) lub 1 (usuń).
.TP 
\fBREMOVE_ALL_FILES\fP
Usuwa z systemu wszystkie pliki, których właścicielem jest usuwany
użytkownik. Jeżeli ta opcja jest aktywna, to \fBREMOVE_HOME\fP nie ma żadnego
efektu. Wartością tej opcji może być 0 lub 1.
.TP 
\fBBACKUP\fP
Jeżeli uaktywniono \fBREMOVE_HOME\fP lub \fBREMOVE_ALL_FILES\fP, to wszystkie
pliki przed usunięciem są archiwizowane. Domyślną nazwą pliku archiwum jest
nazwa\-użytkownika.tar(.gz|.bz2) w katalogu określonym w opcji
\fBBACKUP_TO\fP. Jako metodę kompresji wybiera się najlepszą spośród tych,
które są dostępne. Wartością tej opcji może być 0 lub 1.
.TP 
\fBBACKUP_TO\fP
Jeżeli uaktywniono \fBBACKUP\fP, to \fBBACKUP_TO\fP określa nazwę katalogu, w
którym są zapisywane pliki z kopiami zapasowymi. Domyślną wartością jest
katalog bieżący.
.TP 
\fBNO_DEL_PATHS\fP
Lista wyrażeń regularnych rozdzielonych spacjami. Według tych wyrażeń są
sprawdzane wszystkie pliki przeznaczone do usunięcia z powodu usuwania
katalogów domowych albo z powodu usuwania plików, których właścicielem jest
dany użytkownik. Jeżeli plik pasuje do wyrażenia, to nie jest
usuwany. Wartością domyślną jest lista katalogów systemowych, oprócz /home.

Innymi słowy: Domyślnie usuwane są tylko te pliki należące do podanego
użytkownika, które znajdują się w /home.

.TP 
\fBONLY_IF_EMPTY\fP
Usuwa grupę, tylko wtedy gdy nie należy do niej żaden użytkownik. Wartością
domyślną jest 0.
.TP 
\fBEXCLUDE_FSTYPES\fP
Wyrażenie regularne opisująca wszystkie systemy plików, które powinny być
pominięte podczas wyszukiwania plików użytkownika przeznaczonych do
usunięcia. Wartość domyślna to "(proc|sysfs|usbfs|devpts|tmpfs|afs)".

.SH PLIKI
\fI/etc/deluser.conf\fP
.SH "ZOBACZ TAKŻE"
\fBadduser.conf\fP(5), \fBdelgroup\fP(8), \fBdeluser(8)\fP
.SH TŁUMACZENIE
Robert Luberda <robert@debian.org>, październik 2005 r.
