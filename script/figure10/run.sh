
# Activate the conda environment
source ~/anaconda/etc/profile.d/conda.sh
conda activate artifact

pip install git+https://github.com/iofu728/transformers.git@v4.20.0_PIT

unzip data.zip

DATA_DIRS=(data/glue data/LongDocument)

for data_dir in ${DATA_DIRS[@]}; do
    CUDA_VISIBLE_DEVICES=0 python run_pytorch.py --data_dir ${data_dir}
    CUDA_VISIBLE_DEVICES=0 python run_pytorch_s.py --data_dir ${data_dir}
    CUDA_VISIBLE_DEVICES=0 python run_deepspeed.py --data_dir ${data_dir}
    CUDA_VISIBLE_DEVICES=0 python run_turbo.py --data_dir ${data_dir}
    CUDA_VISIBLE_DEVICES=0 python run_pit.py --data_dir ${data_dir}
done

python plot.py

