depuis Code/

python3 -m venv ../ExVivoMouseBrainPyEnv

source ../ExVivoMouseBrainPyEnv/bin/activate

pip install torch==2.3.1 torchvision==0.18.1 torchaudio==2.3.1 --index-url https://download.pytorch.org/whl/cpu

cd ..

git clone https://github.com/MIC-DKFZ/nnUNet.git
cd  nnUNet
git checkout v2.2
pip install -e .
