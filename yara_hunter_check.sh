#! /bin/sh

# get latest yara-hunter image

export YARA_HUNTER_IMAGE="deepfenceio/yara-hunter:latest"
docker pull $YARA_HUNTER_IMAGE

# build image from Dockerfile for scanning

if [ $# -eq 0 ]# for no arguments
  then
    echo "About to Scan Dockerfile image"
    docker build -f Dockerfile -t image_name .
    docker run -it --rm --name=deepfence-yarahunter \
    -v /var/run/docker.sock:/var/run/docker.sock \
    $YARA_HUNTER_IMAGE --image-name image_name
    echo "Finished Scanning Dockerfile image"
    docker rmi image_name
    docker rmi $YARA_HUNTER_IMAGE
else # for arguments if they exist, format dir/name:tag
    for thing in "$@"
    do
        echo "About to Scan $thing"
        docker pull "quay.io/$thing"
        docker run -it --rm --name=deepfence-yarahunter \
        -v /var/run/docker.sock:/var/run/docker.sock \
        $YARA_HUNTER_IMAGE --image-name "quay.io/$thing"
        echo "Finished Scanning $thing"
        docker rmi "quay.io/$thing"
        docker rmi $YARA_HUNTER_IMAGE
    done
fi

# scan regularly, results not put in json 

# docker run -it --rm --name=deepfence-yarahunter \
#    -v /var/run/docker.sock:/var/run/docker.sock \
#    $YARA_HUNTER_IMAGE --image-name image_name 

# scan & add results to json, puts results into /my-output/node-scan.json

# docker run -it --rm --name=deepfence-yarahunter \
#    -v /var/run/docker.sock:/var/run/docker.sock \
#    -v $(pwd)/my-output:/home/deepfence/output \
#    $YARA_HUNTER_IMAGE --image-name image_name \
#    --json-filename node-scan.json

# remove images 



