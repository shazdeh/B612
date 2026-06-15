import skse;
import Selection;
import Shared.GlobalFunc;

class AccordionSlider extends MovieClip {

    /* ref */
    public var ItemsContainer_mc:MovieClip;
    public var Header_mc:MovieClip;
    public var Title_tf:TextField;

    /* data */
    private var items:Array;
    private var itemWidth:Number;
    private var activeItemIndex:Number = null;
    private var lastColumn:Number = null;

    /* config */

    function onLoad() {
        Selection["alwaysEnableArrowKeys"] = false;
        Selection["disableFocusKeys"] = true;
        _focusrect = false;
        Shared.GlobalFunc.MaintainTextFormat();
        Shared.GlobalFunc.SetLockFunction();
        _visible = false;
        items = [];
        Title_tf = Header_mc.Title_tf;
        Key.addListener(this);
    }

    function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void {
    }

    function InitExtensions() {
        _root.isLoaded = true;
    }

    function setScale() {
        // Default Stage height for 16:9 aspect ratio
        var defaultHeight:Number = 720;

        // Check if the visible height is less than the default
        if (Stage.visibleRect.height < defaultHeight) {
            // Calculate the scaling factor based on height to maintain aspect ratio
            var heightScale:Number = (Stage.visibleRect.height / _height) * 100;

            // Apply the scale to the MovieClip
            // _xscale = heightScale;
            // _yscale = heightScale;
        }
    }

    function onMouseMove() {
        if ( activeItemIndex === null ) {
            var column = Math.floor( this._xmouse / ( Stage.width / items.length ) );
            Selection.setFocus(getClipIndex(column));
        }
    }

    function onKeyDown() {
        if ( Key.getCode() === 9 ) {
            if ( activeItemIndex !== null ) {
                getActiveItem().deflate();
                activeItemIndex = null;
            } else {
                activeItemIndex = -1;
                closeMenu();
            }
        } else if ( Key.getCode() === 37 ) { // left
            
        } else if ( Key.getCode() === 39 ) { // right
            
        } else if ( Key.getCode() === 13 ) { // Activate
            if ( activeItemIndex !== null ) {
                closeMenu();
            }
        }
    }

    function closeMenu() {
        skse.SendModEvent( 'b612_AccordionSlider_Close', activeItemIndex.toString() );
    }

    function getActiveItem() {
        if ( activeItemIndex !== null ) {
            return items[activeItemIndex];
        }
    }

    function getClipIndex(index:Number) {
        return items[index];
    }

    // @api
    function addItem(title:String, description:String, imagePath:String) {
        var mc = ItemsContainer_mc.attachMovie('AccordionSliderItem', 'item_' + items.length, ItemsContainer_mc.getNextHighestDepth());
        mc.setData(imagePath, title, description, this);
        items.push(mc);
    }

    function setTitle(title:String) {
        Title_tf.SetText(title);
    }

    // @api
    function render() {
        /* positioning is done before rendering the items */
        if (_global.skse) {
            // setScale();
            // setPosition();
            // MovieClip(this).Lock("");
        }

        var count = items.length;
        itemWidth = Stage.width / count;
        for ( var i = 0; i < count; i++ ) {
            items[i].setIndex(i);
        }
        _visible = true;
    }

    function expand(index:Number) {
        if ( activeItemIndex !== null ) {
            getActiveItem().deflate();
        }
        items[index].expand();
        activeItemIndex = index;
    }
}