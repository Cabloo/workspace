Setup:
=======
- Copy config.sample to config
- (Optional) Personalize terminator.desktop and drag to sidebar
- (Optional) modify config
- Run install.sh
- Modify commands in terminator.sh

The config file is automatically symlinked to terminator's config file, so changes to it will occur in terminator on the next start.


TODO:
======
- Properly setup .gitignore and multiple separate configuration files that are parsed together in the installer so that multiple git instances merge well and don't conflict.
