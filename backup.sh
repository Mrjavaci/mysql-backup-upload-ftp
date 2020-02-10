
#!/bin/bash

######################################################
#  Mr.Javaci-Osman Taha
#  tarih: 25.01.2020
######################################################

DATE=`date +%m-%d-%Y`
LOCAL_BACKUP_DIR="/local_backup/"
DB_NAME=""
DB_USER=""
DB_PASSWORD=""
FTP_SERVER=""
FTP_USERNAME=""
FTP_PASSWORD=""
FTP_UPLOAD_DIR=""
LOG_FILE=/backup/backup-DATE.log

############### Local Backup  ########################

mysqldump -u $DB_USER  -p$DB_PASSWORD $DB_NAME | gzip  > $LOCAL_BACKUP_DIR/$DB_NAME-$DATE.sql.gz

############### UPLOAD to FTP Server  ################

ftp -n $FTP_SERVER << EndFTP
user "$FTP_USERNAME" "$FTP_PASSWORD"
binary
hash
cd $FTP_UPLOAD_DIR
#pwd
lcd $LOCAL_BACKUP_DIR
put "$DB_NAME-$DATE.sql.gz"
bye
EndFTP

if test $? = 0
then
    echo "Basarili upload
        Dosya Adi $DB_NAME-$DATE.sql.gz " > $LOG_FILE
else
    echo "HATA -> " > $LOG_FILE
fi
