import skyui.util.Translator;

class SelectListCenteredList extends Shared.CenteredScrollingList {
	var EntriesA: Array;
	var iNumTopHalfEntries: Number;
	var iPlatform: Number;

	function SelectListCenteredList() {
		super();
	}

	function SetEntryText(aEntryClip: MovieClip, aEntryObject: Object): Void {
		var hotkeyText = aEntryObject.hotkey >= 0 && aEntryObject.hotkey <= 7 ? ( aEntryObject.hotkey + 1 ) + '. ' : '';
		aEntryClip.textField.SetText( hotkeyText + skyui.util.Translator.translate( aEntryObject.text ) );
		var maxTextLength: Number = 35;
		if (aEntryClip.textField.text.length > maxTextLength) {
			aEntryClip.textField.SetText(aEntryClip.textField.text.substr(0, maxTextLength - 3) + "...");
		}
		aEntryClip.textField.textAutoSize = "shrink";
		if (iPlatform == 0) {
			aEntryClip._alpha = aEntryObject == selectedEntry ? 100 : 60;
			return;
		}
		var alphaMultiplier: Number = 8;
		if (aEntryClip.clipIndex < iNumTopHalfEntries) {
			aEntryClip._alpha = 60 - alphaMultiplier * (iNumTopHalfEntries - aEntryClip.clipIndex);
			return;
		}
		if (aEntryClip.clipIndex > iNumTopHalfEntries) {
			aEntryClip._alpha = 60 - alphaMultiplier * (aEntryClip.clipIndex - iNumTopHalfEntries);
			return;
		}
		aEntryClip._alpha = 100;
	}

	function InvalidateData() {
		// EntriesA.sort(doABCSort); // @todo
		super.InvalidateData();
	}

	function doABCSort(aObj1: Object, aObj2: Object): Number {
		if (aObj1.text < aObj2.text) {
			return -1;
		}
		if (aObj1.text > aObj2.text) {
			return 1;
		}
		return 0;
	}

	function onMouseWheel(delta: Number): Void {
		if (delta == 1) {
			moveSelectionUp();
			return;
		}
		if (delta == -1) {
			moveSelectionDown();
		}
	}
}