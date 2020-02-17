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
.TH DELUSER 8 "wersja VERSION" "Debian GNU/Linux" 
.SH NAZWA
deluser, delgroup \- usuwa użytkownika lub grupę z systemu
.SH SKŁADNIA
\fBdeluser\fP [opcje] [\-\-force] [\-\-remove\-home] [\-\-remove\-all\-files] [\-\-backup]
[\-\-backup\-to KATALOG] użytkownik
.PP
\fBdeluser\fP \-\-group [opcje] grupa
.br
\fBdelgroup\fP [opcje] [\-\-only\-if\-empty] grupa
.PP
\fBdeluser\fP [opcje] użytkownik grupa
.SS "WSPÓLNE OPCJE"
.br
[\-\-quiet] [\-\-system] [\-\-help] [\-\-version] [\-\-conf PLIK]
.SH OPIS
.PP
\fBdeluser\fP i \fBdelgroup\fP usuwają użytkowników i grupy z systemu zgodnie z
opcjami wymienionymi w linii poleceń oraz konfiguracją zawartą w pliku
\fI/etc/deluser.conf\fP i \fI/etc/adduser.conf\fP. Programy te są bardziej
przyjaznymi dla użytkownika interfejsami do programów \fBuserdel\fP i
\fBgroupdel\fP, opcjonalnie usuwającymi katalog domowy użytkownika lub nawet
wszystkie pliki, których właścicielem jest usuwany użytkownik,
uruchamiającymi lokalne skrypty i mającymi inne dodatkowe
funkcje. \fBdeluser\fP i \fBdelgroup\fP mogą być użyte w jednym z trzech trybów:
.SS "Usuwanie zwykłych użytkowników"
\fBdeluser\fP, jeśli zostanie wywołany z jednym argumentem nie będącym opcją
oraz bez opcji \fB\-\-group\fP, usunie zwykłego użytkownika.

Domyślnie \fBdeluser\fP usunie użytkownika bez usuwania katalogu domowego,
pliku zawierającego przychodzącą pocztę użytkownika ani jakiegokolwiek
innego pliku w systemie, należącego do użytkownika. Usunąć katalog domowy i
pocztę użytkownika można używając opcji \fB\-\-remove\-home\fP.

Opcja \fB\-\-remove\-all\-files\fP usuwa z systemu wszystkie pliki, których
właścicielem jest usuwany użytkownik. Proszę zauważyć, że użycie opcji
\fB\-\-remove\-home\fP łącznie z tą opcją nie ma żadnego znaczenia, ponieważ opcja
\fB\-\-remove\-all\-files\fP obejmuje wszystkie pliki, łącznie z katalogiem domowym
i plikiem zawierającym pocztę użytkownika.

Aby przed usunięciem plików zrobić ich kopie zapasowe, należy użyć opcji
\fB\-\-backup\fP, która utworzy plik nazwa\-użytkownika.tar(.gz|.bz2) w katalogu
określonym przez opcję \fB\-\-backup\-to\fP (domyślnie jest to bieżący katalog
roboczy). Zarówno opcje usuwania, jak i tworzenia kopii zapasowej mogą
zostać ustawione jako domyślne w pliku konfiguracyjnym
/etc/deluser.conf. Szczegóły można znaleźć w \fBdeluser.conf(5)\fP.

Aby usunąć użytkownika root (uid 0), należy użyć opcji \fB\-\-force\fP, co może
zapobiec przypadkowemu usunięciu tego użytkownika.

Po usunięciu konta użytkownika, zostanie uruchomiony plik
\fB/usr/local/sbin/deluser.local\fP, jeżeli istnieje, w celu wykonania
lokalnych ustawień. Argumenty przekazywane do \fBdeluser.local\fP są
następujące:
.br
nazwa\-użytkownika uid gid katalog\-domowy

.SS "Usuwanie grup "
Jeżeli \fBdeluser\fP zostanie uruchomiony z opcją \fB\-\-group\fP lub jako program
\fBdelgroup\fP, to grupa zostanie usunięta.

Ostrzeżenie: Nie można usunąć podstawowej grupy istniejącego użytkownika.

Jeżeli podano opcję \fB\-\-only\-if\-empty\fP, to grupa nie zostanie usunięta,
jeżeli ma przypisanych członków.

.SS "Usuwa użytkownika z określonej grupy"
\fBdeluser\fP wywołany z dwoma argumentami nie będącymi opcjami usunie
użytkownika z podanej grupy.
.SH OPCJE
.TP 
\fB\-\-conf PLIK\fP
Użyje pliku PLIK zamiast \fI/etc/deluser.conf\fP i \fI/etc/adduser.conf\fP.
.TP 
\fB\-\-group\fP
Usuwa grupę. Jest to domyślna akcja, jeżeli program jest wywołany jako
\fIdelgroup\fP.
.TP 
\fB\-\-help\fP
Wyświetla krótką instrukcję używania programu.
.TP 
\fB\-\-quiet\fP
Program wyświetla mniej komunikatów niż zazwyczaj.
.TP 
\fB\-\-system\fP
Usuwa użytkownika/grupę tylko wtedy, gdy jest to użytkownik/grupa
systemowy/systemowa. Pozwala to uniknąć przypadkowego usunięcia
niesystemowych użytkowników/grup. Dodatkowo, jeżeli użytkownik nie istnieje,
to nie jest zwracany błąd. Ta opcja jest głównie przeznaczana do użycia w
skryptach opiekunów pakietów Debiana.
.TP 
\fB\-\-only\-if\-empty\fP
Usuń tylko, jeśli nie pozostał żaden członek.
.TP 
\fB\-\-backup\fP
Tworzy kopie zapasowe wszystkich plików znajdujących się w katalogu domowym
użytkownika do pliku o nazwie /$user.tar.bz2 lub /$user.tar.gz.
.TP 
\fB\-\-backup\-to\fP
Zamiast umieszczać pliki pliki kopii zapasowych w /, umieszcza je w katalogu
podanym jako parametr tej opcji. Ustawia opcję \-\-backup.
.TP 
\fB\-\-remove\-home\fP
Usuwa katalog domowy użytkownika i jego pocztę. Jeśli podano \-\-backup, pliki
są usuwane po utworzeniu ich kopii zapasowej.
.TP 
\fB\-\-remove\-all\-files\fP
Usuwa z systemu wszystkie pliki, których właścicielem jest ten
użytkownik. Uwaga:  w przypadku podania tej opcji, \-\-remove\-home nie będzie
miało żadnego efektu. Jeśli podano \-\-backup, pliki są usuwane po utworzeniu
ich kopii zapasowej.
.TP 
\fB\-\-version\fP
Wyświetla informację o wersji i prawach autorskich.
.SH "WARTOŚĆ ZWRACANA"
.TP 
\fB0\fP
Akcja została pomyślnie wykonana.
.TP 
\fB1\fP
Użytkownik do usunięcia nie był użytkownikiem systemowym. Nie wykonano
żadnej akcji.
.TP 
\fB2\fP
Podany użytkownik nie istnieje. Nie wykonano żadnej akcji.
.TP 
\fB3\fP
Podana grupa nie istnieje. Nie wykonano żadnej akcji.
.TP 
\fB4\fP
Błąd wewnętrzny. Nie wykonano żadnej akcji.
.TP 
\fB5\fP
Usuwana grupa nie jest pusta. Nie wykonano żadnej akcji.
.TP 
\fB6\fP
Użytkownik nie należy do podanej grupy. Nie wykonano żadnej akcji.
.TP 
\fB7\fP
Nie można usunąć użytkownika z jego podstawowej grupy. Nie wykonano żadnej
akcji.
.TP 
\fB8\fP
Nie został zainstalowany pakiet "perl", który jest wymagany do
przeprowadzenia żądanych akcji. Nie wykonano żadnej akcji.
.TP 
\fB9\fP
Aby usunąć konto użytkownika root, wymagane jest podanie opcji
"\-\-force". Nie wykonano żadnej akcji.

.SH PLIKI
\fI/etc/deluser.conf\fP Default configuration file for deluser and delgroup
.TP 
\fI/usr/local/sbin/deluser.local\fP
Opcjonalne dodatki.

.SH "ZOBACZ TAKŻE"
\fBadduser\fP(8), \fBdeluser.conf\fP(5), \fBgroupdel\fP(8), \fBuserdel\fP(8)

.SH TŁUMACZENIE
Robert Luberda <robert@debian.org>, październik 2005 r.
.SH "PRAWA AUTORSKIE"
Copyright (C) 2000 Roland Bauerschmidt. Modyfikacje (C) 2004 Marc Haber i
Joerg Hoh. Ta strona podręcznika oraz program deluser opierają się na
adduser, którego prawa autorskie są następujące:
.br
Copyright (C) 1997, 1998, 1999 Guy Maor. Modyfikowany przez Rolanda
Bauerschmidta i Marca Habera.
.br
Copyright (C) 1995 Ted Hajek, z dużym wkładem oryginalnego programu
\fBadduser\fP z Debiana.
.br
Copyright (C) 1994 Ian Murdock. \fBdeluser\fP jest wolnym oprogramowaniem,
warunki licencji \- patrz GNU General Public Licence w wersji 2 lub
wyższej. Nie ma \fIżadnych\fP gwarancji.
