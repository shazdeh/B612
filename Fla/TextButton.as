import gfx.io.GameDelegate;
import gfx.controls.Button;

class TextButton extends gfx.controls.Button {

    /* stage */
    public var ButtonText:TextField;
    public var HitArea:MovieClip;
    public var SelectionIndicatorHolder:MovieClip;
    public var BtnArt_mc:MovieClip;

    /* config */
    public var selectionPadding:Number = 30;

    /* props */
    public var bEnableSelectionIndicator:Boolean = true;
    public var totalWidth:Number = 0;

    function setData(label:String, keycode:Number) {
        ButtonText.autoSize = "left";
        ButtonText.verticalAlign = "center";
        ButtonText.verticalAutoSize = "center";
        ButtonText.SetText( label, false );
        var buttonArtSize:Number = 0;
        if ( keycode !== 0 && keycode !== undefined ) {
            BtnArt_mc.gotoAndStop(keycode);
            BtnArt_mc._x = ButtonText._x - BtnArt_mc._width;
            buttonArtSize = BtnArt_mc._width;
        } else {
            BtnArt_mc._visible = false;
        }
        HitArea._width = ButtonText._width;
        totalWidth = ButtonText._width - buttonArtSize;
        if ( bEnableSelectionIndicator === true ) {
            SelectionIndicatorHolder.SelectionIndicator._width = ButtonText._width + buttonArtSize + selectionPadding;
            SelectionIndicatorHolder.SelectionIndicator._y = ButtonText._y + (ButtonText._height / 2);
            SelectionIndicatorHolder.SelectionIndicator._x += totalWidth / 2;
        } else {
            SelectionIndicatorHolder._visible = false;
        }
        addEventListener("focusIn", focusCallback);
    }

    function focusCallback() {
        GameDelegate.call("PlaySound", ["UIMenuFocus"]);
    }
}