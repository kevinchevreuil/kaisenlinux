/*

    File: cmospwd.c

    Copyright (C) 1998-2006 Christophe GRENIER <grenier@cgsecurity.org>
    http://www.cgsecurity.org
  
    This software is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.
  
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
  
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

    Thanks to Bluefish for BSD support

    NetBSD support by Einar Karttunen <ekarttun at cs helsinki fi>
    Compile with -li386 on NetBSD, e.g. "make cmospwd LDFLAGS=-li386"

    CYGWIN32: gcc -o cmospwd_win.exe cmospwd.c -O2 -Wall -lioperm
    MINGW32: gcc -o cmospwd_win.exe cmospwd.c -O2 -Wall
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#ifdef __CYGWIN32__
#define HAVE_CTYPE_H 1
#define HAVE_SYS_IO_H 1
#endif

#ifdef __FreeBSD__
#define HAVE_CTYPE_H 1
#endif

#ifdef __linux__
#define HAVE_CTYPE_H 1
#define HAVE_SYS_IO_H 1
#endif

#ifdef __MSDOS__
#define HAVE_CONIO_H 1
#define HAVE_CTYPE_H 1
#define HAVE_DOS_H 1
#endif

#if defined(__NetBSD__)
#define HAVE_SYS_TYPES_H 1
#define HAVE_MACHINE_SYSARCH_H 1
#endif

#ifdef WIN32
#define HAVE_CONIO_H 1
#define HAVE_WINDOWS_H 1
#endif

#ifdef __MINGW32__
#define HAVE_CTYPE_H 1
#define HAVE_WINDOWS_H 1
#define HAVE_WINIOCTL_H 1
#define HAVE_ERRNO_H 1
#endif

#ifdef HAVE_CONIO_H
#include <conio.h>
#endif
#ifdef HAVE_CTYPE_H
#include <ctype.h>	/* Usefull for toupper */
#endif
#ifdef HAVE_DOS_H
#include <dos.h>
#endif
#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif
#ifdef HAVE_WINDOWS_H
#include <windows.h>
#endif
#ifdef HAVE_SYS_IO_H
#include <sys/io.h>
#endif
#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif
#ifdef HAVE_MACHINE_SYSARCH_H
#include <machine/sysarch.h>
#endif
#ifdef HAVE_WINIOCTL_H
#include <winioctl.h>
#endif

#ifdef __MINGW32__
#define	IOCTL_IOPERM	CTL_CODE( FILE_DEVICE_UNKNOWN, 0xA00, METHOD_BUFFERED, FILE_ANY_ACCESS )
#define	IOCTL_IOPL	CTL_CODE( FILE_DEVICE_UNKNOWN, 0xA01, METHOD_BUFFERED, FILE_ANY_ACCESS )

struct ioperm_data {
	unsigned long from;
	unsigned long num;
	int turn_on;
};

struct iopl_data {
	int value;
};

int ioperm( unsigned long from, unsigned long num, int turn_on )
{
	HANDLE h;
	struct ioperm_data ioperm_data;
	DWORD BytesReturned;
	BOOL r;
	h = CreateFile( "\\\\.\\ioperm", GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL );
	if (h == INVALID_HANDLE_VALUE) {
		errno = ENODEV;
		return -1;
	}

	ioperm_data.from = from;
	ioperm_data.num = num;
	ioperm_data.turn_on = turn_on;

	r = DeviceIoControl( h, IOCTL_IOPERM, &ioperm_data, sizeof ioperm_data, NULL, 0, &BytesReturned, NULL );
	if (!r)
		errno = EPERM;

	CloseHandle( h );

	return r ? 0 : -1;
}
#endif


#if defined(WIN32) && !defined(__MINGW32__)
#define outportb(PORT,VALUE) outp(PORT,VALUE)
#define inportb(PORT) inp(PORT)
//
// Macro definition for defining IOCTL and FSCTL function control codes.  Note
// that function codes 0-2047 are reserved for Microsoft Corporation, and
// 2048-4095 are reserved for customers.
//

#define CTL_CODE( DeviceType, Function, Method, Access ) (                 \
    ((DeviceType) << 16) | ((Access) << 14) | ((Function) << 2) | (Method) \
)
#define METHOD_BUFFERED                 0
#define FILE_ANY_ACCESS                 0

#define DEVICE_NAME_STRING      L"gwiopm"
#define IOPM_VERSION          110      // decimal
#define IOPM_TEST0         0x0123
#define IOPM_TEST1         0x1234
#define IOPM_TEST2         0x2345

// Device type           -- in the "User Defined" range."
#define IOPMD_TYPE 0xF100               // used several places

// The IOCTL function codes from 0x800 to 0xFFF are for non-Microsoft use.
// LIOPM means "local I/O Permission Map" maintained by this driver.
//-------------------------- 
// Test functions
#define IOCTL_IOPMD_READ_TEST        CTL_CODE(IOPMD_TYPE, 0x900, METHOD_BUFFERED, FILE_ANY_ACCESS ) // returns IOPM_TEST
#define IOCTL_IOPMD_READ_VERSION     CTL_CODE(IOPMD_TYPE, 0x901, METHOD_BUFFERED, FILE_ANY_ACCESS ) // returns IOPM_VERSION
// Manipulate local IOPM
#define IOCTL_IOPMD_CLEAR_LIOPM      CTL_CODE(IOPMD_TYPE, 0x910, METHOD_BUFFERED, FILE_ANY_ACCESS ) // set map to block perm on all I/O addresses
#define IOCTL_IOPMD_SET_LIOPM        CTL_CODE(IOPMD_TYPE, 0x911, METHOD_BUFFERED, FILE_ANY_ACCESS ) // set a uint8_t (8 ports-worth) in LIOPM
#define IOCTL_IOPMD_GET_LIOPMB       CTL_CODE(IOPMD_TYPE, 0x912, METHOD_BUFFERED, FILE_ANY_ACCESS ) // get a uint8_t from LIOPM (diagnostic)
#define IOCTL_IOPMD_GET_LIOPMA       CTL_CODE(IOPMD_TYPE, 0x913, METHOD_BUFFERED, FILE_ANY_ACCESS ) // get entire array of current LIOPM 
// Interact with kernel
#define IOCTL_IOPMD_ACTIVATE_KIOPM   CTL_CODE(IOPMD_TYPE, 0x920, METHOD_BUFFERED, FILE_ANY_ACCESS ) // copy LIOPM to be active map 
#define IOCTL_IOPMD_DEACTIVATE_KIOPM CTL_CODE(IOPMD_TYPE, 0x921, METHOD_BUFFERED, FILE_ANY_ACCESS ) // tell NT to forget map 
#define IOCTL_IOPMD_QUERY_KIOPM      CTL_CODE(IOPMD_TYPE, 0x922, METHOD_BUFFERED, FILE_ANY_ACCESS ) // get OS's IOPM into LIOPM? 

#define GWIOPM_PARAMCOUNT 3                            // for most functions
#define GWIOPM_PARAMCOUNT_BYTES GWIOPM_PARAMCOUNT * 4  // for most functions

#elif defined(__FreeBSD__)
FILE *cmos_fd;
#endif

#define TAILLE_CMOS 4*0x80
#define TAILLE_CMOS_MAX 4096
#define TAILLE_BUFFER 2*0x200+TAILLE_CMOS_MAX
#define MINLEN_CRC 6
/* port i/o privileges & co. */
#define IO_READ  1
#define IO_WRITE 2
#define IO_RDWR  (IO_READ | IO_WRITE)
#define PORT_CMOS_0 0x70
#define PORT_CMOS_1 0x71
#define PORT_CMOS_2 0x72
#define PORT_CMOS_3 0x73
#define PORT_CMOS_4 0x74
#define PORT_CMOS_5 0x75
#define PORT_CMOS_6 0x76
#define PORT_CMOS_7 0x77
#define UNKNOWN_CAR '?'
#define VAL_NON_STOP 	256
#define VAL_STOP	257
#define VAL_UNK		258
int get32(int position, const uint8_t *data_src);
void aff_hexa(const unsigned char*buffer,const unsigned int lng);
void aff_result(const unsigned int *src, const unsigned int lng);
void table2val(unsigned int*dst, const uint8_t *src, const unsigned int lng, const unsigned int *table);
int check_crcadd(int position, int size, int pos_crc);
int check_filled(const unsigned int*value, const unsigned int lng, const unsigned int filled_value);
void award_backdoor(void);
void generic_acer(unsigned int *dst, const unsigned int lng);
int generic_ami(unsigned int *data, const unsigned int lng, const int methode);
void generic_award6(unsigned int *value, const unsigned int lng);
void generic_basic(const unsigned int offset, const unsigned int lng, const int algo,const unsigned int val_stop,const int mode_aff, const uint8_t *data_src);
void generic_compaq(unsigned int *value, const unsigned int lng);
void generic_crc(int algo, int position, const uint8_t *data_src);
void generic_dtk(unsigned int*value, const unsigned int lng);
void generic_packard(unsigned int *value, const unsigned int lng);
void generic_phoenix_add(unsigned int *value, const unsigned int lng);
void generic_phoenix_dec(unsigned int *value, const unsigned int lng);
void generic_phoenix_xor(unsigned int *value, const unsigned int lng);
void generic_unknown(unsigned int*value, const unsigned int lng);
void generic_table(unsigned int *value, const unsigned int lng, const int algo,const unsigned int val_stop,const int mode_aff);

void convert_scancode2ascii(unsigned int*dst, const unsigned int lng);
uint8_t scan2ascii(uint8_t);
unsigned char filtre(unsigned char);
void dumpcmos(const int cmos_size, const int scancode);
int ask_YN(const char*);
uint8_t parity_test(uint8_t val);
uint16_t rol(uint16_t);
uint8_t rcl8(uint8_t);
uint8_t rcl8n(uint8_t, unsigned int);
uint8_t brute_awa(uint16_t, uint16_t, uint8_t);
uint8_t brute_award(uint16_t);
void set_permissions(void);
void unset_permissions(void);
uint16_t do_tosh(uint16_t, uint8_t);
uint8_t brute_tosh(uint16_t, uint16_t, uint8_t);
uint8_t brute_toshiba(uint16_t);
void keyb_mem();
#define m_acer          		"\nAcer/IBM                     "
#define m_ami_old       		"\nAMI BIOS                     "
#define m_ami_winbios   		"\nAMI WinBIOS (12/15/93)       "
#define m_ami_winbios25  		"\nAMI WinBIOS 2.5              "
#define m_ami_unk			"\nAMI ?                        "
#define m_award         		"\nAward 4.5x/6.0               "
#define m_award_medallion 		"\nAward Medallion 6.0          "
#define m_award6			"\nAward 6.0                    "
#define m_compaq        		"\nCompaq (1992)                "
#define m_compaq2       		"\nCompaq                       "
#define m_compaq_deskpro   		"\nCompaq DeskPro               "
#define m_dtk				"\nDTK                          "
#define m_ibm           		"\nIBM (PS/2, Activa ...)       "
#define m_ibm_thinkpad  		"\nIBM Thinkpad boot pwd        "
#define m_ibm_300       		"\nIBM 300 GL                   "
#define m_ibm_thinkpad_765_380z 	"\nThinkpad 765/380z EEPROM     "
#define m_ibm_thinkpad_560x 		"\nThinkpad 560x EEPROM         "
#define m_ibm_thinkpad_x20_570_t20	"\nThinkpad x20/570/t20 EEPROM  "
#define m_packardbell   		"\nPackard Bell Supervisor/User "
#define m_phoenixa08			"\nPhoenix A08, 1993            "
#define m_phoenix       		"\nPhoenix 1.00.09.AC0 (1994)   "
#define m_phoenix_1_03			"\nPhoenix a486 1.03            "
#define m_phoenix_1_04      		"\nPhoenix 1.04                 "
#define m_phoenix_1_10      		"\nPhoenix 1.10 A03             "
#define m_phoenix4      		"\nPhoenix 4 release 6 (User)   "
#define m_phoenix_40_r_60		"\nPhoenix 4.0 release 6.0      "
#define m_phoenix405			"\nPhoenix 4.05 rev 1.02.943    "
#define m_phoenix406			"\nPhoenix 4.06 rev 1.13.1107   "
#define m_gateway_ph			"\nGateway Solo Phoenix 4.0 r6  "
#define m_toshiba       		"\nToshiba                      "
#define m_zenith_ami    		"\nZenith AMI Supervisor/User   "
#define m_samsung_P25			"\nSamsung P25                  "
#define m_Sony_Vaio			"\nSony Vaio EEPROM             "
#define m_Keyb_Mem			"\nKeyboard BIOS memory         "
void acer(void);
void ami_old(void);
void ami_winbios(void);
void ami_winbios2(void);
void ami_unk(void);
void award(void);
void award_medallion(void);
void award6(void);
void compaq(void);
void compaq2(void);
void compaq_deskpro(void);
void dtk(void);
void phoenixa08(void);
void ibm(void);
void ibm_thinkpad(void);
void ibm_thinkpad2(void);
void ibm_300(void);
void packardbell(void);
void phoenix(void);
void phoenix_1_04(void);
void phoenix_1_10(void);
void phoenix4(void);
void phoenix_40_r_60(void);
void phoenix_1_03(void);
void phoenix405(void);
void phoenix406(void);
void gateway_ph(void);
void toshiba(void);
void zenith_ami(void);
void samsung(void);
void sony_vaio(void);
void keyb_mem(void);
void (*tbl_func[])(void)={acer,
	ami_old,ami_winbios,ami_winbios2,ami_unk,
	award, award_medallion, award6,
	compaq,compaq_deskpro,compaq2,
	dtk,
	ibm,ibm_thinkpad,ibm_thinkpad2,ibm_300,
	packardbell,
	phoenix,phoenix_1_03,phoenix_1_04,phoenix_1_10,phoenix4,phoenix_40_r_60,phoenix405,phoenix406,
	phoenixa08,
	gateway_ph,
	samsung,
	sony_vaio,
	toshiba,
	zenith_ami,
	keyb_mem};
#define nbr_func sizeof(tbl_func)/sizeof(*tbl_func)
int kill_cmos(const int cmos_size);
int load_cmos(const int cmos_size);
int restore_cmos(const int cmos_size,const int choix);
int load_backup(const char*);
int save_backup(const int cmos_size, const char* name);
unsigned int get_table_pb(unsigned int val);

typedef struct s_cmos_f t_cmos_f;
typedef struct s_cmos_l t_cmos_l;
typedef struct s_cmos t_cmos;

struct s_cmos_f
{
  int scancode;
  int position;
  int size;
  int order;
};

struct s_cmos_l
{
  int type;
  char* info;
  t_cmos_l *next;
};

struct s_cmos
{
  char *name;
  t_cmos_l *first;
};


#if defined(__linux__)||defined(__FreeBSD__)||defined(__NetBSD__)||defined(__CYGWIN32__)||defined(__MINGW32__)
static __inline__ void outportb(uint16_t port,uint8_t value)
{
  __asm__ volatile ("outb %0,%1"
		    ::"a" ((char) value), "d"((uint16_t) port));
}

static __inline__ uint8_t inportb(uint16_t port)
{
  uint8_t _v;
  __asm__ volatile ("inb %1,%0"
			 :"=a" (_v):"d"((uint16_t) port));
  return _v;
}
#endif

enum {KEYB_US,KEYB_FR, KEYB_DE};
int keyb=KEYB_US;
uint8_t cmos[TAILLE_CMOS_MAX];

int get32(int position, const uint8_t *data_src)
{
  return ((data_src[position+1] <<8) | data_src[position]);
}

/* CONVERTION ET FILTRAGE */
uint8_t scan2ascii(uint8_t car)
{
  static const uint8_t tbl_fr[255]=
  { ' ',' ','1','2','3','4','5','6',
    '7','8','9','0',')','=',' ',' ',
    'A','Z','E','R','T','Y','U','I',     /* 10 */
    'O','P',' ','$',' ',' ','Q','S',     /* 18 */
    'D','F','G','H','J','K','L','M',     /* 20 */
    '%','ý',' ','*','W','X','C','V',
    'B','N',',',';',':','/',' ','*',     /* 30 */
    ' ',' ',' ','f','f','f','f','f',     /* F1 a F10 */
    'f','f','f','f','f',' ',' ','7',     /* 40 */
    '8','9','-','4','5','6','+','1',
    '2','3','0','.',' ',' ','>',' '};    /* 50 */

    static const uint8_t tbl_de[255]=
    { ' ',' ','1','2','3','4','5','6',
      '7','8','9','0','-','=',' ',' ',
      'Q','W','E','R','T','Z','U','I',     /* 10 */
      'O','P',' ','$',' ',' ','A','S',     /* 18 */
      'D','F','G','H','J','K','L',';',     /* 20 */
      'ù','`',' ','*','Y','X','C','V',
      'B','N','M',',','.','/','"','*',     /* 30 */
      ' ',' ',' ','f','f','f','f','f',     /* F1 a F10 */
      'f','f','f','f','f',' ',' ','7',     /* 40 */
      '8','9','-','4','5','6','+','1',
      '2','3','0','.',' ',' ','>',' '};    /* 50 */

    static const uint8_t tbl_us[255]=
    { ' ',' ','1','2','3','4','5','6',
      '7','8','9','0','-','=',' ',' ',
      'Q','W','E','R','T','Y','U','I',     /* 10 */
      'O','P',' ','$',' ',' ','A','S',     /* 18 */
      'D','F','G','H','J','K','L',';',     /* 20 */
      'ù','`',' ','*','Z','X','C','V',
      'B','N','M',',','.','/','"','*',     /* 30 */
      ' ',' ',' ','f','f','f','f','f',     /* F1 a F10 */
      'f','f','f','f','f',' ',' ','7',     /* 40 */
      '8','9','-','4','5','6','+','1',
      '2','3','0','.',' ',' ','>',' '};    /* 50 */
/* start */
  if (car<0x58)
  {
    switch(keyb)
    {
      case KEYB_FR:
	return tbl_fr[car];
      case KEYB_DE:
	return tbl_de[car];
      case KEYB_US:
      default:
	return tbl_us[car];
    }
  }
  return ' ';
}

unsigned char filtre(unsigned char lettre)
{
  if ((lettre>=32) && (lettre <=125))
    return lettre;
  else
    switch(lettre)
    {
      case(131):
      case(132):
      case(133):
      case(134):
      case(160):
	return 'a';
      case(130):
      case(136):
      case(137):
      case(138):
	return 'e';
      case(139):
      case(140):
      case(141):
      case(161):
	return 'i';
      case(164):
	return 'n';
      case(147):
      case(148):
      case(149):
      case(162):
	return 'o';
      case(150):
      case(151):
      case(163):
	return 'u';
      case(152):
	return 'y';
      case(142):
      case(143):
	return 'A';
      case(144):
	return 'E';
      case(165):
	return 'N';
      case(153):
	return 'O';
      case(154):
	return 'U';
      default:
	return ' ';
    }
}

unsigned int get_table_pb(unsigned int val)
{
  switch(val)
  {
    case 0xE7:
    case 0x3F:
      return 'B';
    case 0xA3:
      return 'C';
    case 0xFB:
      return 'D';
    case 0xBD:
      return 'E';
    case 0xF6:
      return 'F';
    case 0x77:
      return 'G';
    case 0xB9:
      return 'H';
    case 0xCF:
      return 'O';
    case 0xD7:
      return 'T';
  }
  return VAL_UNK;
}

void dump(const void *data_original, const unsigned int*data_processed,unsigned int lng)
{
  unsigned int i,j;
  unsigned int nbr_line;
  unsigned char car;
  nbr_line=(lng+0x10-1)/0x10;
  for (i=0; (i<nbr_line); i++)
  {
    printf("%03X: ",i*0x10);
    for(j=0; j< 0x10;j++)
    {
      if(i*0x10+j<lng)
      {
	car=*((const unsigned char *)data_original+i*0x10+j);
	printf("%02x ", car);
      }
      else
	printf("  ");
    }
    printf(" |");
    for(j=0; j< 0x10;j++)
    {
      if(i*0x10+j<lng)
      {
	car=data_processed[i*0x10+j];
	printf("%c",  filtre(car));
      }
      else
	printf("  ");
    }
    printf("|\n");
  }
}


void aff_hexa(const unsigned char*buffer,const unsigned int lng)
{
  int i;
  for(i=0;i<lng;i++)
    printf("%02X ",buffer[i]);
}

/* test et manipulation binaire */
uint8_t parity_test(uint8_t val)
{
  int res=0;
  int i;
  for(i=0;i<8;i++)
  {
    if(val&1)
      res^=1;
    val>>=1;
  }
  return res;
}

uint8_t rcl8(uint8_t num)
{
  return (num<<1)|(num >> 7);
}

uint8_t rcl8n(uint8_t num, unsigned int n)
{
  unsigned int i;
  uint8_t res=num;
  for(i=0;i<n;i++)
    res=rcl8(res);
  return res;
}

uint16_t rol(uint16_t n)
{
  return (n<<2)| ((n & 0xC000) >> 14);
}
/* Fonctions generiques */
/*
 *    pos_ini, size, meth_parcourt(COPIE, COPIE2)
 * => table
 * => table_de_valeur
 * => pre-verif
 * => decryptage
 * => post-verif
 * => affichage direct ou apres conversion scan2ascii
 *
 * methode_CRC
 *    pos_ini
 * => valeur
 * => brute force
 * */

enum { ALGO_AMI_F0, ALGO_AMI, ALGO_AMI_80, ALGO_UNKNOW, ALGO_AWARD, ALGO_AWARD6, ALGO_TOSHIBA, ALGO_ACER, ALGO_PACKARD,ALGO_NONE,ALGO_PHOENIX_DEC,ALGO_PHOENIX_XOR,ALGO_PHOENIX_ADD,ALGO_DTK,ALGO_COMPAQ};
enum { AFF_SCAN,AFF_ASCII};


void table2val(unsigned int*dst, const uint8_t *src, const unsigned int lng, const unsigned int *table)
{
  int i;
  for(i=0;i<lng;i++)
  {
    dst[i]=src[table[i]];
  }
}

void aff_result(const unsigned int*src, const unsigned int lng)
{
  unsigned int i;
  putchar('[');
  for(i=0;(i<lng) && (src[i]!=VAL_STOP);i++)
  {
    if(src[i]==UNKNOWN_CAR)
      putchar('?');
    else
      putchar(filtre(src[i]));
  }
  putchar(']');
}

int generic_ami(unsigned int*dst, const unsigned int lng, const int methode)
{
  int pos;
  unsigned char ah,al;
  switch(methode)
  {
    case ALGO_AMI_F0: 	al=dst[0] & 0xF0; break;
    case ALGO_AMI: 	al=dst[0]; break;
    case ALGO_AMI_80: 	al=0x80; break;
    default:		printf("Bad AMI ALGO"); return 1;
  }
  for(pos=1;pos<lng;pos++)
  {
    unsigned int i;
    if (dst[pos]==VAL_STOP)
    {
      dst[pos-1]=VAL_STOP;
      return 0;
    }
    ah=al;
    al=dst[pos];
    for (i=0;i<=255;i++)
    {
      if (al==ah) break;
      if (parity_test(0xE1&al)) al=(al<<1)|1; else al<<=1;
    }
    al=dst[pos];
    if(i>255)
      dst[pos-1]=UNKNOWN_CAR;
    else
      dst[pos-1]=i;
    dst[pos]=VAL_STOP;
  }
  return 0;
}

void generic_acer(unsigned int *dst, const unsigned int lng)
{
  int i;
  for(i=0;(i<lng)&&(dst[i]!=VAL_STOP);i++)
  {
    dst[i]=dst[i]>>1;	/* ibm_1 */
  }
  /* shr al,1		D0 E8
   * cmp al,[bx+si]	3A 00
   */
}

void generic_award6(unsigned int *dst, const unsigned int lng)
{
  int i;
  for(i=0;(i<lng)&&(dst[i]!=VAL_STOP);i++)
    dst[i]=rcl8n(dst[i],i);
}

void generic_unknown(unsigned int*dst, const unsigned int lng)
{
  int i;
  for(i=0;(i<lng)&&(dst[i]!=VAL_STOP);i++)
    dst[i]=UNKNOWN_CAR;
}

int check_filled(const unsigned int*value, const unsigned int lng, const unsigned int filled_value)
{
  int i;
  int etat=0;
  for(i=0;i<lng;i++)
  {
    switch(etat)
    {
      case 0:
	if(value[i]==filled_value)
	  etat++;
	break;
      case 1:
	if(value[i]!=filled_value)
	  return 1;
    }
  }
  return 0;
}

void generic_phoenix_dec(unsigned int *value, const unsigned int lng)
{
  unsigned int i;
  for(i=0;(i<lng)&&(value[i]!=VAL_STOP);i++)
    value[i]=rcl8n(value[i],i+1);
}

void generic_phoenix_xor(unsigned int *value, const unsigned int lng)
{
  unsigned int i;
  for(i=0;(i<lng)&&(value[i]!=VAL_STOP);i++)
    value[i]=(value[i] ^ 0xF0) + i;
}

void generic_phoenix_add(unsigned int *value, const unsigned int lng)
{
  unsigned int i;
  for(i=0;(i<lng)&&(value[i]!=VAL_STOP);i++)
    value[i]+=0x20;
}

void generic_basic(const unsigned int offset, const unsigned int lng, const int algo,const unsigned int val_stop,const int mode_aff, const uint8_t *data_src)
{
  unsigned int i;
#if defined(__MSDOS__) || defined(WIN32)
  unsigned int value[10];
#else
  unsigned int value[lng];
#endif
  for(i=0;i<lng;i++)
    value[i]=data_src[offset+i];
  generic_table(value, lng, algo, val_stop, mode_aff);
}

void generic_table(unsigned int *value, const unsigned int lng, const int algo,const unsigned int val_stop,const int mode_aff)
{
  {
    unsigned int i;
    for(i=0;i<lng;i++)
      if(value[i]==val_stop && algo!=ALGO_COMPAQ)
	value[i]=VAL_STOP;
  }
  switch(algo)
  {
    case ALGO_AMI_F0:
    case ALGO_AMI:
    case ALGO_AMI_80:
      generic_ami(value,lng,algo);
      break;
    case ALGO_UNKNOW:
      generic_unknown(value,lng);
      break;
    case ALGO_ACER:
      generic_acer(value,lng);
      break;
    case ALGO_AWARD6:
      generic_award6(value,lng);
      break;
    case ALGO_PACKARD:
//      check_filled(value,lng,val_stop);
      generic_packard(value,lng);
      break;
    case ALGO_NONE:
      break;
    case ALGO_PHOENIX_DEC:
      generic_phoenix_dec(value,lng);
      break;
    case ALGO_PHOENIX_XOR:
      generic_phoenix_xor(value,lng);
      break;
    case ALGO_PHOENIX_ADD:
      generic_phoenix_add(value,lng);
      break;
    case ALGO_DTK:
      generic_dtk(value,lng);
      break;
    case ALGO_COMPAQ:
      generic_compaq(value,lng);
      break;
    default:
      printf("BAD ALGO ");
      return;
  }
  if(mode_aff==AFF_SCAN)
    convert_scancode2ascii(value,lng);
  aff_result(value,lng);
}

/* ================================================================= */
int check_crcadd(int position, int size, int pos_crc)
{
  int i;
  int crc=0;
  for(i=position;i<position+size;i++)
    crc+=cmos[i];
  return ((crc & 0xFF) == cmos[pos_crc]);
}

void generic_packard(unsigned int *value, const unsigned int lng)
{
  int i;
  for(i=1;(i<lng)&&(value[i]!=VAL_STOP);i++) /* Ecrase le "CRC ?" */
  {
    value[i-1]=get_table_pb(value[i]);
  }
  value[i-1]=VAL_STOP;
}

void generic_crc(int algo, int position, const uint8_t *data_src)
{
  switch(algo)
  {
    case ALGO_AWARD:
      brute_award(get32(position,data_src));
      break;
    case ALGO_TOSHIBA:
      brute_toshiba(get32(position,data_src));
      break;
  }
}

void generic_compaq(unsigned int *value, const unsigned int lng)
{
  unsigned int i,j;
#if defined(__MSDOS__)||defined(WIN32)
  unsigned int value2[10];
#else
  unsigned int value2[lng];
#endif
  /* Data from
   * - Luka "The /\/\ighty \/\/izzy"
   *   Compaq 5200, August 1998
   * - Quattrocchi Stefano
   * - Zoulou Yankee
   *   Compaq DeskPro EP Serie 6350/6.4 EA2, May 2001
   */
  unsigned char tbl_deco[][4]={
    {0x00, 0xDD,0x2F,0x02},	/* 1 */
    {0x80, 0x73,0x13,0x03},	/* 2 */
    {0x00, 0x3A,0x09,0x04},	/* 3 */
    {0x80, 0x94,0x35,0x05},	/* 4 */
    {0x00, 0xE7,0x26,0x06},	/* 5 */
    {0x80, 0x49,0x1A,0x07},	/* 6 */
    {0x00, 0x74,0x12,0x08},	/* 7 */
    {0x80, 0xDA,0x2E,0x09},	/* 8 */
    {0x00, 0xA9,0x3D,0x0A},	/* 9 */
    {0x80, 0x07,0x01,0x0B},	/* 0 */
    {0x00, 0xE8,0x24,0x10},	/* Q */
    {0x80, 0x46,0x18,0x11},	/* W */
    {0x00, 0x35,0x0B,0x12},	/* E */
    {0x80, 0x9B,0x37,0x13},	/* R */
    {0x00, 0xD2,0x2D,0x14},	/* T */
    {0x80, 0x7C,0x11,0x15},	/* Y */
    {0x00, 0x0F,0x02,0x16},	/* U */
    {0x80, 0xA1,0x3E,0x17},	/* I */
    {0x00, 0x9C,0x36,0x18},	/* O */
    {0x80, 0x32,0x0A,0x19},	/* P */

    {0x00, 0x7B,0x10,0x1E},	/* A */
    {0x80, 0xD5,0x2C,0x1F},	/* S */
    {0x00, 0x50,0x1F,0x20},	/* D */
    {0x80, 0xFE,0x23,0x21},	/* F */
    {0x00, 0x8D,0x30,0x22},	/* G */
    {0x80, 0x23,0x0C,0x23},	/* H */
    {0x00, 0x6A,0x16,0x24},	/* J */
    {0x80, 0xC4,0x2A,0x25},	/* K */
    {0x00, 0xB7,0x39,0x26},	/* L */

    {0x00, 0x1E,0x04,0x2C},	/* Z */
    {0x80, 0xB0,0x38,0x2D},	/* X */
    {0x00, 0xC3,0x2B,0x2E},	/* C */
    {0x80, 0x6D,0x17,0x2F},	/* V */
    {0x00, 0xB8,0x3B,0x30},	/* B */
    {0x80, 0x16,0x07,0x31},	/* N */
    {0x00, 0x65,0x14,0x32},	/* M */
    {0x80, 0xCB,0x28,0x33},	/* , */
    {0x00, 0x82,0x32,0x34},	/* . */
    {0x80, 0x62,0x15,0x39},	/*   */
    {0x00, 0x30,0x0A,0x45},	/* Num / */
    {0x80, 0xF1,0x21,0x46},	/* Num * */
    {0x80, 0xE9,0x24,0x47},	/* Num 7 */
    {0x00, 0xD4,0x2C,0x48},	/* Num 8 */
    {0x80, 0x7A,0x10,0x49},	/* Num 9 */
    {0x00, 0x09,0x03,0x4A},	/* Num - */
    {0x80, 0xA7,0x3F,0x4B},	/* Num 4 */
    {0x00, 0xEE,0x25,0x4C},	/* Num 5 */
    {0x80, 0x40,0x19,0x4D},	/* Num 6 */
    {0x00, 0x33,0x0A,0x4E},	/* Num + */
    {0x80, 0x9D,0x36,0x4F},	/* Num 1 */
    {0x00, 0x48,0x1A,0x50},	/* Num 2 */
    {0x80, 0xE6,0x26,0x51},	/* Num 3 */
    {0x00, 0x95,0x35,0x52},	/* Num 0 */
    {0x80, 0x3B,0x09,0x53},	/* Num . */
    {0x00, 0x00,0x00,0x00}
  };
  for(i=0;i<lng/4;i++)
  {
    if((value[4*i+0]==0) && (value[4*i+1]==0) && (value[4*i+2]==0) && (value[4*i+3]==0))
    {
      value2[4*i+0]=0x0;
    }
    else
    {
      /* 1 */
      value2[4*i+0]=VAL_UNK;
      for(j=0;tbl_deco[j][3];j++)
	if(tbl_deco[j][1] == value[4*i+3])
	{
	  if((tbl_deco[j][0] & value[4*i+2]) == tbl_deco[j][0])
	  {
	    value2[4*i+0]=tbl_deco[j][3];
	    break;
	  }
	}
      /* 2 */
      value2[4*i+1]=value[4*i+0]^tbl_deco[j][2];
      //    printf("-%02X-",value2[4*i+1]);
      /* 3 */
      value2[4*i+2]=value[4*i+1]&0x7F;
      /* 4 */
      value2[4*i+3]=value[4*i+2]&0x7F;
    }
  }
  for(i=0;i<lng;i++)
  {
    if(value2[i]==0)
      value[i]=VAL_STOP;
    else
      value[i]=value2[i];
  }
}

void generic_dtk(unsigned int *value, const unsigned int lng)
{
  unsigned int i;
#if defined(__MSDOS__)||defined(WIN32)
  unsigned int value2[10];
#else
  unsigned int value2[lng];
#endif
  for(i=0;i<lng;i++)
  {
    int b;
    switch(i%4)
    {
      case 0: b=value[(i/4)*3] >> 2; break;
      case 1: b=(value[(i/4)*3] << 4) + (value[(i/4)*3+1]>>4); break;
      case 2: b=((value[(i/4)*3+1] << 2) & 0x3C) + (value[(i/4)*3+2] >> 6); break;
      default: b=value[(i/4)*3+2]; break;
    }
    b=b&0x3F;
    if(b==0)
      break;
    if(b<=10)
      value2[i]=b-1+'0';
    else
      value2[i]=b-1+'A';
  }
  for(i=0;i<lng;i++)
  {
    if(value2[i]==0)
      value[i]=VAL_STOP;
    else
      value[i]=value2[i];
  }
}

/* Brute force Award */
int awa_pos;
char awa_res[9];

uint8_t brute_awa(uint16_t but, uint16_t somme, uint8_t lng)
{
  uint8_t p;
  static uint8_t const tbl_car[]={'0','1','2','3','4','5','6'};

  if (lng==0)
    return (but==somme);
  else
      for (p=0;p<4;p++)
	  if (brute_awa(but, rol(somme) + tbl_car[p], lng-1))
	    {
	      awa_res[awa_pos++]=tbl_car[p];
	      return 1;
	    }
  return 0;
}

uint8_t brute_award(uint16_t but)
{
  int i;
  uint8_t res;
  awa_pos=0;
  for(i=0;i<9;i++)
    awa_res[i]='\0';
  for (i=1;i<=8;i++)
  {
    res=brute_awa(but, 0,i);
   if (res) break;
  }
#ifndef TEST
  printf("[");
  for (i=awa_pos-1;i>=0;i--) printf("%c", awa_res[i]);
  printf("]");
#endif
  return res;
}

/* Brute force Toshiba */
uint16_t do_tosh(uint16_t valcrc, uint8_t car)
{
    register uint8_t ah,al,dh,dl;
    al=(uint8_t)valcrc;
    ah=valcrc>>8;
    ah^=car;	/* xor ah,[bx] */
    dl=ah;	/* mov dl,ah */
    dl<<=4;	/* shl dl,4 	C0 E2 04 */
    ah^=dl;     /* xor ah,dl 	32 E2 */
    dl=ah;      /* mov dl,ah 	8A D4 */
    dl>>=5;	/* shl dl,5 */
    dl^=ah;	/* xor dl,ah */
    dh=ah;
    ah<<=3;
    ah^=al;
    dh>>=4;
    ah^=dh;
    al=dl;
    return (ah<<8)|al;
}

int tosh_pos;
char tosh_res[11];

uint8_t brute_tosh(uint16_t but, uint16_t valcrc, uint8_t lng)
{
  unsigned int p;
  static uint8_t const tbl_car[]={0x10,0x11,0x12,0x13,0x14,0x20};

  if (lng==0)
  {
    if(valcrc==0)
      valcrc++;
    return (but==valcrc);
  }
  else
  {
    for (p=0;p<sizeof(tbl_car);p++)
      if (brute_tosh(but, do_tosh(valcrc,tbl_car[p]), lng-1))
      {
	tosh_res[tosh_pos++]=tbl_car[p];
	return 1;
      }
  }
  return 0;
}

uint8_t brute_toshiba(uint16_t but)
{
  int i;
  uint8_t res;
  tosh_pos=0;
  if(but==0)
  {
    printf("[KEY floppy]");
    return 1;
  }
  for(i=0;i<10;i++)
    tosh_res[i]='\0';
  for (i=1;i<=10;i++)
  {
    res=brute_tosh(but, 0,i);
   if (res) break;
  }
  if(res)
  {
    putchar('[');
    for (i=tosh_pos-1;i>=0;i--)
      putchar(scan2ascii(tosh_res[i]));
    putchar(']');
  }
  else
    printf("\nEchec");
  return res;
}

void acer()				/* ACER */
{
  printf(m_acer);
  generic_basic(0x27, 7, ALGO_ACER,0,AFF_SCAN,cmos);
  generic_basic(0x100, 7,  ALGO_ACER, 0,AFF_ASCII,cmos);
}

void ami_old()				/* AMI */
{
  printf(m_ami_old);
  generic_basic(0x37, 1+6, ALGO_AMI_F0,0,AFF_ASCII,cmos);
}

void ami_winbios()
{
  printf(m_ami_winbios);
  generic_basic(0x37, 1+6, ALGO_AMI,0,AFF_SCAN,cmos);
}

void ami_winbios2()
{
  printf(m_ami_winbios25);
  generic_basic(0x37, 1+6, ALGO_AMI_80,0,AFF_SCAN,cmos);
  generic_basic(0x4B, 1+6, ALGO_AMI_80,0,AFF_SCAN,cmos);
  /* setup, Added by Tompa Lorand, 01-apr-2003 */
  generic_basic(0x5f, 1+6, ALGO_AMI_80,0,AFF_SCAN,cmos);
  /* AMI Bios (1985-2003) version 2.54 */
  generic_basic(0x60, 1+6, ALGO_AMI_80,0,AFF_SCAN,cmos);

}

void ami_unk()
{
  /*  Philippe Biondi */
  printf(m_ami_unk);
  generic_basic(0x4d, 1+7, ALGO_AMI_80,0,AFF_SCAN,cmos);
  generic_basic(0x54, 1+7, ALGO_AMI_80,0,AFF_SCAN,cmos);
  /* Rajabaz */
  generic_basic(0x4c, 1+7, ALGO_AMI_80,0,AFF_SCAN,cmos);
  generic_basic(0x53, 1+7, ALGO_AMI_80,0,AFF_SCAN,cmos);
  /* Bidouilleurs LBCU */
  generic_basic(0x50, 1+7, ALGO_AMI_80,0,AFF_SCAN,cmos);
}

void samsung()
{
  printf(m_samsung_P25);
  generic_basic(0xE3,7,ALGO_NONE,0,AFF_SCAN,cmos);
  generic_basic(0xF0,7,ALGO_NONE,0,AFF_SCAN,cmos);
  generic_basic(0xF8,7,ALGO_NONE,0,AFF_SCAN,cmos);
}

void sony_vaio()
{
  printf(m_Sony_Vaio);
  generic_basic(0x00,7,ALGO_ACER,0,AFF_ASCII,cmos);
  putchar(' ');
  generic_basic(0x07,7,ALGO_ACER,0,AFF_ASCII,cmos);
#ifdef __linux__
  {
    FILE *fb;
    unsigned char eeprom[14];
    fb=fopen("/sys/bus/i2c/devices/0-0057/eeprom","r");
    if(!fb)
      return ;
    fread(&eeprom,1,14,fb);
    fclose(fb);
    putchar(' ');
    generic_basic(0x00,7,ALGO_ACER,0,AFF_ASCII,eeprom);
    putchar(' ');
    generic_basic(0x07,7,ALGO_ACER,0,AFF_ASCII,eeprom);
  }
#endif
}

/* AMI          @art.fr         CRC+Crypted adm pwd at 38-3F, filled with 00
 *                              user pwd at 0x40-47     */
void zenith_ami()
{
  printf(m_zenith_ami);
  generic_basic(0x38+1, 7, ALGO_UNKNOW,0,AFF_ASCII,cmos);
  putchar(' ');
  generic_basic(0x40+1, 7, ALGO_UNKNOW,0,AFF_ASCII,cmos);
}



				/* AWARD */
void award()
{
  printf(m_award);
  generic_crc(ALGO_AWARD,0x1C,cmos);
  generic_crc(ALGO_AWARD,0x60,cmos);
  generic_crc(ALGO_AWARD,0x4D,cmos);
  printf(m_award);
  generic_crc(ALGO_AWARD,0x63,cmos);
  generic_crc(ALGO_AWARD,0x64,cmos); /* jedi_ukgateway_net */
  generic_crc(ALGO_AWARD,0x5D,cmos); /* Setup YOGESH M */
  generic_crc(ALGO_AWARD,0x3E,cmos); /* User slug(at)navigator.lv */
}

void award_medallion()
{
/* Pencho Penchev <ppencho@hotmail.com>
   Hewllett Packard Brio system
*/
  printf(m_award_medallion);
  generic_crc(ALGO_AWARD,0x68,cmos);	/* supervisor */
  generic_crc(ALGO_AWARD,0x6A,cmos); /* user */
  generic_crc(ALGO_AWARD,0x4E,cmos); /*  Lewis DH */
  generic_crc(ALGO_AWARD,0x71,cmos); /*  Lewis DH */
}

void award6()
{
  printf(m_award6);
  /* Tompa Lorand-Mihaly, april 2003 */
  generic_basic(0xE0, 8, ALGO_AWARD6,0,AFF_ASCII,cmos);
  /* Ai-Nung Wang, october 2003 */
  generic_basic(0xB0, 8, ALGO_AWARD6,0,AFF_ASCII,cmos);
  /* Jason Gorski, january 2005 */
  generic_basic(0x90, 8,  ALGO_AWARD6, 0, AFF_ASCII,cmos);
  /* daiver1989 mail ru, april 2006 */
  generic_basic(0xB4, 8,  ALGO_AWARD6, 0, AFF_ASCII,cmos);
}

				/* COMPAQ */
void compaq()
{
  printf(m_compaq);
  generic_basic(0x38, 8, ALGO_NONE,0,AFF_SCAN,cmos);
}

void compaq2()
{
  printf(m_compaq2);
  generic_basic(0x51, 7, ALGO_NONE,0,AFF_SCAN,cmos); /* setup */
  generic_basic(0x38, 7, ALGO_NONE,0,AFF_SCAN,cmos);
}


void compaq_deskpro()
{
  printf(m_compaq_deskpro);
  /* - Luka "The /\/\ighty \/\/izzy"
   *   Compaq 5200, August 1998
   */
  generic_basic(0x37, 8, ALGO_COMPAQ,0,AFF_SCAN,cmos);
   /* - Quattrocchi Stefano
    *   Compaq DeskPro EP Serie 6350/6.4 EA2, May 2001
    */
  generic_basic(0x77, 8, ALGO_COMPAQ,0,AFF_SCAN,cmos);
}


				/* IBM */
void ibm()
{
  printf(m_ibm);
  generic_basic(0x48, 7, ALGO_NONE,0,AFF_SCAN,cmos);
  generic_basic(0x38, 7, ALGO_NONE,0,AFF_SCAN,cmos);
}

void ibm_thinkpad()
{
  printf(m_ibm_thinkpad);
  generic_basic(0x38, 7, ALGO_NONE,0,AFF_SCAN,cmos);	/* pwd boot */
}

void ibm_thinkpad2()
{
  printf(m_ibm_thinkpad_x20_570_t20);
  generic_basic(0x338, 7, ALGO_NONE,0,AFF_SCAN,cmos);
  generic_basic(0x3B8, 7, ALGO_NONE,0,AFF_SCAN,cmos);
  printf(m_ibm_thinkpad_560x);
  generic_basic(0x38, 7, ALGO_NONE,0,AFF_SCAN,cmos);
  generic_basic(0x40, 7, ALGO_NONE,0,AFF_SCAN,cmos);
  printf(m_ibm_thinkpad_765_380z);
  generic_basic(0x38, 7, ALGO_NONE,0,AFF_SCAN,cmos);
  generic_basic(0x40, 7, ALGO_NONE,0,AFF_SCAN,cmos);
}

void ibm_300()
{
  printf(m_ibm_300);
  generic_basic(0x48, 7, ALGO_NONE,0,AFF_SCAN,cmos);
}

void packardbell()				/* PACKARD BELL */
{
  printf(m_packardbell);
  generic_basic(0x38, 1+7, ALGO_PACKARD,0xFF,AFF_ASCII,cmos);
  putchar(' ');
  generic_basic(0x40, 1+7, ALGO_PACKARD,0xFF,AFF_ASCII,cmos);
}

void phoenix()				/* PHOENIX */
{
  static const int tbl_phoenix[8]={0x39,0x3C,0x3B,0x3F,0x38,0x3E,0x3D,0x3A};
  unsigned int value[8];
  uint8_t res[9];
  uint8_t crc=0;
  uint8_t i;
  printf(m_phoenix);
  table2val(value, cmos, 8,tbl_phoenix);
  printf("[");
  for (i=0;i<7 && value[i]!=0;i++)
  {
    printf("%c",filtre(res[i]));
    res[i]=(value[i] ^ 0xF0) + i;
    crc+=res[i];
  }
  printf("]");
  if (crc!=value[7])
    printf(" CRC pwd err");
}

void phoenix_1_03()
{
  printf(m_phoenix_1_03);
  if(((cmos[0x60]==0)||(cmos[0x60]==1))&&(cmos[0x61]<=7))
    generic_basic(0x62, cmos[0x61], ALGO_PHOENIX_ADD,0xFF,AFF_ASCII,cmos);
  else
    printf("err");
  /* CRC 32 en 7E
   * 3B-3D => 6A-6C
   * 40 => 6F
   * */
}

void phoenix_1_04()
{
  printf(m_phoenix_1_04);
  generic_basic(0x50, 7, ALGO_NONE,0,AFF_SCAN,cmos); /* setup */
  generic_basic(0x48, 7, ALGO_NONE,0,AFF_SCAN,cmos);
}

void phoenix_1_10()
{ /* Phoenix Bios V1.10 A03 / Dell GXi */
  printf(m_phoenix_1_10);
  if(!check_crcadd(0x1D,7,0x1D+7) || !check_crcadd(0x38,7,0x38+7))
  {
    printf("CRC pwd err");
    return;
  }
  generic_basic(0x1D, 7, ALGO_NONE,0,AFF_SCAN,cmos); /* setup */
  generic_basic(0x38, 7, ALGO_NONE,0,AFF_SCAN,cmos);
}

void phoenix4()
{
  printf(m_phoenix4);
  generic_basic(0x35, 7, ALGO_NONE,0,AFF_SCAN,cmos); /* user */
}

void phoenix405()
{
  static const int tbl[8]={0x45,0x52,0x4b,0x4a,0x50,0x4F,0x4D,0x48};
  static const int tbl2[8]={0x4c,0x51,0x49,0x54,0x53,0x47,0x46,0x4E};
  unsigned int value[8];
  printf(m_phoenix405);
  table2val(value, cmos, 8, tbl);
  generic_table(value, 8, ALGO_NONE,0,AFF_SCAN);
  table2val(value, cmos, 8, tbl2);
  generic_table(value, 8, ALGO_NONE,0,AFF_SCAN);
}

void phoenix406()
{
  printf(m_phoenix406);
  generic_basic(0x45, 8, ALGO_NONE,0,AFF_SCAN,cmos);
}
void phoenix_40_r_60()
{
  printf(m_phoenix_40_r_60);
  generic_basic(0x35, 7, ALGO_PHOENIX_DEC,0,AFF_SCAN,cmos);
}

void dtk()
{
  printf(m_dtk);
  generic_basic(0x38,4,ALGO_DTK,0,AFF_ASCII,cmos);
  generic_basic(0x3B,6,ALGO_DTK,0,AFF_ASCII,cmos);
}


void gateway_ph()
{	/* Gateway Solo */
  printf(m_gateway_ph);
  generic_basic(0x40, 7, ALGO_NONE,0,AFF_SCAN,cmos);
  generic_basic(0x47, 7, ALGO_NONE,0,AFF_SCAN,cmos);
}

void phoenixa08()
{
  printf(m_phoenixa08);
  generic_basic(0x23, 7, ALGO_NONE,0,AFF_SCAN,cmos);
  generic_basic(0x42, 7, ALGO_NONE,0,AFF_SCAN,cmos);
}

void toshiba()
{
  printf(m_toshiba);
  generic_crc(ALGO_TOSHIBA,0x35,cmos);
  generic_crc(ALGO_TOSHIBA,0x33,cmos);
}


void set_permissions()
{
#if defined(__linux__)
  if (ioperm(PORT_CMOS_0,4*2,IO_READ|IO_WRITE))
  {
    printf("Need to be run as root to access the Cmos.\n");
    exit(1);
  }
#elif defined(__CYGWIN32__) || defined(__MINGW32__)
  if (ioperm(PORT_CMOS_0,4*2,IO_READ|IO_WRITE))
  {
    printf("As administrator, run \"ioperm.exe -i\" before.\n");
    exit(1);
  }
#elif defined(WIN32)
  char OutputBuffer[100];
  char InputBuffer[100];
HANDLE h;
  BOOLEAN bRc;
  ULONG uint8_tsReturned;
  h = CreateFile("\\\\.\\gwiopm", GENERIC_READ, 0, NULL,
					OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
  if(h == INVALID_HANDLE_VALUE) {
	printf("Couldn't access gwiopm device\n");
	exit(2);
  }
  memset(OutputBuffer, 0, sizeof(OutputBuffer));
  InputBuffer[0]=0x70>>3;
	InputBuffer[1]=0;       /* 0x70 et 0x71 */
	bRc = DeviceIoControl ( h, 
					(DWORD) IOCTL_IOPMD_SET_LIOPM, 
					&InputBuffer, 
					2, 
					&OutputBuffer,
		    sizeof( OutputBuffer),
			&uint8_tsReturned,
					NULL 
					);
	if(bRc!=TRUE)
		printf("Set_LIOPM failed");
//IOCTL_IOPMD_ACTIVATE_KIOPM
	bRc = DeviceIoControl ( h, 
					(DWORD) IOCTL_IOPMD_ACTIVATE_KIOPM, 
					&InputBuffer, 
					2, 
					&OutputBuffer,
		    sizeof( OutputBuffer),
			&uint8_tsReturned,
					NULL 
					);
	if(bRc!=TRUE)
		printf("ACTIVATE_KIOPM failed");
	CloseHandle(h);

#elif defined(__NetBSD__)
	if(i386_iopl(3)!=0) {
	  perror("i386_iopl");
	  exit(1);
	}
#elif defined(__FreeBSD__)
    cmos_fd = fopen("/dev/io", "r");
    if(cmos_fd==NULL){
       perror("fopen /dev/io failed");
       exit(1);
    }

#endif
}

void unset_permissions()
{
#ifdef __linux__
  ioperm(PORT_CMOS_0,4*2,0);
#elif defined(__FreeBSD__)
  fclose(cmos_fd);
#endif
}

uint8_t read_cmos(const unsigned int cell);
void write_cmos(const unsigned int cell, const uint8_t value);
uint8_t read_cmos(const unsigned int cell)
{
  if(cell<128)
  {
    outportb(PORT_CMOS_0,cell);
    return inportb(PORT_CMOS_1);
  }
  if(cell<2*128)
  {
    outportb(PORT_CMOS_2,cell);
    return inportb(PORT_CMOS_3);
  }
#if !defined(WIN32) || defined(__MINGW32__)
  if(cell<3*128)
  {
    outportb(PORT_CMOS_4,cell);
    return inportb(PORT_CMOS_5);
  }
  if(cell<4*128)
  {
    outportb(PORT_CMOS_6,cell);
    return inportb(PORT_CMOS_7);
  }
#endif
  return 0;
}

void write_cmos(const unsigned int cell, const uint8_t value)
{
  if(cell<128)
  {
    outportb(PORT_CMOS_0,cell);
    outportb(PORT_CMOS_1,value);
    return;
  }
  if(cell<2*128)
  {
    outportb(PORT_CMOS_2,cell);
    outportb(PORT_CMOS_3,value);
    return;
  }
  if(cell<3*128)
  {
    outportb(PORT_CMOS_4,cell);
    outportb(PORT_CMOS_5,value);
    return;
  }
  if(cell<4*128)
  {
    outportb(PORT_CMOS_6,cell);
    outportb(PORT_CMOS_7,value);
    return;
  }
}

int kill_cmos(const int cmos_size)
{
  int i;
  char car;
  printf("Warning: if the password is stored in an eeprom (laptop/notebook), the password won't be erased.\n"
         "\n1 - Kill cmos"
	 "\n2 - Kill cmos (try to keep date and time)"
	 "\n0 - Abort"
	 "\nChoice : ");
  fflush(stdout);
  do
  {
   car=toupper(getchar());
  }
  while((car<'0')||(car>'2'));
  fflush(stdout);
  if(car=='0')
    return 1;
  set_permissions();
  for (i=(car=='1'?0:0x10);i<cmos_size;i++)
    write_cmos(i,0);
  unset_permissions();
  printf("\nCmos killed!");
  if(car=='1')
    printf("\nRemember to set date and time");
  return 0;
}

int load_cmos(const int cmos_size)
{
  int i;
  set_permissions();
  for (i=0;i<cmos_size;i++)
    cmos[i]=read_cmos(i);
  unset_permissions();
  return 0;
}

int restore_cmos(const int cmos_size,const int choix)
{
  int i;
  char car='2';
  if(choix)
  {
    printf("\n1 - Restore full cmos"
	  "\n2 - Restore cmos (keep date and time)"
	  "\n0 - Abort"
	  "\nChoice : ");
    fflush(stdout);
    do
    car=toupper(getchar());
    while((car<'0')||(car>'2'));
    printf("%c\n", car);
    fflush(stdout);
    if(car=='0')
      return 1;
  }
  set_permissions();
  for (i=(car=='1'?0:0x10);i<cmos_size;i++)
    write_cmos(i,cmos[i]);
  unset_permissions();
  if(car=='1')
    printf("\nRemember to set date and time");
  return 0;
}

int load_backup(const char* name)
{
  FILE *fb;
  unsigned char buffer[TAILLE_BUFFER+1];
  unsigned int taille,i;
  int cmos_size=0;
  fb=fopen(name,"rb");
  if (fb==0)
  {
    printf("\nUnable to read %s\n", name);
    return -1;
  }
  printf("\nload_backup(%s)",name);
  taille=fread(buffer,1, TAILLE_BUFFER,fb);
  fclose(fb);
  if((taille==64)||(taille==128)||(taille==256)||(taille==384)||(taille==512))
  {
    printf("\nRead a %d byte cmos backup (%s)",taille, name);
    for(i=0;i<taille;i++)
      cmos[i]=buffer[i];
    cmos_size=taille;
  }
  else
  if((taille==64-0x10)||(taille==128-0x10)||(taille==256-0x10))
  {
    printf("\nRead a %d byte cmos backup, first 16 byte skipped",taille);
    for(i=0x10;i<taille;i++)
      cmos[i]=buffer[i-0x10];
    cmos_size=taille+0x10;
  }
  else
  if(taille==0x400+TAILLE_CMOS-0x10)
  {
    printf("\nRead a cmos backup from a SAUVER file");
    for(i=0x10;i<TAILLE_CMOS;i++)
      cmos[i]=buffer[0x400+i-0x10];
    cmos_size=TAILLE_CMOS;
  }
  else
  if(taille==129)
  {
    printf("\nRead a %d byte cmos !BIOS backup (%s)",taille, name);
    for(i=0;i<taille;i++)
      cmos[i]=buffer[i];
    cmos_size=TAILLE_CMOS;
  }
  else
  {
    if(memcmp(buffer,"0000000 ",8)==0)
    {
      unsigned int pos_file;
      int pos_cmos=0;
      for(pos_file=8;pos_file<taille;)
      {
	char string[3];
	string[0]=buffer[pos_file];
	string[1]=buffer[pos_file+1];
	string[2]=0;
	cmos[pos_cmos++]=(unsigned char)strtol(string,NULL,16);
	pos_file+=2;
	if(pos_cmos%16==0)
	{
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  pos_file+=8;
	}
	else
	{
	  if(buffer[pos_file]==' ')
	    pos_file++;
	}
      }
      cmos_size=pos_cmos;
    }
    else if(memcmp(buffer,"00000000 ",9)==0)
    {
      unsigned int pos_file;
      int pos_cmos=0;
      for(pos_file=9;pos_file<taille;)
      {
	char string[3];
	string[0]=buffer[pos_file];
	string[1]=buffer[pos_file+1];
	string[2]=0;
	cmos[pos_cmos++]=(unsigned char)strtol(string,NULL,16);
	if(pos_cmos%16==0)
	{
	  pos_file+=3+16;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  pos_file+=9;
	}
	else
	  pos_file+=3;
      }
      cmos_size=pos_cmos-1;
    }
    else if(memcmp(buffer,":10000000",9)==0)
    {
      unsigned int pos_file;
      int pos_cmos=0;
      for(pos_file=9;pos_file<taille;)
      {
	char string[3];
	string[0]=buffer[pos_file];
	string[1]=buffer[pos_file+1];
	string[2]=0;
	cmos[pos_cmos++]=(unsigned char)strtol(string,NULL,16);
	if(pos_cmos%16==0)
	{
	  pos_file+=4;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  pos_file+=9;
	}
	else
	  pos_file+=2;
      }
      cmos_size=pos_cmos-1;
    }
    else if(memcmp(buffer,":08000000",9)==0)
    {
      unsigned int pos_file;
      int pos_cmos=0;
      for(pos_file=9;pos_file<taille;)
      {
	char string[3];
	string[0]=buffer[pos_file];
	string[1]=buffer[pos_file+1];
	string[2]=0;
	cmos[pos_cmos++]=strtol(string,NULL,16);
	if(pos_cmos%8==0)
	{
	  pos_file+=4;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  pos_file+=9;
	}
	else
	  pos_file+=2;
      }
      cmos_size=pos_cmos-1;
    }
    else if(memcmp(buffer,":06000000",9)==0)
    {
      int pos_file;
      int pos_cmos=0;
      for(pos_file=9;pos_file<taille;)
      {
	char string[3];
	string[0]=buffer[pos_file];
	string[1]=buffer[pos_file+1];
	string[2]=0;
	cmos[pos_cmos++]=strtol(string,NULL,16);
	if(pos_cmos%6==0)
	{
	  pos_file+=4;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  pos_file+=9;
	}
	else
	  pos_file+=2;
      }
      cmos_size=pos_cmos-1;
    }
    else if(memcmp(buffer,":10000000",9)==0)
    {
      int pos_file;
      int pos_cmos=0;
      for(pos_file=9;pos_file<taille;)
      {
	char string[3];
	string[0]=buffer[pos_file];
	string[1]=buffer[pos_file+1];
	string[2]=0;
	cmos[pos_cmos++]=strtol(string,NULL,16);
	if(pos_cmos%6==0)
	{
	  pos_file+=4;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  pos_file+=9;
	}
	else
	  pos_file+=2;
      }
      cmos_size=pos_cmos-1;
    }
    else if(memcmp(buffer,"\r\n00  ",6)==0)
    {
      int pos_file;
      int pos_cmos=0;
      for(pos_file=6;pos_file<taille;)
      {
	char string[3];
	string[0]=buffer[pos_file];
	string[1]=buffer[pos_file+1];
	string[2]=0;
	cmos[pos_cmos+1]=strtol(string,NULL,16);
	pos_file+=2;
	string[0]=buffer[pos_file];
	string[1]=buffer[pos_file+1];
	string[2]=0;
	cmos[pos_cmos]=strtol(string,NULL,16);
	pos_file+=2;
	pos_cmos+=2;
	if(pos_cmos%16==0)
	{
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  pos_file+=4;
	}
	else
	  pos_file++;
      }
      cmos_size=pos_cmos-1;
    }
    else if(memcmp(buffer,"E2P!Lanc",8)==0)
    {
      taille-=152;
      if(taille>TAILLE_CMOS_MAX)
	taille=TAILLE_CMOS_MAX;
      for(i=0;i<taille;i++)
	cmos[i]=buffer[152+i];
      cmos_size=taille;
    }
    else if(buffer[0]>='0' && buffer[0]<='9' &&
	  buffer[1]>='0' && buffer[1]<='9' &&
	  buffer[2]==',')
    {
      int pos_file;
      int pos_cmos=0;
      for(pos_file=0;pos_file<taille;)
      {
	char string[3];
	string[0]=buffer[pos_file];
	string[1]=buffer[pos_file+1];
	string[2]=0;
	cmos[pos_cmos++]=strtol(string,NULL,16);
	pos_file+=3;
	if(pos_cmos%8==0)
	{
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	  if(buffer[pos_file]==0xA || buffer[pos_file]==0xD)
	    pos_file++;
	}
      }
      cmos_size=pos_cmos-1;
    }
    else
    {
      printf("\nUnknown file format");
      if(taille>TAILLE_CMOS_MAX)
	taille=TAILLE_CMOS_MAX;
      for(i=0;i<taille;i++)
	cmos[i]=buffer[i];
      cmos_size=taille;
    }
  }
  return cmos_size;
}

int save_backup(const int cmos_size, const char* name)
{
  FILE *fb;
  fb=fopen(name,"wb");
  if (fb==0)
  {
    printf("\nUnable to create %s", name);
    return 1;
  }
  if(fwrite(cmos,1, cmos_size,fb)!=cmos_size)
  {
    printf("\nWrite error");
    return 1;
  }
  fclose(fb);
  return 0;
}

#ifdef __linux__
void award_backdoor()
{
  int i;
  char car;
  FILE *fb;
  fb=fopen("/dev/mem","r");
  if(!fb)
    return ;
  fseek(fb,(0xF000<<4)+0xEC60,SEEK_SET);
  printf("Award backdoor [");
  for(i=0;i<8;i++)
  {
    fread(&car,1,1,fb);
    putchar(filtre((car<<5)|(car>>5)|(car&0x18)));
  }
  fclose(fb);
  printf("]\n");
}
#endif

void keyb_mem()
{
#ifdef __linux__
  FILE *fb;
  unsigned char mem[32];
  int i;
  fb=fopen("/dev/mem","r");
  if(!fb)
    return ;
  printf(m_Keyb_Mem);
  fseek(fb,0x041f,SEEK_SET);
  fread(&mem,1,sizeof(mem),fb);
  fclose(fb);
  printf("[");
  for(i=0;i<sizeof(mem) && mem[i]!=0;i+=2)
    printf("%c", filtre(scan2ascii(mem[i])));
  printf("]\n");
#endif
}

void wait_key()
{
  printf("\nPress Enter key to continue");
  fflush(stdout);
  getchar();
}

void convert_uchar2uint(unsigned int *dst, const unsigned char *src, const unsigned int cmos_size)
{
  unsigned int i;
  for(i=0;i<cmos_size;i++)
    dst[i]=src[i];
}

void convert_scancode2ascii(unsigned int*dst, const unsigned int lng)
{
  unsigned int i;
  for (i=0;i<lng && dst[i]!=VAL_STOP;i++)
    if(dst[i]!=VAL_UNK)
      dst[i]=scan2ascii(dst[i]);
}

/* MAIN PROGRAM */
int main(int argc, char *argv[])
{
  int arg_load_filename=-1;
  int arg_save_filename=-1;
  int arg_module=-1;
  int do_dump=0;
  int cmos_size=TAILLE_CMOS;
  enum {MODE_NORM,MODE_HELP,MODE_LOAD, MODE_SAVE, MODE_KILL, MODE_RESTORE, MODE_RESTORE_FORCE} mode=MODE_NORM;
  printf("CmosPwd - BIOS Cracker 5.0, October 2007, Copyright 1996-2007\n"
	 "GRENIER Christophe, grenier@cgsecurity.org\n"
	 "http://www.cgsecurity.org/\n");
  memset(cmos, 0, sizeof(cmos));
  {
    int i;
    for(i=1;i<argc;i++)
    {
      if(i==arg_module || i==arg_load_filename || i==arg_save_filename)
      {
      }
      else if(strcmp(argv[i],"/kfr")==0 || strcmp(argv[i],"-kfr")==0)
	keyb=KEYB_FR;
      else if(strcmp(argv[i],"/kde")==0 || strcmp(argv[i],"-kde")==0)
	keyb=KEYB_DE;
      else if(strcmp(argv[i],"/d")==0 || strcmp(argv[i],"-d")==0)
	do_dump=1;
      else if(strcmp(argv[i],"/r")==0 || strcmp(argv[i],"-r")==0)
      {
	if(mode!=MODE_NORM) mode=MODE_HELP; else mode=MODE_RESTORE;
	arg_load_filename=i+1;
      }
      else if(strcmp(argv[i],"/R")==0 || strcmp(argv[i],"-R")==0)
      {
	if(mode!=MODE_NORM) mode=MODE_HELP; else mode=MODE_RESTORE_FORCE;
	arg_load_filename=i+1;
      }
      else if(strcmp(argv[i],"/l")==0 || strcmp(argv[i],"-l")==0)
      {
	if(mode!=MODE_NORM) mode=MODE_HELP; else mode=MODE_LOAD;
	arg_load_filename=i+1;
      }
      else if(strcmp(argv[i],"/w")==0 ||strcmp(argv[i],"/s")==0 || strcmp(argv[i],"-w")==0 || strcmp(argv[i],"-s")==0)
      {
	 if(mode!=MODE_NORM) mode=MODE_HELP; else mode=MODE_SAVE;
	 arg_save_filename=i+1;
      }
      else if(strcmp(argv[i],"/k")==0 || strcmp(argv[i],"-k")==0)
      {
	if(mode!=MODE_NORM) mode=MODE_HELP; else mode=MODE_KILL;
      }
      else if(strncmp(argv[i],"/m",2)==0 || strncmp(argv[i],"-m",2)==0)
	arg_module=i;
      else
	mode=MODE_HELP;
      if(mode==MODE_HELP)
	break;
    }
  }
  if(arg_load_filename>=argc || arg_save_filename>=argc)
    mode=MODE_HELP;
  switch(mode)
  {
    case MODE_HELP:
      printf(
      "\nUsage: cmospwd [/k[de|fr]] [/d]"
      "\n       cmospwd [/k[de|fr]] [/d] /[wlr] cmos_backup_file           write/load/restore"
      "\n       cmospwd /k                                          kill cmos"
      "\n       cmospwd [/k[de|fr]] /m[01]*	execute selected module"
      "\n"
      "\n /kfr french AZERTY keyboard, /kde german QWERTZ keyboard"
      "\n /d to dump cmos"
      "\n /m0010011 to execute module 3,6 and 7"
      "\n"
      "\nNB: For Award BIOS, passwords are differents than original, but work."
      "\n");
      return 0;
    case MODE_KILL:
      return kill_cmos(cmos_size);
    case MODE_RESTORE:
      if(arg_load_filename<0)
      {
	printf("\nMissing filename\n");
	return 1;
      }
      if((cmos_size=load_backup(argv[arg_load_filename]))<0)
	return 1;
      return restore_cmos(cmos_size,1);
    case MODE_RESTORE_FORCE:
      if(arg_load_filename<0)
      {
	printf("\nMissing filename\n");
	return 1;
      }
      if((cmos_size=load_backup(argv[arg_load_filename]))<0)
	return 1;
      return restore_cmos(cmos_size,0);
    case MODE_LOAD:
      if(arg_load_filename<0)
      {
	printf("\nMissing filename\n");
	return 1;
      }
      if((cmos_size=load_backup(argv[arg_load_filename]))<0)
	return 1;
      break;
    case MODE_NORM:
      if(load_cmos(cmos_size))
	return 1;
      break;
    case MODE_SAVE:
      if(arg_save_filename<0)
      {
	printf("\nMissing filename\n");
	return 1;
      }
      if(load_cmos(cmos_size))
	return 1;
      return save_backup(cmos_size,argv[arg_save_filename]);
  }
  switch(keyb)
  {
    case KEYB_FR:
      printf("\nKeyboard : FR");
      break;
    case KEYB_DE:
      printf("\nKeyboard : DE");
      break;
    case KEYB_US:
    default:
      printf("\nKeyboard : US");
      break;
  }
  if(arg_module>=0)
  {
    unsigned int i;
    for(i=0;argv[arg_module][i+2] && (i<nbr_func);i++)
    {
      if(argv[arg_module][i+2]=='1')
	tbl_func[i]();
    }
  }
  else
  {
    unsigned int i;
    for(i=0;i<nbr_func;i++)
    {
      if(i>0 && i%17==0)
	wait_key();
      tbl_func[i]();
    }
  }
#ifdef __linux__
  award_backdoor();
#endif
  if(do_dump)
  {
    unsigned int*cmos_processed=(unsigned int*)malloc(sizeof(unsigned int)*cmos_size);
    wait_key();
    printf("\nDump cmos\n");
    convert_uchar2uint(cmos_processed,cmos,cmos_size);
    dump(cmos,cmos_processed,cmos_size);
    wait_key();
    printf("\nDump cmos (Scan code convertion)\n");
    convert_uchar2uint(cmos_processed,cmos,cmos_size);
    convert_scancode2ascii(cmos_processed,cmos_size);
    dump(cmos,cmos_processed,cmos_size);
    wait_key();
    printf("\nDump cmos (ACER convertion)\n");
    convert_uchar2uint(cmos_processed,cmos,cmos_size);
    generic_acer(cmos_processed,cmos_size);
    dump(cmos,cmos_processed,cmos_size);
    wait_key();
    printf("\nDump cmos (ACER + Scan code convertion)\n");
    convert_uchar2uint(cmos_processed,cmos,cmos_size);
    generic_acer(cmos_processed,cmos_size);
    convert_scancode2ascii(cmos_processed,cmos_size);
    dump(cmos,cmos_processed,cmos_size);
    wait_key();
    printf("\nDump cmos (AMI convertion)\n");
    convert_uchar2uint(cmos_processed,cmos,cmos_size);
    generic_ami(cmos_processed,cmos_size,ALGO_AMI);
    dump(cmos,cmos_processed,cmos_size);
    wait_key();
    printf("\nDump cmos (AMI + Scan code convertion)\n");
    convert_uchar2uint(cmos_processed,cmos,cmos_size);
    generic_ami(cmos_processed,cmos_size,ALGO_AMI);
    convert_scancode2ascii(cmos_processed,cmos_size);
    dump(cmos,cmos_processed,cmos_size);
    free(cmos_processed);
  }
#ifndef __MSDOS__ 
  printf("\n");
  fflush(stdout);
#endif
  return 0;
}
