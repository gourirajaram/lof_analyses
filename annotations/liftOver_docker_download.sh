#on ttyd UKB RAP
docker pull vanallenlab/liftover
docker images #to check if required docker image is created
docker save docker.io/vanallenlab/liftover:latest | gzip > liftover.tar.gz
ls -l #check that the created .tar.gz file is in the root directory
dx upload liftover.tar.gz --path /create_annot/
