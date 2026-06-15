import Shared.GlobalFunc;
import gfx.io.GameDelegate;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import skse;

class SelectListMenu extends MovieClip {
	var bPCControlsReady: Boolean = true;
	var ItemList: MovieClip;
	var LeftPanel: MovieClip;
	var List_mc: MovieClip;

	/* state vars */
	var clickedIndex:Number;
	var data:String;
	var fadingOut:Boolean;

	function SelectListMenu() {
		super();
		ItemList = List_mc;
		clickedIndex = -1;
		fadingOut = false;
	}

	function InitExtensions(): Void {
		ItemList.addEventListener("listMovedUp", this, "onListMoveUp");
		ItemList.addEventListener("listMovedDown", this, "onListMoveDown");
		ItemList.addEventListener("itemPress", this, "onItemSelect");
		FocusHandler.instance.setFocus(ItemList, 0);
	}

	function handleInput(details: InputDetails, pathToFocus: Array): Boolean {
		if ( fadingOut ) {
			return;
		}
		if (!pathToFocus[0].handleInput(details, pathToFocus.slice(1))) {
			if (Shared.GlobalFunc.IsKeyPressed(details) && details.navEquivalent == NavigationCode.TAB) {
				startFadeOut();
			}
			/* 1 to 7 */
			if ( details.code > 48 && details.code < 56 ) {
				if ( ItemList.EntriesA[ details.code - 49 ] ) {
					clickedIndex = details.code - 49;
					startFadeOut();
				}
			}
		}

		return true;
	}

	function get selectedIndex(): Number {
		return ItemList.selectedEntry.index;
	}

	function get itemList(): MovieClip {
		return ItemList;
	}

	function setSelectedItem(aiIndex: Number): Void {
		for (var i: Number = 0; i < ItemList.entryList.length; i++) {
			if (ItemList.entryList[i].index == aiIndex) {
				ItemList.selectedIndex = i;
				ItemList.RestoreScrollPosition(i);
				ItemList.UpdateList();
				return;
			}
		}
	}

	function onListMoveUp(event: Object): Void {
		GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		if (event.scrollChanged == true) {
			gotoAndPlay("moveUp");
		}
	}

	function onListMoveDown(event: Object): Void {
		GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		if (event.scrollChanged == true) {
			gotoAndPlay("moveDown");
		}
	}

	function onItemSelect(event: Object): Void {
		clickedIndex = ItemList.EntriesA[event.index].ID;
		startFadeOut();
	}

	function startFadeOut(): Void {
		fadingOut = true;
		_parent.gotoAndPlay("startFadeOut");
	}

	function onFadeOutCompletion(): Void {
		skse.SendModEvent( 'b612_SelectList_Select', '', clickedIndex );
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void {
		ItemList.SetPlatform(aiPlatform, abPS3Switch);
		LeftPanel._x = aiPlatform == 0 ? -90 : -78.2;
		LeftPanel.gotoAndStop(aiPlatform == 0 ? "Mouse" : "Gamepad");
	}

	function setData(serializedString:String) {
		ItemList.ClearList();
		var items = serializedString.split('_|_');
		for ( var i = 0; i < items.length; i++ ) {
			var item = items[ i ].split( '_:_' );
			ItemList.EntriesA.push( { text : item[1], hotkey : i, ID : parseInt( item[0] ) } );
		}
		ItemList.InvalidateData();
		InitExtensions();
		_parent.play();
	}
}
