#!/bin/bash
#chmod +x generate_localization.sh

#sudo chown -R $(whoami) /Users/sakastudio/development/projects/asset_tracker/lib/generated/

#flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart


echo "Generating localization files..."
sudo flutter pub run easy_localization:generate --source-dir ./assets/translations -f keys -o locale_keys.g.dart