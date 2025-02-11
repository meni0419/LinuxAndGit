#/bin/sh
#
echo "Прежде чем продолжить, найдите на своем компьютере ваш публичный ключь ssh"
read -sn1 -p  "Вы готовы продожить?  Y or N  " KEY
if  [ $KEY = "Y" ] || [ $KEY = "y" ]
   then	
	read -p "Придумайте себе логин. Create your own login  " Login
	echo "Запомните свой логин -" $Login
	sudo adduser $Login -G 1000 2>/dev/null 
	if [ $? -eq 0 ]
	 then
		read -p "Вставте ВАШ скопированный публичный ключь ssh " Sshkey
		sudo mkdir -p /home/$Login/.ssh  
		sudo touch /home/$Login/.ssh/authorized_keys   
		echo $Sshkey | sudo tee -a /home/$Login/.ssh/authorized_keys
		sudo chown -R $Login:$Login /home/$Login/.ssh
		sudo chmod 700 /home/$Login/.ssh 
		sudo chmod 600 /home/$Login/.ssh/authorized_keys
	 else
		echo "Такой пользователь существует придумайте другой логин"
		echo "Запустите скрипт повторно"
	 fi
    else
	echo "Вы прервали работу! Пользователь не созданн!"
	echo "Хорошего дня!"	 
    fi	
