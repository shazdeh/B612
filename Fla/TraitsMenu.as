import skse;
import ShazdehUtils;
import Shared.GlobalFunc;
import gfx.controls.Button;
import gfx.io.GameDelegate;

class TraitsMenu extends MovieClip {

    /* stage */
    public var Background_mc:MovieClip;
    public var ItemPic_mc:MovieClip;
    public var ItemsContainerWrap_mc:MovieClip;
    public var ItemsContainer_mc:MovieClip;
    public var TraitsMask_mc:MovieClip;
    public var ItemText_tf:TextField;
    public var OkBtn_mc:MovieClip;
    public var RandomBtn_mc:MovieClip;
    public var Scrollbar_mc:MovieClip;
    public var StatusText_tf:TextField;
    public var TextScrollbar_mc:MovieClip;
    public var ItemTextHit_mc:MovieClip;

    /* config */
    private var iMinSelection:Number = 0;
    private var iMaxSelection:Number = 1;
    private var sButtonText:String = '$B612_CONFIRM';
    private var sCounterText:String = '$B612_TRAITSCOUNTER';
    private var sRandomButtonText:String = '$B612_RANDOM';

    /* internal */
    private var data:Array;
    private var selections:Array;
    private var ScrollSpeed:Number = 20;
    private var maxScroll:Number;
    private var selectionIndicatorWidth:Number = 25;
    private var iFocusIndex:Number = -1;
    private var currentFocus:MovieClip = null;
    private var lastFocusItem:MovieClip;

    function onLoad() {
        Selection["alwaysEnableArrowKeys"] = false;
        _visible = false;
        TextScrollbar_mc._visible = false;
        Shared.GlobalFunc.MaintainTextFormat();
        ItemsContainer_mc = ItemsContainerWrap_mc.ItemsContainer_mc;
        data = [];
        selections = [];
        Key.addListener(this);
    }

    function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void {
    }

    function InitExtensions() {
        _root.isLoaded = true;
    }

    function clearUnfocusedItem( newItem:MovieClip ) {
        if ( lastFocusItem ) {
            lastFocusItem.onKillFocus();
        }
        lastFocusItem = newItem;
    }

    function setFocusToItemIndex(index:Number) {
        var mc = getClipIndex(iFocusIndex);
        if ( mc ) {
            Selection.setFocus( mc );
            Scrollbar_mc.position = ( mc._y );
            currentFocus = null;
        }
    }

    function onKeyDown() {
        if ( Key.getCode() === 9 ) {
            closeMenu(true);
        } else if ( Key.getCode() === 38 ) { // up
            if ( ( currentFocus !== OkBtn_mc && currentFocus !== RandomBtn_mc ) && iFocusIndex > 0 ) {
                setFocusToItemIndex(--iFocusIndex);
            }
        } else if ( Key.getCode() === 40 ) { // down
            if ( ( currentFocus !== OkBtn_mc && currentFocus !== RandomBtn_mc ) && iFocusIndex < data.length - 1 ) {
                setFocusToItemIndex(++iFocusIndex);
            }
        } else if ( Key.getCode() === 37 ) { // left
            if ( currentFocus === OkBtn_mc ) {
                Selection.setFocus(RandomBtn_mc)
                currentFocus = RandomBtn_mc;
            } else if ( currentFocus === RandomBtn_mc ) {
                if ( iFocusIndex === -1 ) {
                    iFocusIndex = 0;
                }
                setFocusToItemIndex(iFocusIndex);
            }
        } else if ( Key.getCode() === 39 ) { // right
            if ( currentFocus === null ) {
                Selection.setFocus(RandomBtn_mc);
                currentFocus = RandomBtn_mc;
            } else if ( currentFocus === RandomBtn_mc ) {
                Selection.setFocus(OkBtn_mc);
                currentFocus = OkBtn_mc;
            }
        } else if ( Key.getCode() === 13 ) { // Activate
            if ( currentFocus === OkBtn_mc ) {
                this.closeMenu();
            } else if ( currentFocus === RandomBtn_mc ) {
                this.chooseRandom();
            } else {
                var mc = getClipIndex(iFocusIndex);
                if ( mc ) {
                    onPickItem( mc.index );
                }
            }
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
        if ( Scrollbar_mc._visible && TraitsMask_mc.hitTest(_root._xmouse, _root._ymouse) ) {
            delta *= ScrollSpeed;
            ItemsContainer_mc._y = ShazdehUtils.clampValue( ItemsContainer_mc._y + delta, maxScroll * -1, 0 );
            Scrollbar_mc.position = ItemsContainer_mc._y * -1;
        } else if ( ItemTextHit_mc._visible && ItemTextHit_mc.hitTest(_root._xmouse, _root._ymouse) ) {
            TextScrollbar_mc.scrollWheel(delta);
        }
    }

    function setupScrollbar() {
        var scrollEnabled = ItemsContainer_mc._height > TraitsMask_mc._height;
        if ( scrollEnabled ) {
            Scrollbar_mc.upArrow._visible = false;
            Scrollbar_mc.downArrow._visible = false;
            Scrollbar_mc.addEventListener("scroll", this, "onScroll");
            Scrollbar_mc.position = 0;
            Scrollbar_mc.height = TraitsMask_mc._height;
            maxScroll = (ItemsContainer_mc._height - TraitsMask_mc._height) + 0;
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

    function closeMenu(bForceClose:Boolean) {
        if ( selections.length >= iMinSelection ) {
            var sentData = selections.join( ',' );
            if ( bForceClose && iMinSelection === 0 ) {
                /* pressing Tab equates to "canceling" selections,
                 * unless the player is required to select iMinSelection items */
                sentData = '';
            }
            skse.SendModEvent( 'b612_TraitsMenu_Close', sentData );
        }
    }

    function onPickItem(index:Number) {
        var foundIndex = ShazdehUtils.array_search( index, selections );
        if ( foundIndex !== -1 ) {
            selections.splice( foundIndex, 1 );
            getClipIndex(index).unselect();
        } else {
            if ( selections.length >= iMaxSelection ) {
                var lastSelected = selections.pop();
                getClipIndex(lastSelected).unselect();
            }
            selections.push( index );
            getClipIndex(index).select();
        }
        updateCounter();
    }

    function updateCounter() {
        var counterText = ShazdehUtils.get_i18n( sCounterText );
        counterText = ShazdehUtils.str_replace( '<count>', selections.length, counterText );
        counterText = ShazdehUtils.str_replace( '<max>', iMaxSelection, counterText );
        counterText = ShazdehUtils.str_replace( '<min>', iMinSelection, counterText );
        StatusText_tf.SetText(counterText);

        if ( selections.length < iMinSelection ) {
            OkBtn_mc.gotoAndStop('disabled');
        } else {
            OkBtn_mc.gotoAndStop('up');
        }
    }

    function updateDetails(index:Number) {
        if ( data[index].description.substr(-4) === '.txt' ) {
            var filePath = data[index].description;
            data[index].description = '';
            ItemText_tf.text = '';
            this.loadData(filePath, index);
        } else {
            ItemText_tf.SetText(data[index].description, true);
        }

        if ( ItemText_tf.maxscroll > 1 ) {
            TextScrollbar_mc.scrollTarget = ItemText_tf;
            TextScrollbar_mc._visible = true;
        } else {
            TextScrollbar_mc._visible = false;
        }

        if ( ItemPic_mc.activeIndex !== undefined && ItemPic_mc.activeIndex !== index ) {
            ItemPic_mc['item_' + ItemPic_mc.activeIndex]._visible = false;
        }
        if ( ! ItemPic_mc['item_' + index] ) {
            var mc = ItemPic_mc.createEmptyMovieClip('item_' + index, ItemPic_mc.getNextHighestDepth());
            mc.loadMovie( data[index].imagePath );
        }
        ItemPic_mc['item_' + index]._visible = true;
        ItemPic_mc.activeIndex = index;
    }

    function clearDetails() {
        ItemText_tf.text = '';
        TextScrollbar_mc._visible = false;
        ItemPic_mc['item_' + ItemPic_mc.activeIndex]._visible = false;
    }

    function updateButtons() {
        OkBtn_mc.setData(sButtonText);
        OkBtn_mc.addEventListener("press", OkBtn_clickCallback);
        RandomBtn_mc.setData(sRandomButtonText);
        RandomBtn_mc.addEventListener("press", RandomBtn_clickCallback);
    }

    function OkBtn_clickCallback() {
        _parent.closeMenu();
    }

    function RandomBtn_clickCallback() {
        _parent.chooseRandom();
    }

    function chooseRandom() {
        var randomCount = ShazdehUtils.randomNumber(1, iMaxSelection);
        selections = [];
        for ( var i = 0; i < randomCount; i++ ) {
            var pick = ShazdehUtils.randomNumber(0, data.length - 1);
            selections.push( pick );
        }
        closeMenu();
    }

    function getClipIndex(index:Number) {
        return ItemsContainer_mc[ 'item_' + index ];
    }

    function loadData(path:String, a_index:Number) {
		var _this = this;
		var fetcher:LoadVars = new LoadVars();
		fetcher.index = a_index;
        fetcher.onData = function( theData ) {
			if ( theData !== undefined && theData !== '' ) {
                _this.setDataById( theData, fetcher.index );
			}
        }
        fetcher.load( path );
	}

    function setDataById(a_data:String, a_index:Number) {
        if ( data[a_index] ) {
            data[a_index].description = a_data;
            updateDetails(a_index);
        }
    }

    // @api
    function addItem(title:String, description:String, imagePath:String) {
        data.push( {
            title : title,
            description : description,
            imagePath : imagePath
        } );
    }

    // @api
    function setMaxSelection(i:Number) {
        iMaxSelection = i;
    }

    // @api
    function setMinSelection(i:Number) {
        iMinSelection = i;
    }

    // @api
    function setButtonLabel(str:String) {
        sButtonText = str;
    }

    // @api
    function setCounterText(str:String) {
        sCounterText = str;
    }

    // @api
    function setRandomButtonText(str:String) {
        sRandomButtonText = str;
    }

    // @api
    function render() {
        /* positioning is done before rendering the items */
        if (_global.skse) {
            ShazdehUtils.setScaleAndPosition(this);
        }

        var y = 0;
        for ( var i = 0; i < data.length; i++ ) {
            var mc = ItemsContainer_mc.attachMovie('ListItem', 'item_' + i, ItemsContainer_mc.getNextHighestDepth());
            mc.index = i;
            mc.setData(data[i], this);
            mc._y = y;
            y += mc._height;
        }

        setupScrollbar();
        setupMouseListener();
        updateButtons();
        updateCounter();
        _visible = true;
    }
}