#!/usr/bin/env bash

#Configure these two variables
MYUSER="joel"
APACHEGROUP="www-data"




SCRIPTPATH=`pwd -P`
BOOTSTRAP="$SCRIPTPATH/bootstrap/"
BOOTSTRAPCACHE="$SCRIPTPATH/bootstrap/cache/"
STORAGE="$SCRIPTPATH/storage"
LOGS="$STORAGE/logs"

#add my user to the web server group
sudo usermod -a -G ${APACHEGROUP} ${MYUSER}

#make www-data own everything in the directory
sudo chown -R ${MYUSER}:${APACHEGROUP} ${SCRIPTPATH}

#change permissions on files to 644
sudo find ${SCRIPTPATH} -type f -exec chmod 0644 {} \;

#change permissions on directories to 755
sudo find ${SCRIPTPATH} -type d -exec chmod 0755 {} \;

#if i have any bash scripts in there, make them executable
sudo find ${SCRIPTPATH} -type f -iname "*.sh" -exec chmod +x {} \;


#if bootstrap/cache does not exist, create it
if [ ! -d ${BOOTSTRAPCACHE} ]; then
    mkdir -p ${BOOTSTRAPCACHE}
fi


#fix ownership in bootstrap directory
chown ${MYUSER}:${APACHEGROUP} ${BOOTSTRAP}

chown ${MYUSER}:${APACHEGROUP} ${BOOTSTRAPCACHE}
#also fix permissions
chmod 0775 ${BOOTSTRAPCACHE}


#if bootstrap/cache/services file exists, fix permissions
if [ -f ${SCRIPTPATH}/bootstrap/cache/services.php ];
then
    chmod 0664 ${SCRIPTPATH}/bootstrap/cache/services.php
fi

#if storage dir does not exist, create it.
if [ ! -d ${SCRIPTPATH}/storage ]; then
    mkdir -p ${SCRIPTPATH}/storage
fi


#then, make sure we have debugbar, framework and logs inside storage
#debugbar is not installed by default, but it does not hurt to have it's directory there , ready for when you install it
for DIR in debugbar framework logs
do
    mkdir -p ${STORAGE}/${DIR}
done

#if we don't have a .gitignore file in storage/framework, add it
if [ ! -f ${SCRIPTPATH}/storage/framework/.gitignore ]; then
    echo 'compiled.php' > ${SCRIPTPATH}/storage/framework/.gitignore
    echo 'config.php' >> ${SCRIPTPATH}/storage/framework/.gitignore
    echo 'down' >> ${SCRIPTPATH}/storage/framework/.gitignore
    echo 'events.scanned.php' >> ${SCRIPTPATH}/storage/framework/.gitignore
    echo 'maintenance.php' >> ${SCRIPTPATH}/storage/framework/.gitignore
    echo 'routes.php' >> ${SCRIPTPATH}/storage/framework/.gitignore
    echo 'routes.scanned.php' >> ${SCRIPTPATH}/storage/framework/.gitignore
    echo 'schedule-*' >> ${SCRIPTPATH}/storage/framework/.gitignore
    echo 'services.json' >> ${SCRIPTPATH}/storage/framework/.gitignore
fi


#then, make sure we have  cache, sessions, testing and views inside storage/framework
for DIR in cache sessions testing views
do
    mkdir -p ${STORAGE}/framework/${DIR}
done


#then, make sure we have a storage/framework/cache/data directory
if [ ! -d ${SCRIPTPATH}/storage/framework/cache/data ]; then
    mkdir -p ${SCRIPTPATH}/storage/framework/cache/data
fi



#if we don't have a .gitignore file in storage/framework/cache/data, add it
if [ ! -f ${SCRIPTPATH}/storage/framework/cache/data/.gitignore ]; then
    echo '*' > ${SCRIPTPATH}/storage/framework/cache/data/.gitignore
    echo '!data/' >> ${SCRIPTPATH}/storage/framework/cache/data/.gitignore
    echo '!.gitignore' >> ${SCRIPTPATH}/storage/framework/cache/data/.gitignore
fi

#if we don't have a .gitignore file in storage/framework/sessions/, add it
if [ ! -f ${SCRIPTPATH}/storage/framework/sessions/.gitignore ]; then
    echo '*' > ${SCRIPTPATH}/storage/framework/sessions/.gitignore
    echo '!.gitignore' >> ${SCRIPTPATH}/storage/framework/sessions/.gitignore
fi

#if we don't have a .gitignore file in storage/framework/testing/, add it
if [ ! -f ${SCRIPTPATH}/storage/framework/testing/.gitignore ]; then
    echo '*' > ${SCRIPTPATH}/storage/framework/testing/.gitignore
    echo '!.gitignore' >> ${SCRIPTPATH}/storage/framework/testing/.gitignore
fi

#if we don't have a .gitignore file in storage/framework/views/, add it
if [ ! -f ${SCRIPTPATH}/storage/framework/views/.gitignore ]; then
    echo '*' > ${SCRIPTPATH}/storage/framework/views/.gitignore
    echo '!.gitignore' >> ${SCRIPTPATH}/storage/framework/views/.gitignore
fi

#last, fix the ownership of everything inside the storage directory
STORAGEFIXCOMMAND=`chown -R  ${MYUSER}:${APACHEGROUP} ${STORAGE}`
$STORAGEFIXCOMMAND
#and also fix permissions
chmod -R 0775 ${STORAGE}
