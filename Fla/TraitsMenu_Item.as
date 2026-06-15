import gfx.io.GameDelegate;

class TraitsMenu_Item extends MovieClip {

    /* Stage */
    public var ItemName_tf:TextField;
    public var EquipIcon_mc:MovieClip;
    public var Highlight_mc:MovieClip;
    private var Menu_mc:MovieClip; /* reference to TraitsMenu */

    public var index:Number;
    private var data:Object;

    /* layout */
    private var sidePadding:Number = 5;

    function onLoad() {
        EquipIcon_mc._visible = false;
        Highlight_mc._visible = false;
    }

    function setData( a_data:Object, a_Menu_mc:MovieClip ) {
        data = a_data;
        Menu_mc = a_Menu_mc;
        ItemName_tf.SetText(a_data.title);
        drawHighlight();
    }

    function onRollOver() {
        Menu_mc.iFocusIndex = index;
        Selection.setFocus(this);
    }

    function onRelease() {
        Menu_mc.onPickItem(index);
    }

    function onSetFocus() {
        GameDelegate.call("PlaySound", ["UIMenuFocus"]);
        Highlight_mc._visible = true;
        Menu_mc.updateDetails(index);
        Menu_mc.clearUnfocusedItem(this);
    }

    function onKillFocus() {
        if ( Menu_mc.iFocusIndex !== index ) {
            Highlight_mc._visible = false;
        }
    }

    /* called when this item is chosen by player */
    function select() {
        EquipIcon_mc._visible = true;
    }

    /* called when this item is unchosen by player */
    function unselect() {
        EquipIcon_mc._visible = false;
    }

    function drawHighlight() {
        var w = _width, h = _height;
        Highlight_mc.lineStyle(1, 0xffffff, 70);
        Highlight_mc.moveTo( 0, 0 );
        Highlight_mc.lineTo( w + sidePadding, 0);
        Highlight_mc.lineTo( w + sidePadding, h + sidePadding );
        Highlight_mc.lineTo( 0, h + sidePadding );
        Highlight_mc.lineTo(0, 0);
    }
}