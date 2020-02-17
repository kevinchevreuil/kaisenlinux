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
.TH DELUSER 8 "Version VERSION" "Debian GNU/Linux" 
.SH NAMN
deluser, delgroup \- ta bort en användare eller grupp från systemet
.SH SYNOPSIS
\fBdeluser\fP [flaggor] [\-\-force] [\-\-remove\-home] [\-\-remove\-all\-files]
[\-\-backup] [\-\-backup\-to KATALOG] användare
.PP
\fBdeluser\fP \-\-group [flaggor] grupp
.br
\fBdelgroup\fP [flaggor] [\-\-only\-if\-empty] grupp
.PP
\fBdeluser\fP [flaggor] användare grupp
.SS "VANLIGA FLAGGOR"
.br
[\-\-quiet] [\-\-system] [\-\-help] [\-\-version] [\-\-conf FIL]
.SH BESKRIVNING
.PP
\fBdeluser\fP och \fBdelgroup\fP tar bort användare och grupper från systemet
enligt flaggorna på kommandoraden och konfigurationsinformation i
\fI/etc/deluser.conf\fP och \fI/etc/adduser.conf\fP.  De är vänligare gränssnitt
till programmen \fBuserdel\fP och \fBgroupdel\fP, tar bort hemkatalog enligt
flagga eller även alla filer på systemet som ägs av den användare som ska
tas bort, kör egendefinierade skript och andra funktioner.  \fBdeluser\fP och
\fBdelgroup\fP kan köras i ett av tre lägen:
.SS "Ta bort en vanlig användare"
Om anropad med ett icke\-flagga\-argument och utan flaggan \fB\-\-group\fP kommer
\fBdeluser\fP att ta bort en vanlig användare.

Som standard kommer \fBdeluser\fP att ta bort användaren utan att ta bort
hemkatalogen, postkön eller andra filer på systemet som ägs av
användaren. Ta bort hemkatalogen och postkön kan göras genom flaggan
\fB\-\-remove\-home\fP.

Flaggan \fB\-\-remove\-all\-files\fP tar bort alla filer på systemet som ägs av
användaren. Notera att om du aktiverar båda flaggorna kommer
\fB\-\-remove\-home\fP inte att ha någon effekt därför att alla filer inklusive
hemkatalogen och post\-spoolen redan täcks in av flaggan
\fB\-\-remove\-all\-files\fP.

Om du vill säkerhetskopiera alla filerna före de tas bort kan du aktivera
flaggan \fB\-\-backup\fP som kommer att skapa en fil kallad
användare.tar(.gz|.bz2) i den katalog som angivits med flaggan
\fB\-\-backup\-to\fP (standard är till nuvarande katalog). Båda flaggorna för
borttagning och säkerhetskopiering kan också aktiveras som standard i
konfigurationsfilen /etc/deluser.conf. Se \fBdeluser.conf(5)\fP för detaljer.

Vill du radera rot\-kontot (uid 0) använd flaggan \fB\-\-force\fP, detta kan
hindra dig från att ta bort rot\-användaren av misstag.

Om filen \fB/usr/local/sbin/deluser.local\fP finns kommer den att startas efter
att användarkontot har tagits bort för att göra vissa lokala rensningar.
Argumenten som skickas till \fBdeluser.local\fP är:
.br
användarnamn uid gid hemkatalog

.SS "Ta bort en grupp"
Om \fBdeluser\fP startas upp med flagan \fB\-\-group\fP eller om \fBdelgroup\fP startas
kommer en grupp att tas bort.

Varning: Den primära gruppen för en existerande användare kan inte tas bort.

Om flaggan \fB\-\-only\-if\-empty\fP anges kommer gruppen inte att tas bort om den
har medlemmar kvar.

.SS "Ta bort en användare från en specifik grupp"
Om anropad med två icke\-flaggor\-argument kommer \fBdeluser\fP att ta bort en
användare från en specifik grupp.
.SH FLAGGOR
.TP 
\fB\-\-conf FIL\fP
Använd FIL istället för standardfilerna \fI/etc/deluser.conf\fP och
\fI/etc/adduser.conf\fP
.TP 
\fB\-\-group\fP
Ta bort en grupp. Detta är standardåtgärden om programmet startas som
\fIdelgroup\fP.
.TP 
\fB\-\-help\fP
Visa korta instruktioner.
.TP 
\fB\-\-quiet\fP
Visa inte förloppsmeddelanden.
.TP 
\fB\-\-system\fP
Ta endast bort om användare/grupp är en systemanvändare/grupp. Detta
förhindrar oavsiktliga borttagningar av icke\-systemanvändare/grupper. Om
användaren inte finns  kommer ingen felkod att returneras. Denna flagga är
huvudsakligen för användning av skript för Debians paketunderhållare.
.TP 
\fB\-\-only\-if\-empty\fP
Only remove if no members are left.
.TP 
\fB\-\-backup\fP
Ta säkerhetskopia på alla filer i användarens hemkatalog och postfilen till
en fil med namnet /$user.tar.bz2 eller /user.tar.gz.
.TP 
\fB\-\-backup\-to\fP
Placera inte säkerhetskopiefiler i / utan en annan katalog som anges med
denna parameter. Detta innebär automatiskt att \-\-backup används.
.TP 
\fB\-\-remove\-home\fP
Ta bort hemkatalogen ochh postfilen för användaren. Om \-\-backup specificeras
raderas filerna först efter att en säkerhetskopia tagits.
.TP 
\fB\-\-remove\-all\-files\fP
Ta bort alla filer från systemet som ägs av den här användaren. OBS:
\-\-remove\-home gäller inte längre. Om \-\-backup är specificerat kommer en
säkerhetskopia på filerna först tas.
.TP 
\fB\-\-version\fP
Visa version och information om copyright.
.SH RETURVÄRDE
.TP 
\fB0\fP
Åtgärden kördes utan problem.
.TP 
\fB1\fP
Användaren som skulle tas bort var inte ett systemkonto. Ingen åtgärd
genomfördes.
.TP 
\fB2\fP
Det finns ingen sådan användare. Ingen åtgärd genomfördes.
.TP 
\fB3\fP
Det finns ingen sådan grupp. Ingen åtgärd genomfördes.
.TP 
\fB4\fP
Internt fel. Ingen åtgärd genomfördes.
.TP 
\fB5\fP
Gruppen som skulle tas bort är inte tom. Ingen åtgärd genomfördes.
.TP 
\fB6\fP
Användaren tillhör inte den angivna gruppen. Ingen åtgärd genomfördes.
.TP 
\fB7\fP
Du kan inte ta bort en användare från sin primära grupp. Ingen åtgärd
genomfördes.
.TP 
\fB8\fP
Paketet "perl modules" behövs men är inte installerat. Paketet behövs för
att kunna utföra de begärda åtgärderna. Ingen åtgärd genomfördes.
.TP 
\fB9\fP
För att tabort rot\-konto måste flaggan "\-\-force" användas. Ingen åtgärd
genomfördes.

.SH FILER
\fI/etc/deluser.conf\fP Default configuration file for deluser and delgroup
.TP 
\fI/usr/local/sbin/deluser.local\fP
Optional custom add\-ons.

.SH "SE OCKSÅ"
\fBadduser\fP(8), \fBdeluser.conf\fP(5), \fBgroupdel\fP(8), \fBuserdel\fP(8)

.SH ÖVERSÄTTARE
Denna manualsida har översatts av Daniel Nylander <po@danielnylander.se> 
den 25 november 2005.

Om du hittar några felaktigheter i översättningen, vänligen skicka ett 
e-postmeddelande till översättaren eller till sändlistan
.nh
<\fIdebian\-l10n\-swedish@lists.debian.org\fR>,
.hy

.SH COPYRIGHT
Copyright (C) 2000 Roland Bauerschmidt. Modifieringar (C) 2004 Marc Haber
och Joerg Hoh.  Denna manualsida och programmet deluser är baserade på
adduser som är:
.br
Copyright (C) 1997, 1998, 1999 Guy Maor.
.br
Copyright (C) 1995 Ted Hajek, med en hel del lånat från ursprungliga Debian
\fBadduser\fP
.br
Copyright (C) 1994 Ian Murdock.  \fBdeluser\fP är fri programvara; se GNU
General Public Licence version 2 eller senare för villkor för kopiering.
Det finns \fIingen\fP garanti.
