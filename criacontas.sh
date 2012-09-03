#!/bin/bash

#
# Script para criacao de contas e alias no Zimbra
# Criado por Guto Carvalho <gutocarvalho@gmail.com>
# Criado em 2012-05-10
#

#
# ele faz a leitura de um arquivo com o seguinte formato
# conta_no_ad,conta_de_correio,nome_completo
#

# exemplo:
#
# augusto,jose.carvalho,Jose Augusto da Costa Carvalho
# fsouza,fernando.souza,Fernando Souza
# 99904x,camila.morgado,Camila Morgado
#
# lembre-se, uma conta por linha, com informacoes separadas por vírgula
#

#######################################################################

# constantes

DOMINIO="dominio.df.gov.br"
LISTA="lista.txt"
SENHA="senhatemporaria"

DEBUGLOG="debug.log"
ERROSLOG="erros.log"

# variaveis

export QTDC=0
export QTDA=0
export ERROSC=0
export ERROSA=0

# limpando arquivos de log

if [ -s debug.log ];then rm -f debug.log;touch debug.log;fi
if [ -s erros.log ];then rm -f erros.log;touch erros.log;fi

# criando usuario e alias usando repetição

while read line;do

	# setando variaveis
	USER=$(echo $line | cut -d, -f1)
	MAIL=$(echo $line | cut -d, -f2)
	NAME=$(echo $line | cut -d, -f3)

	# criando usuario
	zmprov ca $USER@$DOMINIO $SENHA displayName "$NAME" 2>>$DEBUGLOG
	export ST=$?
	# verificando erros
	if [ $ST -eq 1 ];then
		echo erro na criacao da conta $USER@$DOMINIO do usuário "$NAME" 2>>$ERROSLOG
		let ERROSC++
	elif [ $ST -eq 2 ];then
		echo erro na criacao da conta $USER@$DOMINIO do usuário "$NAME" 2>>$ERROSLOG
		let ERROSC++
	else
		let QTDC++
		echo "usuario $USER@$DOMINIO criado"
	fi
	
	# criando alias
	zmprov aaa $USER@$DOMINIO $MAIL@$DOMINIO 2>>$DEBUGLOG
	export ST=$?
	# verificando erros
	if [ $ST -eq 1 ];then
		echo erro na criacao do alias $USER@$DOMINIO para $MAIL@$DOMINIO 2>>$ERROSLOG
	let ERROSA++
	elif [ $ST -eq 2 ];then
		echo erro na criacao do alias $USER@$DOMINIO para $MAIL@$DOMINIO 2>>$ERROSLOG
		let ERROSA++
	else
		let QTDA++
		echo "alias $MAIL@$DOMINIO para conta $USER@$DOMINIO criado."
	fi
done < $LISTA

# imprimindo informacoes

echo "foram criada(s) $QTDC conta(s)."
echo "foram criada(s) $QTDA alias."

# imprimindo erros, se houver

if [ $ERROSC -gt 0 ];then
	echo "houve $ERROSC registro(s) de erros ao criar contas."
fi

if [ $ERROSA -gt 0 ];then
	echo "houve $ERROSA registro(s) de erros ao criar alias."
fi

# fim
