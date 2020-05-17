#!/bin/bash
DIRECTORY="$(pwd)/notebook"

if [[ -d "$DIRECTORY" ]]; then
    echo "Using cached file"
else 
    echo "Downloading files"
    mkdir notebook
    cd "$DIRECTORY"

    wget https://s3-us-west-2.amazonaws.com/xgboost-examples/MQ2008.rar
    unrar x MQ2008.rar
    mv -f MQ2008/Fold1/*.txt .
    # convert data format
    python ../trans_data.py train.txt mq2008.train mq2008.train.group
    python ../trans_data.py test.txt mq2008.test mq2008.test.group
    python ../trans_data.py vali.txt mq2008.vali mq2008.vali.group

    cd ..
fi

docker run -it --rm \
       --name learning-to-rank-explained-with-code \
       -v $(pwd)/notebook:/home/jovyan \
       -p 8888:8888 \
       jupyter/scipy-notebook
