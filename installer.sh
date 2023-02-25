# setup a workspace
mkdir ESPHomeZephyr
cd ESPHomeZephyr

# create a new python environment
python3 -m venv zephyrenv

# activate the environment
source zephyrenv/bin/activate

# make a dir for the zephyr source code
mkdir zephyrproject

# get the source code
pip install west

west init zephyrproject

cd zephyrproject
west update

# check out the version that is tested to work
# this will change in the future when switching
# to a stable release
cd zephyr
git checkout 54031d2b62
cd ..
west update

west zephyr-export

# install zephyr python requirements
pip install -r zephyr/scripts/requirements.txt

# install the zephyr sdk
# go to the project workspace
cd ..
wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.15.2/zephyr-sdk-0.15.2_macos-x86_64.tar.gz
tar xvf zephyr-sdk-0.15.2_macos-x86_64.tar.gz

cd zephyr-sdk-0.15.2
./setup.sh

# back up to the project workspace
cd ..

# install the DFU tool, requires GO
# for go < 1.18
#go get github.com/apache/mynewt-mcumgr-cli/mcumgr
# for go >= 1.18
go install github.com/apache/mynewt-mcumgr-cli/mcumgr@latest

# get the esphome modified to work with zephyr
git clone  git@github.com:natelust/esphome.git

cd esphome
# get a specific sha, as ongoing development might break things
git checkout 73ce7dcbe8fca3a46c935e900e7de4475f843745

# build and install it into the python venv
python setup.py build && python setup.py install
