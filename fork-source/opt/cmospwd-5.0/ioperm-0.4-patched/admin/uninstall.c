/*
 * $Id: uninstall.c,v 1.3 2003/01/23 15:16:35 telka Exp $
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

void start( int, const char * );
void err( int, const char * );
void ok( int );

int
uninstall( int verb )
{
	SC_HANDLE scm;
	SC_HANDLE svc;
	SERVICE_STATUS stat;

	if (verb)
		printf( "Uninstalling ioperm.sys...\n" );

	start( verb, "OpenSCManager" );
	scm = OpenSCManager( NULL, NULL, SC_MANAGER_ALL_ACCESS );
	if (scm == NULL) {
		err( verb, "OpenSCManager" );
		return 0;
	}
	ok( verb );

	start( verb, "OpenService" );
	svc = OpenService( scm, TEXT("ioperm"), SERVICE_ALL_ACCESS );
	if (svc == NULL) {
		if (GetLastError() != ERROR_SERVICE_DOES_NOT_EXIST)
			err( verb, "OpenService" );
		else {
			if (verb)
				printf( "failed\n" );
			printf( "ioperm.sys is not installed.\n" );
			CloseServiceHandle( scm );
			return 1;
		}
		CloseServiceHandle( scm );
		return 0;
	}
	ok( verb );

	start( verb, "DeleteService" );
	if (!DeleteService( svc )) {
		err( verb, "DeleteService" );

		CloseServiceHandle( svc );
		CloseServiceHandle( scm );
		return 0;
	}
	ok( verb );

	start( verb, "ControlService" );
	if (!ControlService( svc, SERVICE_CONTROL_STOP, &stat )) {
		if (GetLastError() != ERROR_SERVICE_NOT_ACTIVE)
			err( verb, "ControlService" );
		else {
			if (verb)
				printf( "failed\n" );
			printf( "ioperm.sys is not running.\n" );
		}
	} else
		ok( verb );

	CloseServiceHandle( svc );
	CloseServiceHandle( scm );

	return 1;
}
