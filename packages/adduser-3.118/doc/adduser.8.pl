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
.TH ADDUSER 8 "wersja VERSION" "Debian GNU/Linux" 
.SH NAZWA
adduser, addgroup \- dodaje użytkownika lub grupę do systemu
.SH SKŁADNIA
\fBadduser\fP [opcje] [\-\-home KATALOG] [\-\-shell PROWŁOKA] [\-\-no\-create\-home]
[\-\-uid ID] [\-\-firstuid ID] [\-\-lastuid ID] [\-\-ingroup GRUPA | \-\-gid ID]
[\-\-disabled\-password] [\-\-disabled\-login] [\-\-gecos GECOS]
[\-\-add_extra_groups] użytkownik
.PP
\fBadduser\fP \-\-system [opcje] [\-\-home KATALOG] [\-\-shell POWŁOKA]
[\-\-no\-create\-home] [\-\-uid ID] [\-\-group | \-\-ingroup GRUPA | \-\-gid ID]
[\-\-disabled\-password] [\-\-disabled\-login] [\-\-gecos GECOS] użytkownik
.PP
\fBaddgroup\fP [opcje] [\-\-gid ID] grupa
.PP
\fBaddgroup\fP \-\-system [opcje] [\-\-gid ID] grupa
.PP
\fBadduser\fP [opcje] użytkownik grupa
.SS "WSPÓLNE OPCJE"
.br
[\-\-quiet] [\-\-debug] [\-\-force\-badname] [\-\-help|\-h] [\-\-version] [\-\-conf PLIK]
.SH OPIS
.PP
\fBadduser\fP i \fBaddgroup\fP dodają użytkowników i grupy do systemu zgodnie z
opcjami wymienionymi w linii poleceń oraz konfiguracją zawartą w pliku
\fI/etc/adduser.conf\fP. Programy te są bardziej przyjaznymi dla użytkownika
interfejsami do programów \fBuseradd\fP, \fBgroupadd\fP i \fBusermod\fP wybierającymi
zgodne ze standardami Debiana wartości identyfikatora użytkownika (UID) i
identyfikatora grupy (GID), tworzącymi katalogi domowe, uruchamiającymi
lokalne skrypty i mającymi inne dodatkowe funkcje. \fBadduser\fP i \fBaddgroup\fP
mogą być użyte w jednym z pięciu trybów:
.SS "Dodawanie zwykłych użytkowników"
\fBadduser\fP, wywołany z jednym argumentem nie będącym opcją oraz bez opcji
\fB\-\-system\fP lub \fB\-\-group\fP, doda zwykłego użytkownika.

\fBadduser\fP wybierze pierwszy możliwy UID z zakresu przeznaczonego dla
zwykłych użytkowników w pliku konfiguracyjnym. Ten UID może zostać nadpisany
za pomocą opcji \fB\-\-uid\fP.

Zakres określony w pliku konfiguracyjnym również może zostać nadpisany
opcjami \fB\-\-firstuid\fP i \fB\-\-lastuid\fP.

Domyślnie każdemu użytkownikowi w systemie Debian GNU/Linux zostaje
przypisana grupa mająca tę samą nazwę i identyfikator, co
użytkownik. Umieszczanie każdego użytkownika w grupie o tej samej nazwie
pozwala na łatwe zarządzanie katalogami dostępnymi do zapisu dla grupy
poprzez dodanie odpowiednich użytkowników do nowej grupy, ustawienie flagi
set\-group\-ID na katalogu i ustawienie każdemu użytkownikowi wartości umask
równej 002. Jeżeli ta opcja zostanie wyłączona przez ustawienie
\fBUSERGROUPS\fP na \fIno\fP, wszyscy nowo tworzeni użytkownicy będą mieli
identyfikator grupy ustawiony na \fBUSERS_GID\fP. Podstawowe grupy użytkowników
mogą zostać również nadpisane przez podanie w linii poleceń opcji \fB\-\-gid\fP
lub \fB\-\-ingroup\fP, które ustawiają grupę przez podanie, odpowiednio, jej id
lub nazwy. Ponadto użytkowników można dodać do jednej lub większej liczby
grup zdefiniowanych w adduser.conf albo przez ustawienie ADD_EXTRA_GROUPS na
1 w adduser.conf, albo przez podanie opcji linii poleceń
\fB\-\-add_extra_groups\fP.

\fBadduser\fP utworzy katalog domowy użytkownika zgodnie z ustawieniami
\fBDHOME\fP, \fBGROUPHOMES\fP, \fBLETTERHOMES\fP w pliku konfiguracyjnym. Katalog
domowy może zostać nadpisany przez opcję linii poleceń \fB\-\-home\fP, a powłoka
\- przez opcję \fB\-\-shell\fP. Jeżeli \fBUSERGROUPS\fP jest ustawione na \fIyes\fP, to
katalogowi domowemu użytkownika zostanie nadany bit set\-group\-ID, co
powoduje, że jakikolwiek plik utworzony w tym katalogu będzie miał
przydzieloną właściwą grupę.

\fBadduser\fP skopiuje pliki z katalogu \fBSKEL\fP do katalogu domowego
użytkownika, poprosi o dane użytkownika (GECOS) oraz o hasło. Dane
użytkownika mogą być także ustawione opcją \fB\-\-gecos\fP. Podanie opcji
\fB\-\-disabled\-login\fP spowoduje utworzenie konta użytkownika, które będzie
niedostępne (zablokowane), dopóki nie zostanie ustawione hasło. Opcja
\fB\-\-disabled\-password\fP nie ustawi hasła, ale dostęp użytkownika do systemu
będzie możliwy (na przykład przez użycie programu SSH z kluczami RSA).

Po utworzeniu i ustawieniu konta użytkownika, jeżeli istnieje plik
\fB/usr/local/sbin/adduser.local\fP, to zostanie on uruchomiony w celu
wykonania lokalnych ustawień. Argumenty przekazywane do \fBadduser.local\fP są
następujące:
.br
nazwa\-użytkownika uid gid katalog\-domowy
.br
Zmienna środowiskowa VERBOSE jest ustawiana na:
.TP  
0 jeśli 
podano opcję \fB\-\-quiet\fP
.TP  
1 jeśli nie 
podano żadnej z opcji \fB\-\-quiet\fP i \fB\-\-debug\fP
.TP  
2 jeśli 
podano opcję \fB\-\-debug\fP

(To samo dotyczy zmiennej DEBUG, jednak ta zmienna jest przestarzała i
zostanie usunięta w którejś z przyszłych wersji programu \fBadduser\fP.)

.SS "Dodawanie użytkowników systemowych"
\fBadduser\fP, gdy zostanie uruchomiony z jednym argumentem, nie będącym opcją,
oraz z opcją \fB\-\-system\fP, doda użytkownika systemowego. Jeżeli taki
użytkownik z identyfikatorem użytkownika (uid) mieszczącym się w zakresie
identyfikatorów użytkowników systemowych (lub jeżeli uid jest podany w linii
poleceń, to z tym identyfikatorem) już istnieje, adduser wyświetli
ostrzeżenie i zakończy działanie. Ostrzeżenie to można wyłączyć, używając
opcji \fB\-\-quiet\fP.

\fBadduser\fP wybierze pierwszy możliwy UID z zakresu identyfikatorów
systemowych określonych w pliku konfiguracyjnym (FIRST_SYSTEM_UID
iLAST_SYSTEM_UID). Aby podać ściśle określony UID, należy użyć opcji
\fB\-\-uid\fP.

Domyślnie użytkownicy systemowi mają przypisaną grupę \fBnogroup\fP. Aby
przypisać nowego użytkownika systemowego do istniejącej grupy, należy użyć
opcji \fB\-\-gid\fP lub \fB\-\-ingroup\fP. Aby nowemu użytkownikowi systemowemu
została przypisana nowa grupa z tym samym identyfikatorem, trzeba użyć opcji
\fB\-\-group\fP.

Katalog domowy jest tworzony zgodnie z tymi samymi zasadami, co dla zwykłych
użytkowników. Nowy użytkownik systemowy będzie miał powłokę
\fI/usr/sbin/nologin\fP (chyba że zostanie to nadpisane opcją \fB\-\-shell\fP) oraz
wyłączone hasło. Pliki z katalogu \fBSKEL\fP nie zostaną skopiowane.
.SS "Dodawanie zwykłych grup"
Jeżeli \fBadduser\fP zostanie uruchomiony z opcją \fB\-\-group\fP, ale bez opcji
\fB\-\-system\fP, lub jako program \fBaddgroup\fP, to zostanie dodana grupa dla
zwykłych użytkowników.


Grupie zostanie nadany identyfikator (GID) z zakresu określonego w pliku
konfiguracyjnym dla identyfikatorów zwykłych grup (FIRST_GID, LAST_GID),
jednakże może zostać nadpisany opcją \fB\-\-gid\fP.

Utworzenie grupy nie powoduje przypisania do niej żadnych użytkowników.
.SS "Dodawanie grup systemowych"
Jeżeli \fBaddgroup\fP zostanie wywołany z opcją \fB\-\-system\fP, to będzie
utworzona nowa grupa systemowa.

Grupie zostanie nadany identyfikator (GID) z zakresu określonego w pliku
konfiguracyjnym dla identyfikatorów użytkowników systemowych
(FIRST_SYSTEM_GID, LAST_SYSTEM_GID), jednakże może zostać nadpisany opcją
\fB\-\-gid\fP.

Utworzenie grupy nie powoduje przypisania do niej żadnych użytkowników.
.SS "Przydzielanie istniejącego użytkownika do istniejącej grupy"
\fBadduser\fP wywołany z dwoma argumentami nie będącymi opcjami doda
istniejącego użytkownika do istniejącej grupy.
.SH OPCJE
.TP 
\fB\-\-conf PLIK\fP
Użyje pliku PLIK zamiast \fI/etc/adduser.conf\fP.
.TP 
\fB\-\-disabled\-login\fP
Nie uruchamia programu passwd do ustanowienia hasła. Użytkownik nie będzie
mógł używać swojego konta, dopóki hasło nie zostanie nadane.
.TP 
\fB\-\-disabled\-password\fP
Jak \-\-disabled\-login, ale dostęp użytkownika do systemu będzie wciąż możliwy
(na przykład przez użycie kluczy SSH RSA), ale bez autoryzacji za pomocą
hasła.
.TP 
\fB\-\-force\-badname\fP
Domyślnie nazwy użytkowników i grup są walidowane względem konfigurowalnego
wyrażenia regularnego \fBNAME_REGEX\fP podanego w pliki konfiguracyjnym. Użycie
tej opcji spowoduje, że \fBadduser\fP i \fBaddgroup\fP będą mniej restrykcyjne w
odniesieniu do tych nazw. \fBNAME_REGEX\fP jest opisane w \fBadduser.conf\fP(5).
.TP 
\fB\-\-gecos GECOS\fP
Ustawia pole z informacjami GECOS dla nowego użytkownika. Jeśli ta opcja
jest użyta, to \fBadduser\fP nie będzie prosił o podanie tych informacji.
.TP 
\fB\-\-gid ID\fP
Przy tworzeniu nowej grupy, ta opcja ustawia identyfikator grupy na podaną
wartość. Przy tworzeniu użytkownika, użycie tej opcji spowoduje umieszczenie
użytkownika w zadanej grupie.
.TP 
\fB\-\-group\fP
Użyte razem z \fB\-\-system\fP, spowoduje utworzenie grupy o takiej samej nazwie
i identyfikatorze, jak nowo tworzony użytkownik systemowy. Jeżeli nie
zostanie użyte razem z opcją \fB\-\-system\fP, to zostanie utworzone grupa o
podanej nazwie. Ta opcja jest opcją domyślną, jeżeli program został wywołany
jako \fBaddgroup\fP.
.TP 
\fB\-\-help\fP
Wyświetla krótką instrukcję używania programu.
.TP 
\fB\-\-home KATALOG\fP
Używa katalogu KATALOG jako katalogu domowego użytkownika, nadpisując tym
samym domyślną wartość określoną w pliku konfiguracyjnym. Jeżeli ten katalog
nie istnieje, to będzie utworzony i zostaną skopiowane pliki z katalogu
\fISKEL\fP.
.TP 
\fB\-\-shell POWŁOKA\fP
Ustawia POWŁOKĘ jako powłokę logowania użytkownika, nadpisując domyślną
wartość określoną w pliku konfiguracyjnym.
.TP 
\fB\-\-ingroup GRUPA\fP
Umieszcza nowego użytkownika w grupie GRUPA, zamiast w grupie określonej
przez opcję \fBUSERS_GID\fP w pliku adduser.conf. Dotyczy to tylko podstawowej
grupy użytkownika. Aby dodać użytkownika do dodatkowych grup, prosimy
zobaczyć opis opcji \fBadd_extra_groups\fP.
.TP 
\fB\-\-no\-create\-home\fP
Nie tworzy katalogu domowego, nawet jeżeli on nie istnieje.
.TP 
\fB\-\-quiet\fP
Pomija informacje, pokazuje tylko ostrzeżenia i błędy.
.TP 
\fB\-\-debug\fP
Tryb gadatliwy, przydatny w czasie rozwiązywania problemów w programie
adduser.
.TP 
\fB\-\-system\fP
Tworzy użytkownika systemowego lub grupę systemową.
.TP 
\fB\-\-uid ID\fP
Ustawia identyfikator nowego użytkownika na podaną wartość. \fBadduser\fP
zakończy się błędem, jeżeli taki identyfikator jest już zajęty.
.TP 
\fB\-\-firstuid ID\fP
Nadpisuje wartość pierwszego dostępnego identyfikatora użytkownika
(nadpisuje \fBFIRST_UID\fP podany w pliku konfiguracyjnym).
.TP 
\fB\-\-lastuid ID\fP
Nadpisuje wartość pierwszego ostatniego identyfikatora użytkownika
(\fBLAST_UID\fP).
.TP 
\fB\-\-add_extra_groups\fP
Dodaje nowego użytkownika do grup dodatkowych zdefiniowanych w pliku
konfiguracyjnym.
.TP 
\fB\-\-version\fP
Wyświetla informację o wersji i prawach autorskich.

.SH "WARTOŚCI ZWRACANE"

.TP 
\fB0\fP
Podany użytkownik istnieje \- albo został utworzony przez adduser, albo
istniał w systemie przed wywołaniem adduder. Jeżeli adduser zwrócił 0, to
uruchomienie programu adduser po raz drugi z tymi samymi parametrami także
zwróci 0.
.TP 
\fB1\fP
Tworzenie użytkownika lub grupy nie powiodło się, ponieważ użytkownik bądź
grupa już istniały z innym identyfikatorem UID/GID niż podany. Nazwa
użytkownika lub grupy została odrzucona ponieważ nie pasowała do
skonfigurowanego wyrażenia regularnego, patrz adduser.conf(5). Adduser
został zabity sygnałem.
.br
Albo z wielu innych jeszcze nieudokumentowanych przyczyn, które w takim
wypadku są wypisywane na konsoli \- można rozważyć niepodawanie opcji
\fB\-\-quiet\fP, aby adduser wypisał więcej informacji.

.SH PLIKI
.TP  
/etc/adduser.conf
Domyślny plik konfiguracyjny programów adduser i addgroup.
.TP 
/usr/local/sbin/adduser.local
Opcjonalne dodatki.

.SH "ZOBACZ TAKŻE"
\fBadduser.conf\fP(5), \fBdeluser\fP(8), \fBgroupadd\fP(8), \fBuseradd\fP(8),
\fBusermod\fP(8), punkt 9.2.2 dokumentu Debian Policy.

.SH TŁUMACZENIE
Robert Luberda <robert@debian.org>, październik 2005 r.
.SH "PRAWA AUTORSKIE"
Copyright (C) 1997, 1998, 1999 Guy Maor. Modyfikowany przez Rolanda
Bauerschmidta i Marca Habera. Dodatkowe łaty autorstwa Joerga Hoha i
Stephena Grana.
.br
Copyright (C) 1995 Ted Hajek, z dużym wkładem oryginalnego programu
\fBadduser\fP z Debiana.
.br
Copyright (C) 1994 Ian Murdock. \fBadduser\fP jest wolnym oprogramowaniem,
warunki licencji \- patrz GNU General Public Licence w wersji 2 lub
wyższej. Nie ma \fIżadnych\fP gwarancji.
