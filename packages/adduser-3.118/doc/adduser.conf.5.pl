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
.TH adduser.conf 5 "wersja VERSION" "Debian GNU/Linux" 
.SH NAZWA
/etc/adduser.conf \- plik konfiguracyjny programów \fBadduser(8)\fP i
\fBaddgroup(8)\fP.
.SH OPIS
Plik \fI/etc/adduser.conf\fP zawiera wartości domyślne dla programów
\fBadduser(8)\fP, \fBaddgroup(8)\fP, \fBdeluser(8)\fP oraz \fBdelgroup(8)\fP. Każda
linia przechowuje pojedynczą wartość w postaci \fIopcja\fP =
\fIwartość\fP. Dopuszczalne jest otaczanie wartości cudzysłowami lub
apostrofami oraz dodawanie białych znaków przed znakiem rówości i po
nim. Linie komentarza muszą zaczynać się od znaku hasha (#).

Poprawne są następujące opcje:
.TP 
\fBDSHELL\fP
Powłoka logowania dla nowych użytkowników. Wartość domyślna to \fI/bin/bash\fP.
.TP 
\fBDHOME\fP
Katalog, w którym są tworzone nowe katalogi domowe użytkowników. Wartość
domyślna to \fI/home\fP.
.TP 
\fBGROUPHOMES\fP
Ustawienie na \fIyes\fP powoduje, że katalogi domowe będą utworzone jako
\fI/home/[nazwa\-grupy]/użytkownik\fP. Wartość domyślna to \fIno\fP.
.TP 
\fBLETTERHOMES\fP
Ustawienie na \fIyes\fP powoduje, że katalogi domowe zostaną utworzone w
dodatkowym katalogu, którego nazwą jest pierwsza litera nazwy
użytkownika. Na przykład: \fI/home/u/użytkownik\fP. Wartość domyślna to \fIno\fP.
.TP 
\fBSKELL\fP
Katalog, z którego powinny być kopiowane szablonowe pliki konfiguracyjne
użytkowników. Wartość domyślna to \fI/etc/skel\fP.
.TP 
\fBFIRST_SYSTEM_UID\fP i \fBLAST_SYSTEM_UID\fP
Określają domknięty zakres identyfikatorów UID, w którym będą dynamicznie
przydzielane identyfikatory użytkowników systemowych. Wartość domyślna to
\fI100\fP \- \fI999\fP. Proszę zauważyć, że oprogramowanie systemowe, takie jak
pakiet base\-passwd, może zakładać, że użytkownicy o identyfikatorach
mniejszych niż 100 nie są przydzieleni.
.TP 
\fBFIRST_UID\fP i \fBLAST_UID\fP
Określają domknięty zakres identyfikatorów UID, w którym będą przydzielane
identyfikatory zwykłych użytkowników. Wartość domyślna to \fI1000\fP \-
\fI59999\fP.
.TP 
\fBFIRST_SYSTEM_GID\fP i \fBLAST_SYSTEM_GID\fP
Określają domknięty zakres identyfikatorów GID, w którym będą przydzielane
identyfikatory grup systemowych. Wartość domyślna to \fI100\fP \- \fI999\fP.
.TP 
\fBFIRST_GID\fP i \fBLAST_GID\fP
Określają domknięty zakres identyfikatorów GID, w którym będą przydzielane
identyfikatory zwykłych grup. Wartość domyślna to \fI1000\fP \- \fI59999\fP.
.TP 
\fBUSERGROUPS\fP
Ustawienie tej opcji na \fIyes\fP powoduje, że dla każdego tworzonego
użytkownika zostanie utworzona jego własna grupa. Jeżeli opcja jest
ustawiona na \fIno\fP, to każdy użytkownik zostanie umieszczony w grupie,
której GID jest równy \fBUSERS_GID\fP (patrz niżej).Wartość domyślna to \fIyes\fP.
.TP 
\fBUSERS_GID\fP
Jeżeli \fBUSERGROUPS\fP jest ustawione na \fIno\fP, to \fBUSERS_GID\fP jest
identyfikatorem grupy, do której będą przypisani wszyscy nowo tworzeni
użytkownicy. Wartość domyślna to \fI100\fP.
.TP 
\fBDIR_MODE\fP
Jeżeli wartość jest poprawna (np. 0755 lub 755), to tworzonym katalogom
domowym zostaną ustawione podane prawa dostępu. W przeciwnym przypadku 0755
jest używana jako wartość domyślna.
.TP 
\fBSETGID_HOME\fP
Ustawienie tej opcji na \fIyes\fP powoduje, że katalogi domowe użytkowników
posiadających własną grupę (\fIUSERGROUPS=yes\fP) będą miały ustawiony bit
setgid. Było to domyślne ustawienie programu adduser w wersji <<
3.13. Niestety miało ono swoje złe strony, dlatego nie jest już ustawiane
domyślnie. Niemniej jednak, jeżeli jest taka potrzeba, to można to aktywować
tutaj.
.TP 
\fBQUOTAUSER\fP
Jeżeli wartość tej opcji jest niepusta, to oznacza nazwę użytkownika,
którego quota będzie skopiowana nowo tworzonym użytkownikom. Wartość
domyślna jest pusta.
.TP 
\fBNAME_REGEX\fP
Nazwy użytkowników są sprawdzane tym wyrażeniem regularnym. Jeżeli nazwa nie
pasuje do wyrażenia, użytkownik lub grupa nie zostaną utworzony, chyba że
podano \-\-force\-badname. Jeżeli podano \-\-force\-badname, to są dokonywane
tylko bardzo podstawowe sprawdzenia. Wartością domyślną jest
^[a\-z][\-a\-z0\-9]*$.
.TP 
\fBSKEL_IGNORE_REGEX\fP
Z tym wyrażeniem regularnym są porównywane pliki w /etc/skel. Jeżeli pliki
te pasują do wyrażenia regularnego, to nie będą kopiowane. Domyślnie
wyrażenie to pasuje do niescalonych plików konfiguracyjnych
(dpkg\-(old|new|dist)).
.TP 
\fBADD_EXTRA_GROUPS\fP
Ustawienie tej zmiennej na cokolwiek innego niż 0 (wartość domyślna)
spowoduje, że adduser doda nowo tworzonych użytkowników niesystemowych do
grup zdefiniowanych w EXTRA_GROUPS (patrz niżej).
.TP 
\fBEXTRA_GROUPS\fP
Lista grup, do których będą dodawanie nowo tworzeni użytkownicy
niesystemowi. Domyślną wartością jest "dialout cdrom floppy audio video
plugdev users games".
.SH UWAGI
.TP 
\fBPOPRAWNE NAZWY\fP
adduser i addgrup wymuszają zgodność ze standardem EEE Std 1003.1\-2001,
który dopuszcza, by nazwy użytkowników i grup składały się tylko z
następujących znaków: litery, cyfry, podkreślenia, kropki, znaki "@" i
myślniki. Nazwy nie mogą zaczynać się od myślników. W celu zachowania
zgodności z Sambą, nazwy użytkowników mogą kończyć się znakiem "$".

Dodatkowe sprawdzenie można dostosować, aby wymusić lokalną politykę nazw,
za pomocą parametru konfiguracji NAME_REGEX.

.SH PLIKI
\fI/etc/adduser.conf\fP
.SH "ZOBACZ TAKŻE"
\fBaddgroup\fP(8), \fBadduser\fP(8), \fBdelgroup\fP(8), \fBdeluser\fP(8),
\fBdeluser.conf\fP(5)
.SH TŁUMACZENIE
Robert Luberda <robert@debian.org>, październik 2005 r.
