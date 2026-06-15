import Shared.GlobalFunc;

class Spinicon extends MovieClip {

    public var Loader_mc:MovieClip;
    public var Label_tf:TextField;

    /* config */
    public var loaderMargin:Number = 20;

    function onLoad() {
        Hide();
        Shared.GlobalFunc.MaintainTextFormat();
        Label_tf = Loader_mc.Label_tf;
        var root_mc = _parent._parent;
        Loader_mc._x = root_mc.BottomRightLockInstance._x - ( Loader_mc._width + loaderMargin );
        Loader_mc._y = root_mc.BottomRightLockInstance._y - ( Loader_mc._height + loaderMargin );
    }

    function Show(a_text:String) {
        Label_tf.SetText(a_text, true);
        Loader_mc._visible = true;
    }

    function Hide() {
        Loader_mc._visible = false;
    }
}