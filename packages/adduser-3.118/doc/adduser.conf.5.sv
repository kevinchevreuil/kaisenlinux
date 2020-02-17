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
.TH adduser.conf 5 "Version VERSION" "Debian GNU/Linux" 
.SH NAMN
/etc/adduser.conf \- konfigurationsfil för \fBadduser(8)\fP och \fBaddgroup(8)\fP.
.SH BESKRIVNING
Filen \fI/etc/adduser.conf\fP innehåller standardvärden för programmen
\fBadduser(8)\fP , \fBaddgroup(8)\fP , \fBdeluser(8)\fP och \fBdelgroup(8)\fP.  Varje
rad innehåller ett enstaka värdespar i formatet \fIflagga\fP =
\fIvärde\fP. Citattecken eller apostrofer är tillåtna runt värdet såväl som
mellanslag runt likamed\-tecknet.  Kommentarsrader måste påbörjas med ett
#\-tecken som första tecken.

Giltiga konfigurationsflaggor är:
.TP 
\fBDSHELL\fP
Inloggningsskalet som ska användas för alla nya användare. Standardvärdet är
satt till \fI/bin/bash\fP.
.TP 
\fBDHOME\fP
Katalogen i vilken nya hemkataloger ska skapas i.  Standardvärde är
\fI/home\fP.
.TP 
\fBGROUPHOMES\fP
Om denna är satt till \fIyes\fP kommer hemkataloger att skapas som
\fI/home/[gruppnamn]/användare\fP.  Standardvärde är \fIno\fP.
.TP 
\fBLETTERHOMES\fP
Om denna är satt till \fIyes\fP kommer hemkataloger som skapas att ha en extra
katalog inlagd som är första bokstaven för inloggningsnamnet.  Till exempel:
\fI/home/a/användare\fP.  Standardvärde är \fIno\fP.
.TP 
\fBSKEL\fP
Katalogen från vilken skelettkonfigurationsfiler för användare ska kopias.
Standardvärde är \fI/etc/skel\fP.
.TP 
\fBFIRST_SYSTEM_UID\fP och \fBLAST_SYSTEM_UID\fP
ange ett intervall av UID från vilka system UID dynamiskt kan allokeras
från. Standardvärdet är \fI100\fP \- \fI999\fP. Observera att systemmjukvara,
exempelvis användare som allokeras av paketet base\-passwd, kan anta att UID
med lägre värde än 100 är oallokerade.
.TP 
\fBFIRST_UID\fP och \fBLAST_UID\fP
ange ett intervall av uid från vilka vanliga användares uid dynamiskt kan
allokeras från. Standardvärdet är \fI1000\fP \- \fI59999\fP.
.TP 
\fBFIRST_SYSTEM_GID\fP och \fBLAST_SYSTEM_GID\fP
ange ett intervall av GID från vilka system GID dynamiskt kan allokeras
från. Standardvärdet är \fI100\fP \- \fI999\fP.
.TP 
\fBFIRST_GID\fP och \fBLAST_GID\fP
ange ett intervall av GID från vilka vanliga användares GID dynamiskt kan
allokeras från. Standardvärdet är \fI1000\fP \- \fI59999\fP.
.TP 
\fBUSERGROUPS\fP
Om denna är satt till \fIyes\fP kommer varje skapad användare att ges sin egna
grupp att använda. Om denna är \fIno\fP kommer varje skapad användare att
placeras i gruppen vars gid är \fBUSERS_GID\fP (se nedan).  Standardvärdet är
\fIyes\fP.
.TP 
\fBUSERS_GID\fP
Om \fBUSERGROUPS\fP är \fIno\fP, så är \fBUSERS_GID\fP det GID som angivs för alla
användare som skapas.  Standardvärdet är \fI100\fP.
.TP 
\fBDIR_MODE\fP
Om satt till ett giltigt värde (exempelvis 0755 eller 755) kommer kataloger
som skapas att ha den angivna rättigheten satt som umask. Om inte kommer
0755 att användas som standardvärde.
.TP 
\fBSETGID_HOME\fP
Om denna är satt till \fIyes\fP kommer hemkataloger för användare med sin egna
grupp ( \fIUSERGROUPS=yes\fP ) att ha setgid\-biten satt. Detta var
standardinställningen för adduser version << 3.13. Tyvärr har det
några nackdelar så vi gör inte det längre som standard. Om du vill ha det
oavsett kan du fortfarande aktivera det här.
.TP 
\fBQUOTAUSER\fP
Om satt till ett icke\-tomt värde kommer nya användare att få diskkvoten
kopierad från den användare.  Standardvärde är tom.
.TP 
\fBNAME_REGEX\fP
Namn på användare och grupper kontrolleras mot detta reguljära uttryck. Om
namnet inte matchar detta reguljära uttryck kommer skapandet att vägras om
inte \-\-force\-badname är satt. Med \-\-force\-badname satt kommer bara svaga
kontroller att utföras. Standardvärdet är det mest konservativa
^[a\-z][\-a\-z0\-9]*$.
.TP 
\fBSKEL_IGNORE_REGEX\fP
Filer under /etc/skel/ kontrolleras mot detta reguljära uttryck och kopieras
inte till den nyligen skapade hemkatalogen om de matchar.  Detta är som
standard inställt till ett reguljärt uttryck som matchar filer som lämnats
kvar av gamla konfigurationsfiler (dpkg\-(old|new|dist)).
.TP 
\fBADD_EXTRA_GROUPS\fP
Ställ in detta till något annat än 0 (standard) kommer att orsaka att
adduser lägger till nyligen skapade icke\-systemanvändare till listan av
grupper som definierats av EXTRA_GROUPS (nedan).
.TP 
\fBEXTRA_GROUPS\fP
This is the list of groups that new non\-system users will be added to.  By
default, this list is 'dialout cdrom floppy audio video plugdev users
games'.
.SH ANTECKNINGAR
.TP 
\fBVALID NAMES\fP
adduser och addgroup tvingar anpassning till IEEE standrd 1003.1\-2001 som
endast tillåter följande tecken att ingå i namnet för en grupp eller
användare: bokstäver, sifforer, underscore, punkter, snabel\-a och
talstreck. Namnet får inte börja med ett talstreck. "$"\-tecken är tillåtet i
slutet av användarnamn (för att överrensstämma med samba).

Ytterligare kontroll kan justeras via inställningsparametern NAME_REGEX för
att lägga till en lokal policy.

.SH FILER
\fI/etc/adduser.conf\fP
.SH "SE OCKSÅ"
\fBaddgroup\fP(8), \fBadduser\fP(8), \fBdelgroup\fP(8), \fBdeluser\fP(8),
\fBdeluser.conf\fP(5)
.SH ÖVERSÄTTARE
Denna manualsida har översatts av Daniel Nylander <po@danielnylander.se> 
den 25 november 2005.

Om du hittar några felaktigheter i översättningen, vänligen skicka ett 
e-postmeddelande till översättaren eller till sändlistan
.nh
<\fIdebian\-l10n\-swedish@lists.debian.org\fR>,
.hy

