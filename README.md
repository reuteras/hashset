# Linux hash sets of known files for Autopsy

A package for creating hash set of known Linux files for use in i [Autopsy]. Can't store the generated files on GitHub due to the size of the files. To download files for Ubuntu 20.04 LTS (x86 and x64) you will need almost 300 GB of disk space.

## Usage

Download the repo:

    git clone https://github.com/reuteras/hashset.git

Install dependencies:

    sudo apt install apt-mirror sleuthkit

To create an index for Ubuntu 20.04 run

    cd hashset
    ./generate-hash-set.sh ubuntu 2004

After downloading the Ubuntu repo and extracting md5sums from deb-packages the resulting idx file is available i the *output* directory.

    $ ls output/ubuntu_2004-md5*
    output/ubuntu_2004-md5  output/ubuntu_2004-md5-md5.idx  output/ubuntu_2004-md5-md5.idx2

TDODO

- Country selection for mirror should be done in config.

  [aut]: https://github.com/sleuthkit/autopsy

