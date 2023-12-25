#!/bin/bash

# Files to modify
symbols="/usr/share/X11/xkb/symbols/se"
evdev_xml="/usr/share/X11/xkb/rules/evdev.xml"
evdev_lst="/usr/share/X11/xkb/rules/evdev.lst"

# Text to add
swerty_variant="\ \ \ \ \ \ \ \ <variant>\\
          \<configItem>\\
            \<name>swerty\</name>\\
            \<description>Swerty\</description>\\
          \</configItem>\\
        \</variant>"
swerty_variant_lst="\ \ swerty          se: Swerty"

#Check root privileges
if [ "$USER" != "root" ]
then
    echo "This script needs root priviligies"
    exit 2
fi


# Append contents of se.txt to the end of $symbols
cat ./se.txt >> $symbols


# Add variant block to $evdev_xml
line_number=$(grep -n "<name>se</name>" "${evdev_xml}" | cut -d':' -f1)
insert_line=$line_number
tail -n +$line_number "${evdev_xml}" | while IFS= read -r line; do
    ((insert_line++))
    if [[ $line == *"<variantList>"* ]]; then
        sed -i "${insert_line}i ${swerty_variant}" "${evdev_xml}"
        break
    fi
done


# # Add swerty as a keyboard option to $evdev_lst
line_number_lst=$(grep -n "! variant" "${evdev_lst}" | cut -d':' -f1)
((line_number_lst++))
sed -i "${line_number_lst}i ${swerty_variant_lst}" "${evdev_lst}"

echo "Successfully installed swerty. You can now add the keyboard layout and then log out and in again"
