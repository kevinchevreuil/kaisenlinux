/*
 * $Id: install.c,v 1.5 2003/01/23 15:16:35 telka Exp $
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

#include <windows.h>
#include <stdio.h>

#ifdef __CYGWIN__
#include <sys/cygwin.h>
#endif

#ifdef __MINGW32__
#include <io.h>
#endif

void
start( int verb, const char *fnc )
{
	if (verb)
		printf( "%-20s", fnc );
}

void
err( int verb, const char *fnc )
{
	if (verb)
		printf( "failed\n" );
	else
		fprintf( stderr, "%s function call failed.\n", fnc );
}

void
ok( int verb )
{
	if (verb)
		printf( "ok\n" );
}

int
install( int verb )
{
	SC_HANDLE scm;
	SC_HANDLE svc;
	char drv_path[MAX_PATH];

	if (verb)
		printf( "Installing ioperm.sys...\n" );

	start( verb, "OpenSCManager" );
	scm = OpenSCManager( NULL, NULL, SC_MANAGER_ALL_ACCESS );
	if (scm == NULL) {
		err( verb, "OpenSCManager" );
		return 0;
	}
	ok( verb );

#ifdef __CYGWIN__
	cygwin_conv_to_full_win32_path( PREFIX "/bin/ioperm.sys", drv_path );
	if(access(drv_path,F_OK)!=0)
#endif
	{ /* cygwin is not installed */
	  if(getcwd(drv_path,sizeof(drv_path))==NULL)
	  {
	    return 0;
	  }
	  strcat(drv_path,"/ioperm.sys");
	}

	start( verb, "CreateService" );
	svc = CreateService( scm, TEXT("ioperm"), TEXT("ioperm support for Cygwin driver"), SERVICE_ALL_ACCESS,
		SERVICE_KERNEL_DRIVER, SERVICE_AUTO_START, SERVICE_ERROR_NORMAL, drv_path, NULL, NULL,
		NULL, NULL, NULL );
	if (svc == NULL) {
		if (GetLastError() != ERROR_SERVICE_EXISTS)
			err( verb, "CreateService" );
		else {
			if (verb)
				printf( "failed\n" );
			printf( "ioperm.sys is already installed.\n" );
			start( verb, "OpenService" );
			svc = OpenService( scm, TEXT("ioperm"), SERVICE_ALL_ACCESS );
			if (!svc)
				err( verb, "OpenService" );
		}

		if (svc == NULL) {
			CloseServiceHandle( scm );
			return 0;
		}
	}
	ok( verb );

	start( verb, "StartService" );
	if (!StartService( svc, 0, NULL )) {
		if (GetLastError() != ERROR_SERVICE_ALREADY_RUNNING)
			err( verb, "StartService" );
		else {
			if (verb)
				printf( "failed\n" );
			printf( "ioperm.sys is already running.\n" );
		}
	} else
		ok( verb );
		
	CloseServiceHandle( svc );
	CloseServiceHandle( scm );

	return 1;
}
