#! /bin/sh

# get latest yara-hunter image

export YARA_HUNTER_IMAGE="deepfenceio/yara-hunter:latest"
docker pull $YARA_HUNTER_IMAGE

# build image from Dockerfile for scanning

docker build -f Dockerfile -t image_name .

# scan regularly, results not put in json 

docker run -it --rm --name=deepfence-yarahunter \
    -v /var/run/docker.sock:/var/run/docker.sock \
    $YARA_HUNTER_IMAGE --image-name image_name 

# scan & add results to json, puts results into /my-output/node-scan.json

# docker run -it --rm --name=deepfence-yarahunter \
#    -v /var/run/docker.sock:/var/run/docker.sock \
#    -v $(pwd)/my-output:/home/deepfence/output \
#    $YARA_HUNTER_IMAGE --image-name image_name \
#    --json-filename node-scan.json

# remove images 
docker rmi image_name
docker rmi $YARA_HUNTER_IMAGE


