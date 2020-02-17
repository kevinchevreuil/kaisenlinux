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
.TH ADDUSER 8 "Version VERSION" "Debian GNU/Linux" 
.SH NAMN
adduser, addgroup \- lägg till en användare eller grupp till systemet
.SH SYNOPSIS
\fBadduser\fP [flaggor] [\-\-home KATALOG] [\-\-shell SKAL] [\-\-no\-create\-home]
[\-\-uid ID] [\-\-firstuid ID] [\-\-lastuid ID] [\-\-ingroup GRUPP | \-\-gid ID]
[\-\-disabled\-password] [\-\-disabled\-login] [\-\-gecos GECOS]
[\-\-add_extra_groups] användare
.PP
\fBadduser\fP \-\-system [flaggor] [\-\-home KATALOG] [\-\-shell SKAL]
[\-\-no\-create\-home] [\-\-uid ID] [\-\-group | \-\-ingroup GRUPP | \-\-gid ID]
[\-\-disabled\-password] [\-\-disabled\-login] [\-\-gecos GECOS] användare
.PP
\fBaddgroup\fP [flaggor] [\-\-gid ID] grupp
.PP
\fBaddgroup\fP \-\-system [flaggor] [\-\-gid ID] grupp
.PP
\fBadduser\fP [flaggor] användare grupp
.SS "VANLIGA FLAGGOR"
.br
[\-\-quiet] [\-\-debug] [\-\-force\-badname] [\-\-help|\-h] [\-\-version] [\-\-conf FIL]
.SH BESKRIVNING
.PP
\fBadduser\fP och \fBaddgroup\fP lägger till användare och grupper till systemet
enligt kommandoradens flaggor och konfigurationsinformation i
\fI/etc/adduser.conf\fP.  De är vänliga gränssnitt till lågnivåverktyg som
\fBuseradd,\fP \fBgroupadd\fP och \fBusermod\fP, väljer som standard giltiga värden
för UID och GID enligt Debians policy, skapar hemkatalogeer med
skelettkonfiguration, kör egendefinierade skript och andra
funktioner. \fBadduser\fP och \fBaddgroup\fP kan köras i ett av fem lägen:
.SS "Lägg till en vanlig användare"
Om startad med ett icke\-flagga\-argument och utan flaggan \fB\-\-system\fP eller
\fB\-\-group\fP kommer \fBadduser\fP att lägga till en vanlig användare.

\fBadduser\fP kommer att välja det första tillgängliga uid från intervallet som
angivits för vanliga användare i konfigurationsfilen.  Uid kan åsidosättas
med flaggan \fB\-\-uid\fP.

Intervallet som anges i konfigurationsfilen kan åsidosättas med flaggorna
\fB\-\-firstuid\fP och \fB\-\-lastuid\fP

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

\fBadduser\fP kommer att skapa en hemkatalog enligt \fBDHOME\fP, \fBGROUPHOMES\fP och
\fBLETTERHOMES\fP.  Hemkatalogen kan köras över från kommandoraden med flaggan
\fB\-\-home\fP och skalet med flaggan \fB\-\-shell\fP. Hemkatalogers setgid\-bit är
satt om  \fBUSERGROUPS\fP är \fIyes\fP så att alla filer som skapas i användarens
hemkatalog kommer att ha den korrekta gruppen.

\fBadduser\fP kommer att kopiera filer från \fBSKEL\fP till hemkatalogen och fråga
efter fingerinformation (gecos) och ett lösenord.  Gecos kan också ställas
in med flaggan \fB\-\-gecos\fP.  Med flaggan \fB\-\-disabled\-login\fP kommer kontot
att skapas men inaktiveras tills ett lösenord är satt.  Flaggan
\fB\-\-disabled\-password\fP kommer inte att sätta ett lösenord men inloggning är
fortfarande möjlig (till exempel genom SSH RSA\-nycklar).

Om filen \fB/usr/local/sbin/adduser.local\fP existerar kommer den att startas
efter att användarens konto har blivit uppsatt för att göra vissa lokala
inställningar.  Argumenten som skickas till \fBadduser.local\fP är:
.br
användarnamn uid gid hemkatalog
.br
Miljövariabeln VERBOSE ställs in enligt följande regel:
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

.SS "Lägg till en systemanvändare"
If called with one non\-option argument and the \fB\-\-system\fP option,
\fBadduser\fP will add a system user. If a user with the same name already
exists in the system uid range (or, if the uid is specified, if a user with
that uid already exists), adduser will exit with a warning. This warning can
be suppressed by adding \fB\-\-quiet\fP.

\fBadduser\fP kommer att välja det första tillgängliga UID:t från intervallet
som angivits för systemanvändare i konfigurationsfilen (FIRST_SYSTEM_UID och
LAST_SYSTEM_UID). För att sätta ett särskilt UID kan flaggan \fB\-\-uid\fP
användas.

Som standard placeras systemanvändare i gruppen \fBnogroup\fP.  För att placera
den nya systemanvändaren i en redan existerande grupp kan flaggorna \fB\-\-gid\fP
eller \fB\-\-ingroup\fP användas.  För att placera den nya systemanvändaren i en
ny grupp med samma ID, använd flaggan \fB\-\-group\fP.

En hemkatalog skapas med samma regler som för vanliga användare.  Den nya
systemanvändaren kommer att ha skalet \fI/usr/sbin/nologin\fP (om den inte
åsidosätts med flaggan \fB\-\-shell\fP) och ha möjligheten för inloggning
avstängd.  Skelettkonfigurationsfiler kopieras inte.
.SS "Lägg till en användargrupp"
Om \fBadduser\fP kallas upp med flaggan \fB\-\-group\fP och utan flaggan \fB\-\-system\fP
eller om \fBaddgroup\fP kallas upp respektive kommer en användargrupp att
läggas till.


Ett GID kommer att väljas från intervallet som angivits för system
GID\-nummer i konfigurationsfilen (FIRST_GID, LAST_GID). För att åsidosätta
detta kan gid anges med flaggan \fB\-\-gid\fP.

Gruppen skapas utan några användare.
.SS "Lägg till en systemgrupp"
Om \fBaddgroup\fP kallas upp med flaggan \fB\-\-system\fP kommer en systemgrupp att
läggas till.

Ett GID kommer att väljas från intervallet som angivits för systemets
gid\-nummer i konfigurationsfilen.  Gid kan åsidosättas med flaggan \fB\-\-gid\fP.

Gruppen skapas utan några användare.
.SS "Lägg till en existerande användare till en existerande grupp"
Om startad med två icke\-flaggor\-argument kommer \fBadduser\fP att lägga till en
existerande användare till en existerande grupp.
.SH FLAGGOR
.TP 
\fB\-\-conf FIL\fP
Använd FIL istället för \fI/etc/adduser.conf\fP.
.TP 
\fB\-\-disabled\-login\fP
Kör inte passwd för att ställa in lösenordet.  Användaren kommer inte att
kunna använda sitt konto tills lösenordet är inställt.
.TP 
\fB\-\-disabled\-password\fP
Liknande \-\-disabled\-login men inloggningar är fortfarande möjliga (till
exempel genom SSH RSA\-nycklar) men inte med lösenordautentisering.
.TP 
\fB\-\-force\-badname\fP
By default, user and group names are checked against the configurable
regular expression \fBNAME_REGEX\fP specified in the configuration file. This
option forces \fBadduser\fP and \fBaddgroup\fP to apply only a weak check for
validity of the name.  \fBNAME_REGEX\fP is described in \fBadduser.conf\fP(5).
.TP 
\fB\-\-gecos GECOS\fP
Ställer in gecos\-fältet för den nya genererade posten. \fBadduser\fP kommer
inte att fråga efter finger\-information om denna flagga anges.
.TP 
\fB\-\-gid ID\fP
När en grupp skapas tvingar denna flagga den nya gid att vara det angivna
numret.  När en användare skapas kommer denna flagga att sätta användaren i
den gruppen.
.TP 
\fB\-\-group\fP
När kombinerad med \fB\-\-system\fP kommer en grupp med samma namn och ID som
systemanvändaren att skapas. Om den inte kombineras med \fB\-\-system\fP kommer
en grupp med angivet namn att skapas. Detta är standardåtgärden om
programmet startas som \fBaddgroup\fP.
.TP 
\fB\-\-help\fP
Visa korta instruktioner.
.TP 
\fB\-\-home KATALOG\fP
Använd KATALOG som användarens hemkatalog hellre än det förvalda i
konfigurationsfilen. Om katalogen inte existerar kommer den skapas och
skelettfiler kopieras dit.
.TP 
\fB\-\-shell SKAL\fP
Använd SKAL som användarens inloggningsskal hellre än det förvalda i
konfigurationsfilen.
.TP 
\fB\-\-ingroup GRUPP\fP
Add the new user to GROUP instead of a usergroup or the default group
defined by \fBUSERS_GID\fP in the configuration file.  This affects the users
primary group.  To add additional groups, see the \fBadd_extra_groups\fP
option.
.TP 
\fB\-\-no\-create\-home\fP
Skapa inte hemkatalogen även om den inte existerar.
.TP 
\fB\-\-quiet\fP
Visa inte informativa meddelanden, visa endast varningar och fel.
.TP 
\fB\-\-debug\fP
Var informativ, mycket användbar om du vill hitta problem med adduser.
.TP 
\fB\-\-system\fP
Skapa en systemanvändare eller \-grupp.
.TP 
\fB\-\-uid ID\fP
Tvinga det nya användar\-id:t att vara angivet nummer. \fBadduser\fP kommer att
misslyckas om användar\-id:t redan används.
.TP 
\fB\-\-firstuid ID\fP
Åsidosätt det första uid i intervallet som uid väljs från (åsidosätter
\fBFIRST_UID\fP som specifieras i instälningsfilen).
.TP 
\fB\-\-lastuid ID\fP
Åsidosätt det sista uid i intervallet som uid väljs från (\fBLAST_UID\fP).
.TP 
\fB\-\-add_extra_groups\fP
Lägg till nya användare till extragrupper definierade i inställningsfilen.
.TP 
\fB\-\-version\fP
Visa version och information om copyright.

.SH RETURVÄRDEN

.TP 
\fB0\fP
Användaren som angavs existerar redan. Detta kan härledas till två
anledningar: Användaren skapades av adduser eller fanns redan på systemet
före exekveringen av adduser. Om adduser returnerade 0 kommer en körning av
adduser en andra gång med samma flaggor också att returnera 0.
.TP 
\fB1\fP
Skapandet av användaren eller gruppen misslyckades eftersom det redan fanns
med ett annat UID/GID än det som angavs. Användarnamnet eller gruppnamnet
avvisades eftersom det inte överrensstämde med det angivna reguljära
uttrycket, läs adduser.conf(5). Adduser avbröts av en signal.
.br
Eller för att många andra ännu så länge odokumenterade anledningar skrivs ut
på konsollen. Du kan då överväga att ta bort \fB\-\-quiet\fP för att göra adduser
mer pratig.

.SH FILER
.TP  
/etc/adduser.conf
Standard konfigurationsfil för adduser och addgroup
.TP 
/usr/local/sbin/adduser.local
Optional custom add\-ons.

.SH "SE OCKSÅ"
\fBadduser.conf\fP(5), \fBdeluser\fP(8), \fBgroupadd\fP(8), \fBuseradd\fP(8),
\fBusermod\fP(8), Debian Policy 9.2.2.

.SH ÖVERSÄTTARE
Denna manualsida har översatts av Daniel Nylander <po@danielnylander.se> 
den 25 november 2005.

Om du hittar några felaktigheter i översättningen, vänligen skicka ett 
e-postmeddelande till översättaren eller till sändlistan
.nh
<\fIdebian\-l10n\-swedish@lists.debian.org\fR>,
.hy

.SH COPYRIGHT
Copyright (C) 1997, 1998, 1999 Guy Maor. Modifieringar av Roland
Bauerschmidt och Marc Haber. Ytterligare ändringar av Joerg Hoh och Stephen
Gran.
.br
Copyright (C) 1995 Ted Hajek, med en hel del lånat från ursprungliga Debian
\fBadduser\fP
.br
Copyright (C) 1994 Ian Murdock.  \fBadduser\fP är fri programvara; se GNU
General Public Licence version 2 eller senare för villkor för kopiering.
Det finns \fIingen\fP garanti.
