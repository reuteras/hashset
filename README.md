# Hash sets

Scripts to create hash sets for Linux and Windows for use in DFIR investigations with [Autopsy][aut] and similar tools.

## Installation

Download this repo:

    git clone https://github.com/reuteras/hashset.git

Install dependencies on Linux:

    sudo apt install apt-mirror sleuthkit

Install dependencies on macOS with [Homebrew][hbr]:

    brew install sleuthkit

## Linux hash sets of known files for Autopsy

Can't store the generated files on GitHub due to the large size of the generated files. Observe that to download the files for Ubuntu 20.04 LTS (x86 and x64) you will need almost 300 GB of disk space.

To create an index for Ubuntu 20.04 run

    cd hashset
    ./generate-linux-hash-set.sh ubuntu 2004

After downloading the Ubuntu repo and extracting md5sums from deb-packages the resulting idx file is available i the *output* directory.

    $ ls output/ubuntu_2004-md5*
    output/ubuntu_2004-md5  output/ubuntu_2004-md5-md5.idx  output/ubuntu_2004-md5-md5.idx2

### TODO

- Country selection for mirror should be done in config.

## Windows hash sets of known files for Autopsy

Uses the data from [AndrewRathbun/VanillaWindowsReference][vwr] to get the md5 hash.

To create an index for Windows:

    cd hashset
    ./generate-windows-hash-set.sh

Afterwards the index files are located in the *output* directory.

## Alternatives

A interesting alternative is [hashr][has] by Google even though it is more complex to setup.

  [aut]: https://github.com/sleuthkit/autopsy
  [has]: https://github.com/google/hashr
  [hbr]: https://brew.sh
  [vwr]: https://github.com/AndrewRathbun/VanillaWindowsReference

