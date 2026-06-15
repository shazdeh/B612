import skse;
import Selection;
import Shared.GlobalFunc;
import JSON;
import ShazdehUtils;

class Keybinds extends MovieClip {

    public static var instance;

    /* ref */
    public var Background_mc:MovieClip;
    public var ListContainer_mc:MovieClip;
    public var List_mc:MovieClip;
    public var ItemsContainer_mc:MovieClip;
    public var Hotkey_mc:MovieClip;
    public var Scrollbar_mc:MovieClip;
    public var Mask_mc:MovieClip;

    private var data:Object;
    private var bLoading:Boolean = false;
    private var ScrollSpeed:Number = 20;
    private var maxScroll:Number;

    function onLoad() {
        Keybinds.instance = this;
        Selection["alwaysEnableArrowKeys"] = false;
        Selection["disableFocusKeys"] = true;
        _focusrect = false;
        Shared.GlobalFunc.MaintainTextFormat();
        Shared.GlobalFunc.SetLockFunction();
        _visible = Hotkey_mc._visible = Scrollbar_mc._visible = false;
        Key.addListener(this);
        setupMouseListener();
        List_mc = ListContainer_mc.List_mc;
        ItemsContainer_mc = List_mc.ItemsContainer_mc;
    }

    function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void {
    }

    function InitExtensions() {
        _root.isLoaded = true;
    }

    function onKeyDown() {
        if ( Key.getCode() === 9 ) {
            closeMenu();
        } else if ( Key.getCode() === 38 ) { // up
            onMouseWheelCallback(2);
        } else if ( Key.getCode() === 40 ) { // down
            onMouseWheelCallback(-2);
        }
    }

    function render() {
        var y = 0;
        for ( var i = 0; i < data.sections.length; i++ ) {
            var sectionTitleMC:MovieClip = ItemsContainer_mc.attachMovie('SectionTitle', 'item_' + i, ItemsContainer_mc.getNextHighestDepth());
            sectionTitleMC.Label_tf.SetText(data.sections[i].name);
            sectionTitleMC._y = y;
            y += sectionTitleMC._height;
            var keys = data.sections[i].keybinds;
            for ( var j = 0; j < keys.length; j++ ) {
                var mc:MovieClip = ItemsContainer_mc.attachMovie('Item', 'item_' + i + '_' + j, ItemsContainer_mc.getNextHighestDepth());
                mc.setData(keys[j][0], keys[j][1], keys[j][2]);
                mc._y = y;
                y += mc._height;
            }
        }
        setupScrollbar();
        _visible = true;
    }

    function setupMouseListener() {
        var mouseListener = new Object();
        mouseListener.onMouseWheel = onMouseWheelCallback;
        Mouse.addListener(mouseListener);
    }

    function onMouseWheelCallback( delta:Number ) {
        this = Keybinds.instance;
        if ( Scrollbar_mc._visible ) {
            delta *= ScrollSpeed;
            List_mc._y = ShazdehUtils.clampValue( List_mc._y + delta, maxScroll * -1, 0 );
            Scrollbar_mc.position = List_mc._y * -1;
        }
    }

    function setupScrollbar() {
        var scrollEnabled = List_mc._height > Mask_mc._height;
        if ( scrollEnabled ) {
            Scrollbar_mc._visible = true;
            Scrollbar_mc.upArrow._visible = false;
            Scrollbar_mc.downArrow._visible = false;
            Scrollbar_mc.addEventListener("scroll", this, "onScroll");
            Scrollbar_mc.position = 0;
            Scrollbar_mc.height = Mask_mc._height;
            maxScroll = (List_mc._height - Mask_mc._height) + 20;
            Scrollbar_mc.trackScrollPageSize = maxScroll / 10;
            Scrollbar_mc.pageScrollSize = maxScroll / 10;
            Scrollbar_mc.setScrollProperties( maxScroll / 3, 0, maxScroll );
        } else {
            Scrollbar_mc._visible = false;
        }
    }

    function onScroll(event: Object) {
        List_mc._y = event.position * -1;
    }

    function closeMenu() {
        skse.CloseMenu('CustomMenu');
    }

    function onDataLoad(theData:String) {
        this = Keybinds.instance;
        if ( theData !== undefined && theData !== '' ) {
            data = JSON.parse(theData);
            if (_global.skse) {
                ShazdehUtils.setScaleAndPosition(this);
            }
            render();
        }
    }

    // @api
    function setConfig(filePath:String) {
        if ( bLoading ) {
            return;
        }
        bLoading = true;
        var fetcher:LoadVars = new LoadVars();
        fetcher.onData = onDataLoad;
        fetcher.load(filePath);
    }
}