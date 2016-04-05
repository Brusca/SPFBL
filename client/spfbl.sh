#!/bin/bash
#
# This file is part of SPFBL.
# and open the template in the editor.
#
# SPFBL is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# SPFBL is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with SPFBL.  If not, see <http://www.gnu.org/licenses/>.
#
# Projeto SPFBL - Copyright Leandro Carlos Rodrigues - leandro@spfbl.net
# https://github.com/leonamp/SPFBL
#
# Aten��o! Para utilizar este servi�o, solicite a libera��o das consultas
# no servidor matrix.spfbl.net atrav�s do endere�o leandro@spfbl.net
# ou altere o matrix.spfbl.net deste script para seu servidor SPFBL pr�prio.

### CONFIGURACOES ###
IP_SERVIDOR="matrix.spfbl.net"
PORTA_SERVIDOR="9877"
PORTA_ADMIN="9875"
DUMP_PATH="/tmp"

export PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin
version="1.04"

head()
{
	echo "SPFBL v$version - by Leandro Rodrigues - leandro@spfbl.net"
}

case $1 in
	'version')
		# Verifica a vers�o do servidor SPPFBL.
		#
		# C�digos de sa�da:
		#
		#    0: vers�o adquirida com sucesso.
		#    1: erro ao tentar adiquirir vers�o.
		#    2: timeout de conex�o.


		response=$(echo "VERSION" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

		if [[ $response == "" ]]; then
			response="TIMEOUT"
		fi

		echo "$response"

		if [[ $response == "TIMEOUT" ]]; then
			exit 2
		elif [[ $response == "SPFBL"* ]]; then
			exit 0
		else
			exit 1
		fi
	;;
	'firewall')
		# Constroi um firewall pelo SPPFBL.
		#
		# C�digos de sa�da:
		#
		#    0: firwall adquirido com sucesso.
		#    1: erro ao tentar adiquirir firewall.
		#    2: timeout de conex�o.


		response=$(echo "FIREWALL" | nc $IP_SERVIDOR $PORTA_ADMIN)

		if [[ $response == "" ]]; then
			response="TIMEOUT"
		fi

		echo "$response"

		if [[ $response == "TIMEOUT" ]]; then
			exit 2
		elif [[ $response == "#!/bin/bash"* ]]; then
			exit 0
		else
			exit 1
		fi
	;;
	'shutdown')
		# Finaliza Servi�o.
		#
		# C�digos de sa�da:
		#
		#    0: fechamento de processos realizado com sucesso.
		#    1: houve falha no fechamento dos processos.
		#    2: timeout de conex�o.


		response=$(echo "SHUTDOWN" | nc $IP_SERVIDOR $PORTA_ADMIN)

		if [[ $response == "" ]]; then
			response="TIMEOUT"
		fi

		echo "$response"

		if [[ $response == "TIMEOUT" ]]; then
			exit 2
		elif [[ $response == "OK" ]]; then
			exit 0
		elif [[ $response == "ERROR: SHUTDOWN" ]]; then
			exit 1
		else
			exit 1
		fi
	;;
	'store')
		# Comando para gravar o cache em disco.
		#
		# C�digos de sa�da:
		#
		#    0: gravar o cache em disco realizado com sucesso.
		#    1: houve falha ao gravar o cache em disco.
		#    2: timeout de conex�o.


		response=$(echo "STORE" | nc $IP_SERVIDOR $PORTA_ADMIN)

		if [[ $response == "" ]]; then
			response="TIMEOUT"
		fi

		echo "$response"

		if [[ $response == "TIMEOUT" ]]; then
			exit 2
		elif [[ $response == "OK" ]]; then
			exit 0
		else
			exit 1
		fi
	;;
	'tld')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. tld: endere�o do tld.
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adiciona.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 tld add tld\n"
				else
					tld=$3

					response=$(echo "TLD ADD $tld" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ADDED" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. tld: endere�o do tld.
				#
				# C�digos de sa�da:
				#
				#    0: removido com sucesso.
				#    1: erro ao tentar remover.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 tld drop tld\n"
				else
					tld=$3

					response=$(echo "TLD DROP $tld" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "DROPED" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')

				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 tld show\n"
				else

					response=$(echo "TLD SHOW" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ERROR"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 tld add tld\n    $0 tld drop tld\n    $0 tld show\n"
			;;
		esac
	;;
##########
### DNSBL?
##########
	'provider')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. provedor: endere�o do provedor de e-mail.
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adiciona.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 provider add sender\n"
				else
					provider=$3

					response=$(echo "PROVIDER ADD $provider" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ADDED" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. provedor: endere�o do provedor de e-mail.
				#
				# C�digos de sa�da:
				#
				#    0: removido com sucesso.
				#    1: erro ao tentar remover.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 provider drop sender\n"
				else
					provider=$3

					response=$(echo "PROVIDER DROP $provider" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "DROPED" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')

				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 provider show\n"
				else

					response=$(echo "PROVIDER SHOW" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ERROR"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 provider add sender\n    $0 provider drop sender\n    $0 provider show\n"
			;;
		esac
	;;
	'ignore')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. sender: o remetente que deve ser ignorado, com endere�o completo.
				#    1. dom�nio: o dom�nio que deve ser ignorado, com arroba (ex: @dominio.com.br)
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adiciona.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 ignore add sender\n"
				else
					ignore=$3

					response=$(echo "IGNORE ADD $ignore" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ADDED" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. sender: o remetente ignorado, com endere�o completo.
				#    1. dom�nio: o dom�nio ignorado, com arroba (ex: @dominio.com.br)
				#
				# C�digos de sa�da:
				#
				#    0: removido com sucesso.
				#    1: erro ao tentar remover.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 ignore drop sender\n"
				else
					ignore=$3

					response=$(echo "IGNORE DROP $ignore" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "DROPED" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')

				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 ignore show\n"
				else

					response=$(echo "IGNORE SHOW" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ERROR"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 ignore add sender\n    $0 ignore drop sender\n    $0 ignore show\n"
			;;
		esac
	;;
	'block')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. sender: o remetente que deve ser bloqueado, com endere�o completo.
				#    1. dom�nio: o dom�nio que deve ser bloqueado, com arroba (ex: @dominio.com.br)
				#    1. caixa postal: a caixa postal que deve ser bloqueada, com arroba (ex: www-data@)
				#
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adicionar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 block add sender\n"
				else
					sender=$3

					response=$(echo "BLOCK ADD $sender" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. sender: o remetente que deve ser desbloqueado, com endere�o completo.
				#    1. dom�nio: o dom�nio que deve ser desbloqueado, com arroba (ex: @dominio.com.br)
				#    1. caixa postal: a caixa postal que deve ser desbloqueada, com arroba (ex: www-data@)
				#
				#
				# C�digos de sa�da:
				#
				#    0: desbloqueado com sucesso.
				#    1: erro ao tentar adicionar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 block drop sender\n"
				else
					sender=$3

					response=$(echo "BLOCK DROP $sender" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')
				# Par�metros de entrada:
				#    1: ALL: lista os bloqueios gerais (opcional)
				#
				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 block show [all]\n"
				else
					if [ "$3" == "all" ]; then
						response=$(echo "BLOCK SHOW ALL" | nc $IP_SERVIDOR $PORTA_SERVIDOR)
					else
						response=$(echo "BLOCK SHOW" | nc $IP_SERVIDOR $PORTA_SERVIDOR)
					fi

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'find')
				# Par�metros de entrada:
				#    1: <token>: um e-mail, host ou IP.
				#
				# C�digos de sa�da:
				#
				#    0: sem registro.
				#    1: registro encontrado.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 block find token\n"
				else
 					token=$3
					response=$(echo "BLOCK FIND $token" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "NONE" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 block add recipient\n    $0 block drop recipient\n    $0 block show\n"
			;;
		esac
	;;
	'superblock')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. sender: o remetente que deve ser bloqueado, com endere�o completo.
				#    1. dom�nio: o dom�nio que deve ser bloqueado, com arroba (ex: @dominio.com.br)
				#    1. caixa postal: a caixa postal que deve ser bloqueada, com arroba (ex: www-data@)
				#
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adicionar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 superblock add sender\n"
				else
					sender=$3

					response=$(echo "BLOCK ADD $sender" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ADDED" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'split')
				# Par�metros de entrada:
				#
				#    1. sender: o remetente que deve ser bloqueado, com endere�o completo.
				#    1. dom�nio: o dom�nio que deve ser bloqueado, com arroba (ex: @dominio.com.br)
				#    1. caixa postal: a caixa postal que deve ser bloqueada, com arroba (ex: www-data@)
				#
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adicionar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 superblock split CIDR\n"
				else
					sender=$3

					response=$(echo "BLOCK SPLIT $sender" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "DROPED" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'overlap')
				# Par�metros de entrada:
				#
				#    1. sender: o remetente que deve ser bloqueado, com endere�o completo.
				#    1. dom�nio: o dom�nio que deve ser bloqueado, com arroba (ex: @dominio.com.br)
				#    1. caixa postal: a caixa postal que deve ser bloqueada, com arroba (ex: www-data@)
				#
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adicionar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 superblock overlap CIDR\n"
				else
					sender=$3

					response=$(echo "BLOCK OVERLAP $sender" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ADDED" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. sender: o remetente que deve ser desbloqueado, com endere�o completo.
				#    1. dom�nio: o dom�nio que deve ser desbloqueado, com arroba (ex: @dominio.com.br)
				#    1. caixa postal: a caixa postal que deve ser desbloqueada, com arroba (ex: www-data@)
				#
				#
				# C�digos de sa�da:
				#
				#    0: desbloqueado com sucesso.
				#    1: erro ao tentar adicionar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 superblock drop sender\n"
				else
					sender=$3

					response=$(echo "BLOCK DROP $sender" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')
				# Par�metros de entrada:
				#    1: ALL: lista os bloqueios gerais (opcional)
				#
				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 superblock show [all]\n"
				else
					if [ "$3" == "all" ]; then
						response=$(echo "BLOCK SHOW ALL" | nc $IP_SERVIDOR $PORTA_ADMIN)
					else
						response=$(echo "BLOCK SHOW" | nc $IP_SERVIDOR $PORTA_ADMIN)
					fi

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 superblock add recipient\n    $0 superblock drop recipient\n    $0 superblock show\n"
			;;
		esac
	;;
	'white')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. recipient: o destinat�rio que deve ser bloqueado, com endere�o completo.
				#
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adicionar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 white add recipient\n"
				else
					recipient=$3

					response=$(echo "WHITE ADD $recipient" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. recipient: o destinat�rio que deve ser desbloqueado, com endere�o completo.
				#
				#
				# C�digos de sa�da:
				#
				#    0: desbloqueado com sucesso.
				#    1: erro ao tentar adicionar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 white drop recipient\n"
				else
					recipient=$3

					response=$(echo "WHITE DROP $recipient" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')
				# Par�metros de entrada: nenhum.
				#
				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 white show\n"
				else
					response=$(echo "WHITE SHOW" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 white add recipient\n    $0 white drop recipient\n    $0 white show\n"
			;;
		esac
	;;
	'superwhite')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. recipient: o destinat�rio que deve ser bloqueado, com endere�o completo.
				#
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adicionar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 superwhite add recipient\n"
				else
					recipient=$3

					response=$(echo "WHITE ADD $recipient" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. recipient: o destinat�rio que deve ser desbloqueado, com endere�o completo.
				#
				#
				# C�digos de sa�da:
				#
				#    0: desbloqueado com sucesso.
				#    1: erro ao tentar adicionar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 superwhite drop recipient\n"
				else
					recipient=$3

					response=$(echo "WHITE DROP $recipient" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')
				# Par�metros de entrada: nenhum.
				#
				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar bloqueio.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 superwhite show [all]\n"
				else
					if [ "$3" == "all" ]; then
						response=$(echo "WHITE SHOW ALL" | nc $IP_SERVIDOR $PORTA_ADMIN)
					else
						response=$(echo "WHITE SHOW" | nc $IP_SERVIDOR $PORTA_ADMIN)
					fi

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 superwhite add recipient\n    $0 superwhite drop recipient\n    $0 superwhite show [all]\n"
			;;
		esac
	;;
	'client')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. cidr: chave prim�ria - endere�o do host de acesso.
				#    2. domain: organizador do cadastro
				#	 3. option: op��es de acesso -> NONE, SPFBL ou DNSBL
				#    4. email: [opcional] e-mail do cliente
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adiciona.
				#    2: timeout de conex�o.

				if [ $# -lt "5" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 client add cidr domain option [email]\n"
				else
					cidr=$3
					domain=$4
					option=$5
					email=""

					if [ -n "$6" ]; then
						email=$6
					fi
					
					response=$(echo "CLIENT ADD $cidr $domain $option $email" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ADDED"* ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'set')
				# Par�metros de entrada:
				#
				#    1. cidr: chave prim�ria - endere�o do host de acesso.
				#    2. domain: organizador do cadastro
				#	 3. option: op��es de acesso -> NONE, SPFBL ou DNSBL
				#    4. email: [opcional] e-mail do cliente
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adiciona.
				#    2: timeout de conex�o.

				if [ $# -lt "4" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 client set cidr domain option [email]\n"
				else
					cidr=$3
					domain=$4
					option=$5
					email=""

					if [ -n "$6" ]; then
						email=$6
					fi
					
					response=$(echo "CLIENT SET $cidr $domain $option $email" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "UPDATED"* ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. cidr: chave prim�ria - endere�o do host de acesso.
				#
				# C�digos de sa�da:
				#
				#    0: removido com sucesso.
				#    1: erro ao tentar remover.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 client drop cidr\n"
				else
					cidr=$3

					response=$(echo "CLIENT DROP $cidr" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "DROPED"* ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')

				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 client show\n"
				else

					response=$(echo "CLIENT SHOW" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ERROR"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 client add cidr domain option [email] \n    $0 client set cidr domain option [email] \n    $0 client drop cidr\n    $0 client show\n"
			;;
		esac
	;;
	'user')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. email: E-mail do usu�rio.
				#    2. nome: Nome do usu�rio.
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adiciona.
				#    2: timeout de conex�o.

				if [ $# -lt "4" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 user add email nome\n"
				else
					email=$3
					nome="${@:4}"

					response=$(echo "USER ADD $email $nome" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ADDED"* ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. email: E-mail do usu�rio.
				#
				# C�digos de sa�da:
				#
				#    0: removido com sucesso.
				#    1: erro ao tentar remover.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 user drop email\n"
				else
					email=$3

					response=$(echo "USER DROP $email" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "DROPED"* ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')

				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 user show\n"
				else

					response=$(echo "USER SHOW" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ERROR"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 user add email nome\n    $0 user drop email\n    $0 user show\n"
			;;
		esac
	;;
	'peer')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. host: Endere�o do peer.
				#    2. email: E-mail do administrador.
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adicionar.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 peer add host email\n"
				else
					host=$3

					if [ -f "$4" ]; then
						email=$4
						response=$(echo "PEER ADD $host $email" | nc $IP_SERVIDOR $PORTA_ADMIN)
					else
						response=$(echo "PEER ADD $host" | nc $IP_SERVIDOR $PORTA_ADMIN)
					fi

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ERROR"* ]]; then
						exit 1
					elif [[ $response == "ALREADY"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. host: Endere�o do peer.
				#
				# C�digos de sa�da:
				#
				#    0: removido com sucesso.
				#    1: erro ao tentar remover.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 peer drop { host | all }\n"
				else
					host=$3

					if [ "$host" == "all" ]; then
						response=$(echo "PEER DROP ALL" | nc $IP_SERVIDOR $PORTA_ADMIN)
					else
						response=$(echo "PEER DROP $host" | nc $IP_SERVIDOR $PORTA_ADMIN)
					fi

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ERROR"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			'show')

				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 peer show [host]\n"
				else

					if [ -f "$3" ]; then
						host=$3
						response=$(echo "PEER SHOW $host" | nc $IP_SERVIDOR $PORTA_ADMIN)
					else
						response=$(echo "PEER SHOW" | nc $IP_SERVIDOR $PORTA_ADMIN)
					fi

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "NOT FOUND"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			'set')
				# Par�metros de entrada:
				#
				#    1. host: Endere�o do peer.
				#    2. send: Op��es para envio (##??##).
				#    3. receive: Op��es para recebimento (##??##).
				#
				# C�digos de sa�da:
				#
				#    0: setado com sucesso.
				#    1: erro ao tentar setar op��es.
				#    2: timeout de conex�o.

				if [ $# -lt "5" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 peer set host send receive\n"
				else
					host=$3
					send=$4
					receive=$5

					response=$(echo "PEER SET $host $send $receive" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "NOT"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			'ping')
				# Par�metros de entrada:
				#
				#    1. host: Endere�o do peer.
				#
				# C�digos de sa�da:
				#
				#    0: executado com sucesso.
				#    1: erro ao tentar executar.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 peer ping host\n"
				else
					host=$3

					response=$(echo "PEER PING $host" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "NOT"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			'send')
				# Par�metros de entrada:
				#
				#    1. host: Endere�o do peer.
				#
				# C�digos de sa�da:
				#
				#    0: executado com sucesso.
				#    1: erro ao tentar executar.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 peer send host\n"
				else
					host=$3

					response=$(echo "PEER SEND $host" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "NOT"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;

			*)
				head
				printf "Syntax:\n    $0 peer add host [email]\n    $0 peer drop { host | all }\n    $0 peer show [host]\n    $0 peer set host send receive\n    $0 peer ping host\n    $0 peer send host\n"
			;;
		esac
	;;
	'retention')
		case $2 in
			'show')
				# Par�metros de entrada:
				#
				#    1. host: Endere�o do peer.
				#
				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 retention show { host | all }\n"
				else

					host=$3

					if [ "$host" == "all" ]; then
                                                response=$(echo "PEER RETENTION SHOW ALL" | nc $IP_SERVIDOR $PORTA_ADMIN)
                                        else
                                                response=$(echo "PEER RETENTION SHOW $host" | nc $IP_SERVIDOR $PORTA_ADMIN)
                                        fi

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ERROR"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			'release')
				# Par�metros de entrada:
				#
				#    1. sender: Bloqueio recebido do peer.
				#
				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 retention release { sender | all }\n"
				else

					sender=$3

					if [ "$sender" == "all" ]; then
                                                response=$(echo "PEER RETENTION RELEASE ALL" | nc $IP_SERVIDOR $PORTA_ADMIN)
                                        else
                                                response=$(echo "PEER RETENTION RELEASE $sender" | nc $IP_SERVIDOR $PORTA_ADMIN)
                                        fi

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ERROR"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			'reject')
				# Par�metros de entrada:
				#
				#    1. sender: Bloqueio recebido do peer.
				#
				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 retention reject { sender | all }\n"
				else

					sender=$3

					if [ "$sender" == "all" ]; then
                                                response=$(echo "PEER RETENTION REJECT ALL" | nc $IP_SERVIDOR $PORTA_ADMIN)
                                        else
                                                response=$(echo "PEER RETENTION REJECT $sender" | nc $IP_SERVIDOR $PORTA_ADMIN)
                                        fi

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "ERROR"* ]]; then
						exit 1
					else
						exit 0
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 retention show { host | all }\n    $0 retention release { sender | all }\n    $0 retention reject { sender | all }\n"
			;;
		esac
	;;


########
## GUESS
########
	'reputation')
		# Par�metros de entrada: nenhum
		#
		# C�digos de sa�da:
		#
		#    0: listado com sucesso.
		#    1: lista vazia.
		#    2: timeout de conex�o.

                if [[ $2 == "cidr" ]]; then
                	response=$(echo "REPUTATION CIDR" | nc $IP_SERVIDOR $PORTA_ADMIN)
                else
                	response=$(echo "REPUTATION" | nc $IP_SERVIDOR $PORTA_ADMIN)
                fi
		
		if [[ $response == "" ]]; then
			response="TIMEOUT"
		fi

		echo "$response"

		if [[ $response == "TIMEOUT" ]]; then
			exit 2
		elif [[ $response == "EMPTY" ]]; then
			exit 1
		else
			exit 0
		fi
	;;
	'clear')
		# Par�metros de entrada:
		#
		#    1. hostname: o nome do host cujas den�ncias devem ser limpadas.
		#
		#
		# C�digos de sa�da:
		#
		#    0: limpado com sucesso.
		#    1: registro n�o encontrado em cache.
		#    2: erro ao processar atualiza��o.
		#    3: timeout de conex�o.

		if [ $# -lt "2" ]; then
			head
			printf "Faltando parametro(s).\nSintaxe: $0 superclear hostname\n"
		else
			hostname=$2

			response=$(echo "CLEAR $hostname" | nc $IP_SERVIDOR $PORTA_ADMIN)

			if [[ $response == "" ]]; then
				response="TIMEOUT"
			fi

			echo "$response"

			if [[ $response == "TIMEOUT" ]]; then
				exit 3
			elif [[ $response == "UPDATED" ]]; then
				exit 0
			elif [[ $response == "NOT LOADED" ]]; then
				exit 1
			else
				exit 2
			fi
		fi
	;;
########
## DROP
########
	'refresh')
		# Par�metros de entrada:
		#
		#    1. hostname: o nome do host cujo registro SPF que deve ser atualizado.
		#
		#
		# C�digos de sa�da:
		#
		#    0: atualizado com sucesso.
		#    1: registro n�o encontrado em cache.
		#    2: erro ao processar atualiza��o.
		#    3: timeout de conex�o.

		if [ $# -lt "2" ]; then
			head
			printf "Faltando parametro(s).\nSintaxe: $0 refresh hostname\n"
		else
			hostname=$2

			response=$(echo "REFRESH $hostname" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

			if [[ $response == "" ]]; then
				response="TIMEOUT"
			fi

			echo "$response"

			if [[ $response == "TIMEOUT" ]]; then
				exit 3
			elif [[ $response == "UPDATED" ]]; then
				exit 0
			elif [[ $response == "NOT LOADED" ]]; then
				exit 1
			else
				exit 2
			fi
		fi
	;;
	'check')
		# Par�metros de entrada:
		#
		#    1. IP: o IPv4 ou IPv6 do host de origem.
		#    2. email: o email do remetente.
		#    3. HELO: o HELO passado pelo host de origem.
		#
		# Sa�das com qualificadores e os tokens com suas probabilidades:
		#
		#    <quaificador>\n
		#    <token> <probabilidade>\n
		#    <token> <probabilidade>\n
		#    <token> <probabilidade>\n
		#    ...
		#
		# C�digos de sa�da:
		#
		#    0: n�o especificado.
		#    1: qualificador NEUTRAL.
		#    2: qualificador PASS.
		#    3: qualificador FAIL.
		#    4: qualificador SOFTFAIL.
		#    5: qualificador NONE.
		#    6: erro tempor�rio.
		#    7: erro permanente.
		#    8: listado em lista negra.
		#    9: timeout de conex�o.
		#    10: dom�nio inexistente.
		#    11: par�metros inv�lidos.

		if [ $# -lt "4" ]; then
			head
			printf "Faltando parametro(s).\nSintaxe: $0 check ip email helo\n"
		else
			ip=$2
			email=$3
			helo=$4

			qualifier=$(echo "CHECK '$ip' '$email' '$helo'" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

			if [[ $qualifier == "" ]]; then
				qualifier="TIMEOUT"
			fi

			echo "$qualifier"

			if [[ $qualifier == "TIMEOUT" ]]; then
				exit 9
			elif [[ $qualifier == "NXDOMAIN" ]]; then
				exit 10
			elif [[ $qualifier == "LISTED"* ]]; then
				exit 8
			elif [[ $qualifier == "INVALID" ]]; then
				exit 11
			elif [[ $qualifier == "ERROR: HOST NOT FOUND" ]]; then
				exit 6
			elif [[ $qualifier == "ERROR: QUERY" ]]; then
				exit 11
			elif [[ $qualifier == "ERROR: "* ]]; then
				exit 7
			elif [[ $qualifier == "NONE"* ]]; then
				exit 5
			elif [[ $qualifier == "PASS"* ]]; then
				exit 2
			elif [[ $qualifier == "FAIL" ]]; then
				exit 3
			elif [[ $qualifier == "SOFTFAIL"* ]]; then
				exit 4
			elif [[ $qualifier == "NEUTRAL"* ]]; then
				exit 1
			else
				exit 0
			fi
		fi
	;;
	'spam')
		# Este comando procura e extrai o ticket de consulta SPFBL de uma mensagem de e-mail se o par�metro for um arquivo.
		#
		# Com posse do ticket, ele envia a reclama��o ao servi�o SPFBL para contabiliza��o de reclama��o.
		#
		# Par�metros de entrada:
		#  1. o arquivo de e-mail com o ticket ou o ticket sozinho.
		#
		# C�digos de sa�da:
		#  0. Ticket enviado com sucesso.
		#  1. Arquivo inexistente.
		#  2. Arquivo n�o cont�m ticket.
		#  3. Erro no envio do ticket.
		#  4. Timeout no envio do ticket.
		#  5. Par�metro inv�lido.
		#  6. Ticket inv�lido.

		if [ $# -lt "2" ]; then
			head
			printf "Faltando parametro(s).\nSintaxe: $0 spam ticketid/file\n"
		else
                        if [[ $2 =~ ^http://.+/spam/[a-zA-Z0-9/+=]{44,512}$ ]]; then
                                # O par�mentro � uma URL de den�ncia SPFBL.
                                url=$2
			elif [[ $2 =~ ^[a-zA-Z0-9/+=]{44,512}$ ]]; then
				# O par�mentro � um ticket SPFBL.
				ticket=$2
			elif [ -f "$2" ]; then
				# O par�metro � um arquivo.
				file=$2

				if [ -e "$file" ]; then
					# Extrai o ticket incorporado no arquivo.
					ticket=$(grep -Pom 1 "^Received-SPFBL: (PASS|SOFTFAIL|NEUTRAL|NONE) \K([0-9a-zA-Z\+/=]+)$" $file)

					if [ $? -gt 0 ]; then

						# Extrai o ticket incorporado no arquivo.
						url=$(grep -Pom 1 "^Received-SPFBL: (PASS|SOFTFAIL|NEUTRAL|NONE) \K(http://.+/spam/[0-9a-zA-Z\+/=]+)$" $file)

						if [ $? -gt 0 ]; then
							echo "Nenhum ticket SPFBL foi encontrado na mensagem."
							exit 2
						fi
					fi
				else
					echo "O arquivo n�o existe."
					exit 1
				fi
			else
				echo "O par�metro passado n�o corresponde a um arquivo nem a um ticket."
				exit 5
			fi

			if [[ -z $url ]]; then
				if [[ -z $ticket ]]; then
					echo "Ticket SPFBL inv�lido."
					exit 6
				else
					# Registra reclama��o SPFBL.
					resposta=$(echo "SPAM $ticket" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $resposta == "" ]]; then
						echo "A reclama��o SPFBL n�o foi enviada por timeout."
						exit 4
					elif [[ $resposta == "OK"* ]]; then
						echo "Reclama��o SPFBL enviada com sucesso."
						exit 0
					elif [[ $resposta == "ERROR: DECRYPTION" ]]; then
						echo "Ticket SPFBL inv�lido."
						exit 6
					else
						echo "A reclama��o SPFBL n�o foi enviada: $resposta"
						exit 3
					fi
				fi
			else
				# Registra reclama��o SPFBL via HTTP.
                                resposta=$(curl -X PUT -s -m 3 $url)
				if [[ $? == "28" ]]; then
					echo "A reclama��o SPFBL n�o foi enviada por timeout."
					exit 4
				elif [[ $resposta == "OK"* ]]; then
					echo "Reclama��o SPFBL enviada com sucesso."
					exit 0
				elif [[ $resposta == "ERROR: DECRYPTION" ]]; then
					echo "Ticket SPFBL inv�lido."
					exit 6
				else
					echo "A reclama��o SPFBL n�o foi enviada: $resposta"
					exit 3
				fi
			fi
		fi
	;;
	'ham')
		# Este comando procura e extrai o ticket de consulta SPFBL de uma mensagem de e-mail se o par�metro for um arquivo.
		#
		# Com posse do ticket, ele solicita a revoga��o da reclama��o ao servi�o SPFBL.
		#
		# Par�metros de entrada:
		#  1. o arquivo de e-mail com o ticket ou o ticket sozinho.
		#
		# C�digos de sa�da:
		#  0. Reclama��o revogada com sucesso.
		#  1. Arquivo inexistente.
		#  2. Arquivo n�o cont�m ticket.
		#  3. Erro no envio do ticket.
		#  4. Timeout no envio do ticket.
		#  5. Par�metro inv�lido.
		#  6. Ticket inv�lido.

		if [ $# -lt "2" ]; then
			head
			printf "Faltando parametro(s).\nSintaxe: $0 ham ticketid/file\n"
		else
			if [[ $2 =~ ^http://.+/spam/[a-zA-Z0-9/+=]{44,512}$ ]]; then
	            # O par�mentro � uma URL de den�ncia SPFBL.
	            url=$2
			elif [[ $2 =~ ^[a-zA-Z0-9/+]{44,512}$ ]]; then
				# O par�mentro � um ticket SPFBL.
				ticket=$2
			elif [ -f "$2" ]; then
				# O par�metro � um arquivo.
				file=$2

				if [ -e "$file" ]; then
					# Extrai o ticket incorporado no arquivo.
					ticket=$(grep -Pom 1 "^Received-SPFBL: (PASS|SOFTFAIL|NEUTRAL|NONE) \K([0-9a-zA-Z\+/=]+)$" $file)

					if [ $? -gt 0 ]; then

						# Extrai o ticket incorporado no arquivo.
						url=$(grep -Pom 1 "^Received-SPFBL: (PASS|SOFTFAIL|NEUTRAL|NONE) \K(http://.+/spam/[0-9a-zA-Z\+/=]+)$" $file)

						if [ $? -gt 0 ]; then
							echo "Nenhum ticket SPFBL foi encontrado na mensagem."
							exit 2
						fi
					fi
				else
					echo "O arquivo n�o existe."
					exit 1
				fi
			else
				echo "O par�metro passado n�o corresponde a um arquivo nem a um ticket."
				exit 5
			fi

			if [[ -z $url ]]; then
				if [[ -z $ticket ]]; then
					echo "Ticket SPFBL inv�lido."
					exit 6
				else
					# Registra reclama��o SPFBL.
					resposta=$(echo "HAM $ticket" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $resposta == "" ]]; then
						echo "A revoga��o SPFBL n�o foi enviada por timeout."
						exit 4
					elif [[ $resposta == "OK"* ]]; then
						echo "Revoga��o SPFBL enviada com sucesso."
						exit 0
					elif [[ $resposta == "ERROR: DECRYPTION" ]]; then
						echo "Ticket SPFBL inv�lido."
						exit 6
					else
						echo "A revoga��o SPFBL n�o foi enviada: $resposta"
						exit 3
					fi
				fi
			else
				# Registra reclama��o SPFBL via HTTP.
				spamURL=/spam/
                                hamURL=/ham/
				url=${url/$spamURL/$hamURL}
                                resposta=$(curl -X PUT -s -m 3 $url)
				if [[ $? == "28" ]]; then
					echo "A revoga��o SPFBL n�o foi enviada por timeout."
					exit 4
				elif [[ $resposta == "OK"* ]]; then
					echo "Revoga��o SPFBL enviada com sucesso."
					exit 0
				elif [[ $resposta == "ERROR: DECRYPTION" ]]; then
					echo "Ticket SPFBL inv�lido."
					exit 6
				else
					echo "A revoga��o SPFBL n�o foi enviada: $resposta"
					exit 3
				fi

			fi
		fi
	;;
	'query')
		# A sa�da deste programa deve ser incorporada ao cabe�alho
		# Received-SPFBL da mensagem de e-mail que gerou a consulta.
		#
		# Exemplo:
		#
		#    Received-SPFBL: PASS urNq9eFn65wKwDFGNsqCNYmywnlWmmilhZw5jdtvOr5jYk6mgkiWgQC1w696wT3ylP3r8qZnhOjwntTt5mCAuw==
		#
		# A informa��o que precede o qualificador � o ticket da consulta SPFBL.
		# Com o ticket da consulta, � poss�vel realizar uma reclama��o ao servi�o SPFBL,
		# onde esta reclama��o vai contabilizar a reclama��o nos contadores do respons�vel pelo envio da mensagem.
		# O ticket da consulta s� � gerado nas sa�das cujos qualificadores sejam: PASS, SOFTFAIL, NEUTRAL e NONE.
		#
		# Par�metros de entrada:
		#
		#    1. IP: o IPv4 ou IPv6 do host de origem.
		#    2. email: o email do remetente (opcional).
		#    3. HELO: o HELO passado pelo host de origem.
		#    4. recipient: o destin�tario da mensagem (opcional se n�o utilizar spamtrap).
		#
		# Sa�das com qualificadores e as a��es:
		#
		#    PASS <ticket>: permitir o recebimento da mensagem.
		#    FAIL: rejeitar o recebimento da mensagem e informar � origem o descumprimento do SPF.
		#    SOFTFAIL <ticket>: permitir o recebimento da mensagem mas marcar como suspeita.
		#    NEUTRAL <ticket>: permitir o recebimento da mensagem.
		#    NONE <ticket>: permitir o recebimento da mensagem.
		#    LISTED: atrasar o recebimento da mensagem e informar � origem a listagem em blacklist por sete dias.
		#    BLOCKED: rejeitar o recebimento da mensagem e informar � origem o bloqueio permanente.
		#    SPAMTRAP: discaratar silenciosamente a mensagem e informar � origem que a mensagem foi recebida com sucesso.
		#    GREYLIST: atrasar a mensagem informando � origem ele est� em greylisting.
		#    NXDOMAIN: o dom�nio do remetente � inexistente.
		#    INVALID: o endere�o do remetente � inv�lido.
		#
		# C�digos de sa�da:
		#
		#    0: n�o especificado.
		#    1: qualificador NEUTRAL.
		#    2: qualificador PASS.
		#    3: qualificador FAIL.
		#    4: qualificador SOFTFAIL.
		#    5: qualificador NONE.
		#    6: erro tempor�rio.
		#    7: erro permanente.
		#    8: listado em lista negra.
		#    9: timeout de conex�o.
		#    10: bloqueado permanentemente.
		#    11: spamtrap.
		#    12: greylisting.
		#    13: dom�nio inexistente.
		#    14: IP ou remetente inv�lido.
		#    15: mensagem originada de uma rede local.

		if [ $# -lt "5" ]; then
			head
			printf "Faltando parametro(s).\nSintaxe: $0 query ip email helo recipient\n"
		else
			ip=$2
			email=$3
			helo=$4
			recipient=$5

			qualifier=$(echo "SPF '$ip' '$email' '$helo' '$recipient'" | nc -w 10 $IP_SERVIDOR $PORTA_SERVIDOR)

			if [[ $qualifier == "" ]]; then
				qualifier="TIMEOUT"
			fi

			echo "$qualifier"

			if [[ $qualifier == "TIMEOUT" ]]; then
				exit 9
			elif [[ $qualifier == "NXDOMAIN" ]]; then
				exit 13
			elif [[ $qualifier == "GREYLIST" ]]; then
				exit 12
			elif [[ $qualifier == "INVALID" ]]; then
				exit 14
			elif [[ $qualifier == "LAN" ]]; then
				exit 15
			elif [[ $qualifier == "SPAMTRAP" ]]; then
				exit 11
			elif [[ $qualifier == "BLOCKED"* ]]; then
				exit 10
			elif [[ $qualifier == "LISTED"* ]]; then
				exit 8
			elif [[ $qualifier == "ERROR: HOST NOT FOUND" ]]; then
				exit 6
			elif [[ $qualifier == "ERROR: "* ]]; then
				exit 7
			elif [[ $qualifier == "NONE "* ]]; then
				exit 5
			elif [[ $qualifier == "PASS "* ]]; then
				exit 2
			elif [[ $qualifier == "FAIL "* ]]; then
			        # Retornou FAIL com ticket ent�o
			        # significa que est� em whitelist.
			        # Retornar como se fosse SOFTFAIL.
				exit 4
			elif [[ $qualifier == "FAIL" ]]; then
				exit 3
			elif [[ $qualifier == "SOFTFAIL "* ]]; then
				exit 4
			elif [[ $qualifier == "NEUTRAL "* ]]; then
				exit 1
			else
				exit 0
			fi
		fi
	;;
	'trap')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. recipient: o destinat�rio que deve ser considerado armadilha.
				#
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adicionar armadilha.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 trap add recipient\n"
				else
					recipient=$3

					response=$(echo "TRAP ADD $recipient" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. recipient: o destinat�rio que deve ser considerado armadilha.
				#
				#
				# C�digos de sa�da:
				#
				#    0: desbloqueado com sucesso.
				#    1: erro ao tentar adicionar armadilha.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 trap drop recipient\n"
				else
					recipient=$3

					response=$(echo "TRAP DROP $recipient" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')
				# Par�metros de entrada: nenhum.
				#
				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar armadilhas.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 trap show\n"
				else
					response=$(echo "TRAP SHOW" | nc $IP_SERVIDOR $PORTA_SERVIDOR)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 trap add recipduient\n    $0 trap drop recipient\n    $0 trap show\n"
			;;
		esac
	;;
	'noreply')
		case $2 in
			'add')
				# Par�metros de entrada:
				#
				#    1. recipient: o destinat�rio que o SPFBL n�o deve enviar mensagem de e-mail.
				#
				#
				# C�digos de sa�da:
				#
				#    0: adicionado com sucesso.
				#    1: erro ao tentar adicionar endere�o.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 trap add recipient\n"
				else
					recipient=$3

					response=$(echo "NOREPLY ADD $recipient" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'drop')
				# Par�metros de entrada:
				#
				#    1. recipient: o destinat�rio que o SPFBL n�o deve enviar mensagem de e-mail.
				#
				#
				# C�digos de sa�da:
				#
				#    0: desbloqueado com sucesso.
				#    1: erro ao tentar adicionar endere�o.
				#    2: timeout de conex�o.

				if [ $# -lt "3" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 trap drop recipient\n"
				else
					recipient=$3

					response=$(echo "NOREPLY DROP $recipient" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			'show')
				# Par�metros de entrada: nenhum.
				#
				# C�digos de sa�da:
				#
				#    0: visualizado com sucesso.
				#    1: erro ao tentar visualizar endere�os.
				#    2: timeout de conex�o.

				if [ $# -lt "2" ]; then
					head
					printf "Faltando parametro(s).\nSintaxe: $0 trap show\n"
				else
					response=$(echo "NOREPLY SHOW" | nc $IP_SERVIDOR $PORTA_ADMIN)

					if [[ $response == "" ]]; then
						response="TIMEOUT"
					fi

					echo "$response"

					if [[ $response == "TIMEOUT" ]]; then
						exit 2
					elif [[ $response == "OK" ]]; then
						exit 0
					else
						exit 1
					fi
				fi
			;;
			*)
				head
				printf "Syntax:\n    $0 noreply add recipduient\n    $0 noreply drop recipient\n    $0 noreply show\n"
			;;
		esac
	;;
	'dump')
		# Par�metros de entrada: nenhum.
		#
		# C�digos de sa�da: nenhum.

		echo "DUMP" | nc $IP_SERVIDOR $PORTA_ADMIN > $DUMP_PATH/spfbl.dump.$(date "+%Y-%m-%d_%H-%M")
		if [ -f $DUMP_PATH/spfbl.dump.$(date "+%Y-%m-%d_%H-%M") ]; then
			echo "Dump saved as $DUMP_PATH/spfbl.dump.$(date "+%Y-%m-%d_%H-%M")"
		else
			echo "File $DUMP_PATH/spfbl.dump.$(date "+%Y-%m-%d_%H-%M") not found."
		fi
	;;
	'load')
		# Par�metros de entrada: nenhum.
		#
		# C�digos de sa�da: nenhum.

		if [ $# -lt "2" ]; then
			head
			printf "Faltando parametro(s).\nSintaxe: $0 load path\n"
		else
			file=$1
			if [ -f $file ]; then
				for line in `cat $file`; do
					echo -n "Adding $line ... "
					echo "$line" | nc $IP_SERVIDOR $PORTA_ADMIN
				done
			else
				echo "File not found."
			fi
		fi
	;;
	*)
		head
		printf "Help:\n"
		printf "    $0 version\n"
		printf "    $0 block { add sender | drop sender | show [all] }\n"
		printf "    $0 white { add sender | drop sender | show }\n"
		printf "    $0 reputation\n"
		printf "    $0 clear hostname\n"
		printf "    $0 refresh hostname\n"
		printf "    $0 check ip email helo\n"
		printf "    $0 spam ticketid/file\n"
		printf "    $0 ham ticketid/file\n"
		printf "    $0 query ip email helo recipient\n"
		printf "    $0 trap { add recipient | drop recipient | show }\n"
		printf "\n"
		printf "Admin Commands:\n"
		printf "    $0 shutdown\n"
		printf "    $0 store\n"
		printf "    $0 superclear hostname\n"
		printf "    $0 tld { add tld | drop tld | show }\n"
		printf "    $0 peer { add host [email] | drop { host | all } | show [host] | set host send receive | ping host | send host }\n"
		printf "    $0 retention { show [host] | release { sender | all } | reject { sender | all } }\n"
		printf "    $0 provider { add sender | drop sender | show }\n"
		printf "    $0 ignore { add sender | drop sender | show }\n"
		printf "    $0 client { add/set cidr domain option [email] | drop cidr | show }\n"
		printf "    $0 user { add email nome | drop email | show }\n"
		printf "    $0 superblock { add sender | drop sender | show [all] }\n"
		printf "    $0 superwhite { add sender | drop sender | show [all] }\n"
		printf "    $0 dump\n"
		printf "    $0 load path\n"
		printf "\n"
	;;
esac
