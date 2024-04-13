# Activate the conda environment
source ~/anaconda/etc/profile.d/conda.sh
conda activate longformer

# Training Data
unzip Museformer_data.zip
cp -r Museformer_data/* ./

LENGTHS=(1024 4096 7168 15360 19456 23552 31744)

bash mf-lmd6remi-f1_pytorch.sh 1024

for lens in ${LENGTHS[@]}; do
    bash mf-lmd6remi-f1_pytorch.sh ${lens}
    bash mf-lmd6remi-f1_pytorch_s.sh ${lens}
    bash mf-lmd6remi-f1_deepspeed.sh ${lens}
    bash mf-lmd6remi-f1_pit.sh ${lens}
done

python plot.py
