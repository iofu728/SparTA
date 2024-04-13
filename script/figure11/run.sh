
# Activate the conda environment
source ~/anaconda/etc/profile.d/conda.sh
conda activate longformer

# Download model weights
wget https://ai2-s2-research.s3-us-west-2.amazonaws.com/longformer/longformer-base-4096.tar.gz
wget https://ai2-s2-research.s3-us-west-2.amazonaws.com/longformer/longformer-large-4096.tar.gz
tar -zxvf longformer-base-4096.tar.gz
tar -zxvf longformer-large-4096.tar.gz

unzip data.zip
cp data/*.pkl ./

MODELS=(longformer-base-4096/ longformer-large-4096/)
MAX_TOKENS=(2048 4096)

for model in ${MODELS[@]}; do
    for tokens in ${MAX_TOKENS[@]}; do
        python run_pytorch.py --model_name ${model} --max_seq_length ${tokens}
        python run_pytorch_s.py --model_name ${model} --max_seq_length ${tokens}
        python run_longformer_s.py --model_name ${model} --max_seq_length ${tokens}
        python run_deepspeed.py --model_name ${model} --max_seq_length ${tokens}
        python run_pit.py --model_name ${model} --max_seq_length ${tokens}
    done
done

python plot.py
