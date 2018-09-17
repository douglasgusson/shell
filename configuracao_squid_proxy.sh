#!/bin/bash

# Variáveis 
arquivo=squid.conf # Arquivo de configuração do Squid
http_port=3128 # Porta do proxy Squid
visible_hostname=$(hostname) # Nome da máquina

# Criar política de acesso (ACL)
# 	O nome da ACL
# 	Parâmetro de filtragem (neste caso o usuário poderá escolher apenas um por ACL).
# 		IP de origem (src)
#		IP de destino (dst)
# 		Domínio de origem (srcdomain)
# 		Domínio de destino (dstdomain)
# 		Palavra-chave (url_regex)
# 		Porta (port)
# 		Protocolo (proto)
# 		Data e Horário (time)
# 	Se a ACL será permitida ou bloqueada (allow/deny)
# Tamanho do cache em memória (em MB) (cache_mem)
# Tamanho máximo de objeto em cache na memória (em MB) (maximum_object_size_in_memory)
# Tamanho mínimo de objeto em cache em disco (em MB) (minimum_object_size)
# Tamanho máximo de objeto em cache em disco (em MB) (maximum_object_size)
# Apagar a configuração do Proxy
# Reiniciar o serviço
# Mostrar o status do servidor


# Criar política de acesso (ACL)
criar_acl() {

	nome_acl=$(
		dialog \
				--stdout \
				--no-shadow \
				--title 'Criar política de acesso (ACL)' \
				--inputbox 'Informe o nome da ACL:' \
	   		0 0)

	param_filtragem=$(
		dialog \
				--stdout \
				--no-shadow \
				--title 'Criar política de acesso (ACL)' \
				--menu 'Escolha um parâmetro de filtragem:' \
			0 0 0 \
			src 'IP de origem' \
			dst 'IP de destino' \
			srcdomain 'Domínio de origem' \
			dstdomain 'Domínio de destino' \
			url_regex 'Palavra-chave' \
			port 'Porta' \
			proto 'Protocolo' \
			time 'Data e Horário')

	permitir_bloquear=$(
		dialog \
				--stdout \
				--no-shadow \
			   	--title 'Criar política de acesso (ACL)' \
			   	--radiolist 'Essa ACL será permitida ou bloqueada?' \
		   	0 0 0 \
		   	allow 'Permitida' on \
		   	deny 'Bloqueada' off)

   	# EXEMPLO:
	# 	acl usuario_ofensor src 10.0.0.95
	# 	http_access deny usuario_ofensor

	case $param_filtragem in
		src) 
			ip_origem=$(
				dialog \
						--stdout \
						--no-shadow \
						--title 'Criar política de acesso (ACL)' \
						--inputbox 'Informe o IP de origem para a ACL:' \
			   		0 0)
		   		[ $? -ne 0 ] && main
		   		echo "acl $nome_acl $param_filtragem $ip_origem" >> ${arquivo}
		   		echo "http_access $permitir_bloquear $nome_acl" >> ${arquivo}

				dialog \
						--title 'Aguarde' \
						--textbox out \
					0 0 
				rm out ;;
	    dst) 
			ip_destino=$(
				dialog \
						--stdout \
						--no-shadow \
						--title 'Criar política de acesso (ACL)' \
						--inputbox 'Informe o IP de destino para a ACL:' \
			   		0 0)
		   		[ $? -ne 0 ] && main
		   		echo "acl ${nome_acl} ${param_filtragem} ${ip_destino}" >> ${arquivo}
		   		echo "http_access ${permitir_bloquear} ${nome_acl}" >> ${arquivo}

				dialog \
						--title 'Aguarde' \
						--textbox out \
					0 0 
				rm out ;;
		srcdomain) ;;
		dstdomain) ;;
		url_regex) ;;
		port) ;;
		proto) ;;
		time)
		    dias_semana=$(
		        dialog \
                        --stdout \
                        --title 'Criar política de acesso (ACL)' \
                        --no-shadow \
                        --checklist 'Escolha os dias da semana:' \
                   0 0 0                                    \
                   S 'Domingo' off \
                   M 'Segunda-feira' off \
                   T 'Terça-feira' off \
                   W 'Quarta-feira' off \
                   H 'Quinta-feira' off \
                   F 'Sexta-feira' off \
                   A 'Sábado' off)
            
            hora_inicial=$(
		        dialog \
                        --stdout \
                        --title 'Criar política de acesso (ACL)' \
                        --no-shadow \
                        --time-format %H%M \
                        --timebox)
            
                   
            echo "${variavel}" >> out 
		    variavel=$(echo $variavel | sed 's/ //g')
		    echo "${variavel}" >> out 0
		;;
	esac

}

# Tamanho do cache em memória (em MB) (cache_mem)
cache_memoria() {
	tam_cache_memoria=$(
		dialog \
				--stdout \
				--no-shadow \
				--title 'Tamanho do cache em memória' \
				--inputbox 'Informe um valor em MB (somente números):' \
	   		0 0)	
	[ $? -ne 0 ] && main
	sed -i '/cache_mem /d' $arquivo 
	echo "cache_mem $tam_cache_memoria MB" >> ${arquivo}
}

# Tamanho máximo de objeto em cache na memória (em MB) (maximum_object_size_in_memory)
max_obj_cache_memoria() {
	tam_max_obj_cache_memoria=$(
		dialog \
				--stdout \
				--no-shadow \
				--title 'Tamanho máximo de objeto em cache na memória' \
				--inputbox 'Informe um valor em MB (somente números):' \
	   		0 0)
	[ $? -ne 0 ] && main
	sed -i '/maximum_object_size_in_memory /d' $arquivo 
	echo "maximum_object_size_in_memory $tam_max_obj_cache_memoria MB" >> ${arquivo}
}

# Tamanho mínimo de objeto em cache em disco (em MB) (minimum_object_size)
min_obj_cache_disco() {
	tam_min_obj_cache_disco=$(
		dialog \
				--stdout \
				--no-shadow \
				--title 'Tamanho mínimo de objeto em cache em disco' \
				--inputbox 'Informe um valor em MB (somente números):' \
	   		0 0)
	[ $? -ne 0 ] && main
	sed -i '/minimum_object_size /d' $arquivo 
	echo "minimum_object_size $tam_min_obj_cache_disco MB" >> ${arquivo}
}

# Tamanho máximo de objeto em cache em disco (em MB) (maximum_object_size)
max_obj_cache_disco() {
	tam_max_obj_cache_disco=$(
		dialog \
				--stdout \
				--no-shadow \
				--title 'Tamanho máximo de objeto em cache em disco' \
				--inputbox 'Informe um valor em MB (somente números):' \
	   		0 0)
	[ $? -ne 0 ] && main
	sed -i '/maximum_object_size /d' $arquivo 
	echo "maximum_object_size $tam_max_obj_cache_disco MB" >> $arquivo
}

# Apagar a configuração do Proxy
apagar_configuracoes() {
	> $arquivo
	echo "http_port $http_port" >> $arquivo
    echo "visible_hostname $visible_hostname" >> ${arquivo}
}

# Reiniciar o serviço
restart_servico() { 
    service squid restart | \
    for ((x=0; $x<=100; x++)); do  
        dialog --title "Reiniciando o serviço" --gauge "Aguarde..." 10 60 $x 
	done
}

# Mostrar o status do servidor
status_servico() {
	service squid status > out
	dialog \
			--no-shadow \
			--title 'Status do serviço' \
			--textbox out \
  		0 0
   	rm out
}

# Mostrar o arquivo de configuração
mostrar_arquivo_config() {
	dialog \
			--no-shadow \
			--title 'Arquivo de configuração' \
			--backtitle $arquivo \
			--textbox $arquivo \
   		0 0
}

main() {

	while : ; do

		opcao=$(
			dialog \
					--stdout \
					--nocancel \
					--no-shadow \
					--title 'Configuração Proxy Squid' \
					--backtitle 'SISTEMAS DE INFORMAÇÃO - IFES [Douglas G. / Fernando B.]' \
					--menu 'Escolha uma opção:' \
				0 0 0 \
				1 'Criar política de acesso (ACL)' \
				2 'Tamanho do cache em memória' \
				3 'Tamanho máximo de objeto em cache na memória' \
				4 'Tamanho mínimo de objeto em cache em disco' \
				5 'Tamanho máximo de objeto em cache em disco' \
				6 'Apagar a configuração do Proxy' \
				7 'Reiniciar o serviço' \
				8 'Mostrar o status do servidor' \
				9 'Mostrar o arquivo de configuração' \
				0 'Sair')

		case $opcao in
			0) break ;;
		    1) criar_acl ;;
			2) cache_memoria ;;
			3) max_obj_cache_memoria ;;
			4) min_obj_cache_disco ;;
			5) max_obj_cache_disco ;;
			6) apagar_configuracoes ;;
			7) restart_servico ;;
			8) status_servico ;;
			9) mostrar_arquivo_config ;;
			*) main ;;
		esac

	done
    
    clear
}

main
