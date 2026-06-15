import skse;
import JSON;
import ShazdehUtils;
import Shared.GlobalFunc;
import gfx.controls.Button;
import gfx.io.GameDelegate;

class Leaderboard extends MovieClip {

    public static var instance;

    /* stage */
    public var Header_tf:TextField;
    public var Background_mc:MovieClip;
    public var ItemsContainerWrap_mc:MovieClip;
    public var ItemsContainer_mc:MovieClip;
    public var Mask_mc:MovieClip;
    public var ItemText_tf:TextField;
    public var OkBtn_mc:MovieClip;
    public var Scrollbar_mc:MovieClip;

    /* internal */
    private var data:Array;
    private var ScrollSpeed:Number = 20;
    private var maxScroll:Number;

    /* config */
    private var sButtonText:String = '$B612_CLOSE';

    /* layout */
    public var itemMargin:Number = 15;

    function Leaderboard() {
        Leaderboard.instance = this;
    }

    function onLoad() {
        Selection["alwaysEnableArrowKeys"] = false;
        Selection["disableFocusKeys"] = true;
        _focusrect = false;
        _visible = false;
        Shared.GlobalFunc.MaintainTextFormat();
        ItemsContainer_mc = ItemsContainerWrap_mc.ItemsContainer_mc;
        data = [];
        Key.addListener(this);
    }

    function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void {
    }

    function InitExtensions() {
        _root.isLoaded = true;
    }

    function onKeyDown() {
        var code = Key.getCode();

        if (code === 38) { // Up
            Scrollbar_mc.position -= ScrollSpeed;
        } else if (code === 40) { // Down
            Scrollbar_mc.position += ScrollSpeed;
        } else if (code === 13 || code === 9) { // Enter or Tab
            closeMenu();
        }
    }

    function setupMouseListener() {
        var mouseListener = new Object();
        var _this = this;
        mouseListener.onMouseWheel = function( delta ) {
            _this.onMouseWheelCallback( delta );
        }
        Mouse.addListener(mouseListener);
    }

    function onMouseWheelCallback( delta:Number ) {
        if ( Scrollbar_mc._visible && Mask_mc.hitTest(_root._xmouse, _root._ymouse) ) {
            delta *= ScrollSpeed;
            ItemsContainer_mc._y = ShazdehUtils.clampValue( ItemsContainer_mc._y + delta, maxScroll * -1, 0 );
            Scrollbar_mc.position = ItemsContainer_mc._y * -1;
        }
    }

    function setupScrollbar() {
        var scrollEnabled = ItemsContainer_mc._height > Mask_mc._height;
        if ( scrollEnabled ) {
            Scrollbar_mc.upArrow._visible = false;
            Scrollbar_mc.downArrow._visible = false;
            Scrollbar_mc.addEventListener("scroll", this, "onScroll");
            Scrollbar_mc.position = 0;
            Scrollbar_mc.height = Mask_mc._height;
            maxScroll = (ItemsContainer_mc._height - Mask_mc._height) + 0;
            Scrollbar_mc.trackScrollPageSize = maxScroll / 10;
            Scrollbar_mc.pageScrollSize = maxScroll / 10;
            Scrollbar_mc.setScrollProperties( maxScroll / 3, 0, maxScroll );
        } else {
            Scrollbar_mc._visible = false;
        }
    }

    function onScroll(event: Object) {
        ItemsContainer_mc._y = event.position * -1;
    }

    function closeMenu() {
        skse.SendModEvent('B612_Leaderboard_Close');
    }

    function updateButtons() {
        OkBtn_mc.setData(sButtonText);
        OkBtn_mc.addEventListener("press", OkBtn_clickCallback);
    }

    function OkBtn_clickCallback() {
        _parent.closeMenu();
    }

    function getClipIndex(index:Number) {
        return ItemsContainer_mc['item_' + index];
    }

    // @api
    function addItem(name:String, score:String) {
        data.push( {
            name : name,
            score : score
        } );
    }

    // @api
    function loadJSON(json:String) {
        var config:Object = JSON.parse(json);
        for (var i = 0; i < config.length; i++) {
            addItem(config[i].name, config[i].score);
        }
    }

    // @api
    function setHeader(title:String) {
        Header_tf.SetText(title);
    }

    // @api
    function render() {
        /* positioning is done before rendering the items */
        ShazdehUtils.setScaleAndPosition(this);

        var y = 0;
        for (var i = 0; i < data.length; i++) {
            var mc = ItemsContainer_mc.attachMovie('ListItem', 'item_' + i, ItemsContainer_mc.getNextHighestDepth());
            mc.index = i;
            mc.setData(data[i]);
            mc.tabEnabled = false;
            mc.tabChildren = false;
            mc._y = y;
            y += mc._height + itemMargin;
        }

        setupScrollbar();
        setupMouseListener();
        updateButtons();
        _visible = true;
    }
}