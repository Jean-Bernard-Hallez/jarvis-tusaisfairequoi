#!/bin/bash
# Here you can create functions which will be available from the commands file
# You can also use here user variables defined in your config file

jv_pg_ct_tusaisfairequoi () {
ETAPEQUOI=$(( $ETAPEQUOI + 1 )); 

if [[ "$ETAPEQUOI" == "1" ]] ; then
say "Je recherche..."
tusaisfairequoi_total=`cat /home/pi/jarvis/plugins_installed/jarvis-tusaisfairequoi/plugins_jesais.txt | grep "jarvis-" | wc -l`
adresseip_wifi=`ifconfig wlan0 | sed -n 's/.*inet.*adr:\([0-9.]*\).*/\1/p'`
adresseip_eth0=`ifconfig eth0 | sed -n 's/.*inet.*adr:\([0-9.]*\).*/\1/p'`
if test -z $adresseip_eth0; then adresseip_jesais="$adresseip_wifi"; else adresseip_jesais="$adresseip_eth0"; fi

valire_cequejaiplugin
tusaisfairequoi=`cat /home/pi/jarvis/plugins_installed/jarvis-tusaisfairequoi/plugins_jai.txt` 
tusaisfairequoi_plugin=`echo  "$tusaisfairequoi" |  cut -d":" -f1 | sed -e "s/;/\n/g" | sort | uniq | paste -s -d "," | sed -e "s/ , /, /g" | cut -c3-`
tusaisfairequoi_categorie=`echo  "$tusaisfairequoi" |  cut -d":" -f2 | sed -e "s/;/\n/g" | sort | uniq | paste -s -d "," | sed -e "s/ , /, /g" | cut -c2-`
tusaisfairequoi_categorie_total=`echo "$tusaisfairequoi_categorie" | wc -w`

say "Je sais faire plus de $tusaisfairequoi_total_enabled choses différentes"
say "Commencez par choisir parmi les $tusaisfairequoi_categorie_total catégories: $tusaisfairequoi_categorie"
return;
fi


if [[ "$ETAPEQUOI" == "2" ]] ; then
REPONSEQUOI1="$REPONSEQUOI"
tusaisfairecategorie_total=`echo "$tusaisfairequoi" | grep "$REPONSEQUOI1" | sort | uniq | cut -d":" -f3 | wc -l`
say "Que souhaites tu mieux maitriser parmi ces $tusaisfairecategorie_total sous-catégorie ?"
tusaisfairecategorie_compteur="1"

while test $tusaisfairecategorie_compteur != $(( $tusaisfairecategorie_total + 1 ))
do
tusaisfairecategorie_choixok=`echo "$tusaisfairequoi" | grep "$REPONSEQUOI1" | cut -d":" -f3 | sort | uniq | sed -n $tusaisfairecategorie_compteur\p`
say "$tusaisfairecategorie_choixok"
tusaisfairecategorie_compteur=$(( $tusaisfairecategorie_compteur + 1 ))
done
return;
fi

if [[ "$ETAPEQUOI" == "3" ]] ; then
REPONSEQUOI2="$REPONSEQUOI"

say "Il faut que tu me dises par exemple:"
tusaisfairecategorie_choixok1=`echo "$tusaisfairequoi" | grep "$REPONSEQUOI1" | grep "$REPONSEQUOI2" | sort | uniq | cut -d":" -f4`
if [[ "$tusaisfairecategorie_choixok1" =~ "Avec la commande HTTP et le port" ]]; then
say "Avec la dommande HTTP $adresseip_jesais deux points $jv_pg_ui_port vous serrez directement sur l'interface graphique Jarvis"
else
say "$tusaisfairecategorie_choixok1"
fi
say "Voilà...à toi de me poser la bonne question"
GOTOSORTIQUOI="Fin"
ETAPEQUOI=""
tusaisfairecategorie_compteur=""
return;
fi

}


valire_cequejaiplugin() {
local tusaisfairequoi1=`cat /home/pi/jarvis/plugins_installed/jarvis-tusaisfairequoi/plugins_jesais.txt` 
local tusaisfairequoi_totalplugin=`cat /home/pi/jarvis/plugins_installed/jarvis-tusaisfairequoi/plugins_jesais.txt | wc -l` # tous les plugins: installés ou non installés

tusaisfairequoi_fichierjai="/home/pi/jarvis/plugins_installed/jarvis-tusaisfairequoi/plugins_jai.txt"  # tous les plugins répertorié et installés 
tusaisfairequoi_fichierjai_blanc=`cat /home/pi/jarvis/plugins_installed/jarvis-tusaisfairequoi/plugins_jesais.txt | tr '\n' '%%' | grep -o "%%" | wc -l`  # tous les plugins répertorié et installés 

tusaisfairequoi_enabled_nom=`find /home/pi/jarvis/plugins_enabled/` #tous les plugins que j'ai Ennabled
tusaisfairequoi_enabled_total=`find /home/pi/jarvis/plugins_enabled/ | wc -l ` # compte tous les plugins que j'ai Ennabled

if [ ! -e "$tusaisfairequoi_fichierjai" ]; then 
say "Listing de vos plugins Ennabled"
local tusaisfairecategorie_compteurB="1"
local tusaisfairecategorie_compteurM="1"

while test $tusaisfairecategorie_compteurB != $(( $tusaisfairequoi_totalplugin + 1 ))
do

	if [[ "$tusaisfairecategorie_compteurM" -ge "$(( $tusaisfairequoi_enabled_total + $tusaisfairequoi_fichierjai_blanc ))" ]]; then
	local tusaisfairecategorie_compteurB=$(( $tusaisfairequoi_totalplugin + 1 ))
	else

	local tusaisfairecategorie_compteurC=`echo "$tusaisfairequoi1" | cut -d":" -f1 | sed -n $tusaisfairecategorie_compteurB\p | sed "s/.$//"`
		# if [[ "$tusaisfairecategorie_compteurC" =~ `echo "$tusaisfairequoi_enabled_nom" | grep -o "$tusaisfairecategorie_compteurC"` ]]; then 
		if [[ `echo "$tusaisfairequoi_enabled_nom" | grep -o "$tusaisfairecategorie_compteurC"` != "" ]]; then 
		echo "$tusaisfairequoi1" | cut -d":" -f1- | sed -n $tusaisfairecategorie_compteurB\p >> "$tusaisfairequoi_fichierjai"
		local tusaisfairecategorie_compteurM=$(( $tusaisfairecategorie_compteurM + 1 ))
		fi

	tusaisfairecategorie_compteurB=$(( $tusaisfairecategorie_compteurB + 1 ))
	fi
done
fi

tusaisfairequoi_total_enabled=$(( `find /home/pi/jarvis/plugins_enabled/ | wc -l` - 1 ))
tusaisfairequoi_fichierjai_total=`cat /home/pi/jarvis/plugins_installed/jarvis-tusaisfairequoi/plugins_jai.txt | grep "jarvis-" | wc -l`

if [[ "$tusaisfairequoi_fichierjai_total" != "$tusaisfairequoi_total_enabled" ]]; then
say "Modification de vos plugins Ennabled, je remets à jour le listing de vos plugins actifs"
echo "$tusaisfairequoi_fichierjai_total != $tusaisfairequoi_total_enabled"
sudo rm $tusaisfairequoi_fichierjai
valire_cequejaiplugin
fi
}
