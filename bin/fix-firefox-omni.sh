#!/bin/sh
echo "Fixing Firefox forms.css (radio/checkbox color)"
RET=0
cd /tmp
mkdir firefox_omni; cd firefox_omni
unzip -q /lib/firefox/omni.ja 2> /dev/null

while true; do
	MATCH=$(pcregrep -M -n 'input\[type="checkbox"\] \{(\n|[^}])*\bcolor\b' \
		chrome/toolkit/res/forms.css)

	[[ ! $MATCH ]] && { echo "Pattern not found"; RET=1; break; }

	LINE=$(($(echo "$MATCH" | head -n 1 | cut -d: -f1) + $(echo "$MATCH" | wc -l) - 1))

	sed -i "$LINE,${LINE}s/\s*!\s*important\s*//" chrome/toolkit/res/forms.css
	[[ $? != 0 ]] && { echo "radio/checkbox color isn't set to !important"; RET=1; break; }

	zip -qr9XD omni.ja *
	echo "Hack done, replacing original omni.ja"
	sudo mv /lib/firefox/omni.ja /lib/firefox/omni.ja.bak
	sudo cp omni.ja /lib/firefox
	echo "omni.ja successfully replaced"
	break
done

cd ..
rm -rf firefox_omni

exit $RET
