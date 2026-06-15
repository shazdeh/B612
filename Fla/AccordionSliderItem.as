class AccordionSliderItem extends MovieClip {

    /* ref */
    public var ImagePlaceholder_mc:MovieClip;
    public var Overlay_mc:MovieClip;
    public var Mask_mc:MovieClip;
    public var TitleContainer_mc:MovieClip;
    public var Details_mc:MovieClip;
    private var Menu_mc:MovieClip; // root

    public var imagePath:String;
    public var title:String;
    public var description:String;
    public var index:Number;
    public var isExpanded:Boolean;

    /* config */
    public var sidePadding:Number = 0;

    function onLoad() {
        isExpanded = false;
        _focusrect = false;
        TitleContainer_mc._visible = false;
    }

    function setData(a_imagePath:String, a_title:String, a_desc:String, a_Menu_mc:MovieClip) {
        imagePath = a_imagePath;
        title = a_title;
        description = a_desc;
        Menu_mc = a_Menu_mc;
        ImagePlaceholder_mc.loadMovie(imagePath);
        ImagePlaceholder_mc._xscale = 70;
        ImagePlaceholder_mc._yscale = 70;

        // setup vertical title text
        var _this = this;
        TitleContainer_mc.loadMovie('TextLoader.swf');
        setTimeout( function() {
            _this.TitleContainer_mc.CardName_tf.SetText(_this.title);
            _this.TitleContainer_mc._rotation = 90;
        }, 1000 );

        Details_mc.Title_tf.SetText(title);
        Details_mc.Desc_tf.SetText(description);
    }

    function onSetFocus() {
        Overlay_mc._visible = false;
    }

    function onKillFocus() {
        if ( ! isExpanded ) {
            Overlay_mc._visible = true;
        }
    }

    function onRelease() {
        Menu_mc.expand(this.index);
    }

    function setIndex(a_index:Number) {
        index = a_index;
        Mask_mc._width = Menu_mc.itemWidth;
        Mask_mc._x = index * Menu_mc.itemWidth;
        TitleContainer_mc._x += index * Menu_mc.itemWidth;
    }

    function expand() {
        isExpanded = true;
        Details_mc._alpha = 100;
        TitleContainer_mc._visible = false;
        swapDepths(_parent.getNextHighestDepth());
        Mask_mc._x = 0;
        Mask_mc._width = Stage.width;
        Selection.setFocus(this);
    }

    function deflate() {
        isExpanded = false;
        Details_mc._alpha = 0;
        Mask_mc._width = Menu_mc.itemWidth;
        Mask_mc._x = index * Menu_mc.itemWidth;
        TitleContainer_mc._visible = true;
    }
}