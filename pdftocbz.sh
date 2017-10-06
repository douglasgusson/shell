#!/bin/sh
#Requer o pacote poppler instalado


for ARQUIVO in "${@}"
do
	PASTA=$(echo $ARQUIVO | cut -f 1 -d '.')

	AMARELO='\033[0;33m' 
	VERDE='\033[0;32m'
	SEMCOR='\033[0m' 

	mkdir -p $PASTA
	mkdir -p cbz

	echo -e "Extraindo imagens de ${AMARELO}$ARQUIVO${SEMCOR} (pode demorar um pouquinho)..."

	pdfimages -j $ARQUIVO $PASTA/page; 

	zip -r $PASTA.cbz $PASTA

	mv $PASTA.cbz cbz/
	rm -r $PASTA

	echo -e "${VERDE}Uhuul! $PASTA.cbz gerado.${SEMCOR}"
done
exit 1
	
