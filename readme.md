# .my_configs
Al's personal configs, aliases, and scripts!

## Installation

### Pre-requirements:
- git is installed in the command line
- an [ssh-key has been generated for this machine](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and has been [added to the associated GitHub account](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) (for repo read/write access only)
        
        $ ssh-keygen -t ed25519 -C "your_email@example.com"
        $ ssh-add

### Install Instructions
1. Clone the directory locally to the home directory:

        $ cd ~ && git clone git@github.com:alkorion/.my_configs.git

2. Make the setup script executable:

        $ chmod u+x ~/.my_configs/mac_setup.sh

3. Run the setup script (and follow instructions as prompted):

        $ ~/.my_configs/mac_setup.sh



## Additional Notes

- This repo is primarily for my personalized setup of various things like shell appearance, keyboard shortcuts and command aliases
- If you'd like to use something similar, feel free to branch off of my repo and customize your own as you see fit


-- *Al the Pal*