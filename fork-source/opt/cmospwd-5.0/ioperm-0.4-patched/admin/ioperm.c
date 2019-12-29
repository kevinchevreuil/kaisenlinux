/*
 * $Id: ioperm.c,v 1.4 2003/01/23 15:16:35 telka Exp $
 *
 * Copyright (C) 2002 ETC s.r.o.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 *
 * Written by Marcel Telka <marcel@telka.sk>, 2002.
 *
 */

#include <stdio.h>
#ifdef __CYGWIN__
#define HAVE_POPT_H 1
#endif

#ifdef HAVE_POPT_H
#include <popt.h>
#endif

#ifndef PACKAGE
#define PACKAGE "ioperm"
#endif

#ifndef PACKAGE_STRING
#define PACKAGE_STRING "ioperm 0.4 modified by C.Grenier"
#endif

#include <windows.h>

int install( int );
int uninstall( int );

int
main( int argc, const char **argv )
{
	int i = 0;
	int u = 0;
	int v = 0;
	int verb = 0;
	OSVERSIONINFO version;
#ifdef HAVE_POPT_H
	poptContext popt_context;
	int rc;
#endif

#ifdef HAVE_POPT_H
	struct poptOption options_table[] = {
		{ "install", 'i', POPT_ARG_NONE, &i, 0, "Install ioperm.sys driver", NULL },
		{ "uninstall", 'u', POPT_ARG_NONE, &u, 0, "Uninstall ioperm.sys driver", NULL },
		{ "version", 'V', POPT_ARG_NONE, &v, 0, "Output version information and exit", NULL },
		{ "verbose", 'v', POPT_ARG_NONE, &verb, 0, "Verbose output", NULL },
		POPT_AUTOHELP
		POPT_TABLEEND
	};

	popt_context = poptGetContext( NULL, argc, argv, options_table, 0 );
	poptSetOtherOptionHelp( popt_context, "[--help] [-V] [-v] [-i|-u]" );

	rc = poptGetNextOpt( popt_context );
	if (rc != -1) {
		poptPrintUsage( popt_context, stderr, 0 );
		poptFreeContext( popt_context );
		return -1;
	}
#else
  {
    int j;
    for(j=0;j<argc;j++)
    {
      if(strcmp(argv[j],"--install")==0 || strcmp(argv[j],"-i")==0)
      {
	i=1;
      }
      else if(strcmp(argv[j],"--uninstall")==0 || strcmp(argv[j],"-u")==0)
      {
	u=1;
      }
      else if(strcmp(argv[j],"--version")==0 || strcmp(argv[j],"-V")==0)
      {
	v=1;
      }
      else if(strcmp(argv[j],"--verbose")==0 || strcmp(argv[j],"-v")==0)
      {
	verb=1;
      }
    }
  }
#endif

	if (v) {
		printf( 
			"%s for Cygwin\n"
			"Copyright (C) 2002, 2003 ETC s.r.o.\n"
			"%s is free software, covered by the GNU General Public License, and you are\n"
			"welcome to change it and/or distribute copies of it under certain conditions.\n"
			"There is absolutely no warranty for %s.\n"
			"Written by Marcel Telka\n", PACKAGE_STRING, PACKAGE, PACKAGE
		);
#ifdef HAVE_POPT_H
		poptFreeContext( popt_context );
#endif
		return 0;
	}

	if (!(i ^ u)) {
#ifdef HAVE_POPT_H
		poptPrintUsage( popt_context, stderr, 0 );
		poptFreeContext( popt_context );
#else
		printf("Usage: ioperm [--help] [-V] [-v] [-i|-u]\n" \
		    "  -i, --install       Install ioperm.sys driver\n" \
		    "  -u, --uninstall     Uninstall ioperm.sys driver\n" \
		    "  -V, --version       Output version information and exit\n" \
		    "  -v, --verbose       Verbose output\n" \
		    "\n" \
		    "Help options:\n" \
		    "  -?, --help          Show this help message\n");
#endif
		return -1;
	}

#ifdef HAVE_POPT_H
	poptFreeContext( popt_context );
#endif

	version.dwOSVersionInfoSize = sizeof version;
	if (!GetVersionEx( &version )) {
		printf( "Error: Cannot get version info from Windows.\n" );
		return -1;
	}

	if (version.dwPlatformId != VER_PLATFORM_WIN32_NT) {
		if (i)
			printf( "Installation is not required for non-NT system.\n" );
		else
			printf( "Uninstallation is not required for non-NT system.\n" );
		return 0;
	}

	if (i)
		if (!install( verb )) {
			fprintf( stderr, "Error: ioperm.sys installation failed.\n" );
			return -1;
		}

	if (u)
		if (!uninstall( verb )) {
			fprintf( stderr, "Error: ioperm.sys uninstallation failed.\n" );
			return -1;
		}

	return 0;
}
