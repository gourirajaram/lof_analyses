#on ttyd
docker pull nikhilmilind/loftee #downloads newer image for the docker image
docker images #to check if required docker image is created
docker save docker.io/nikhilmilind/loftee:latest | gzip > loftee.tar.gz
ls -l #check that the created .tar.gz file is in the root directory
dx mkdir softwares_latest
dx upload loftee.tar.gz --path /softwares_latest/

