import skse;
import Shared.GlobalFunc;
import ShazdehUtils;

class Hud Overlay extends MovieClip {

    /* refs */
    public var HUD:MovieClip;
    public var Label_tf:MovieClip;

    function Hud Overlay() {
        _alpha = 0;
    }

	function onLoad() {
        HUD = _parent._parent;
        GlobalFunc.SetLockFunction();
        MovieClip(this).Lock("TL");
        Label_tf.autoSize = 'center';
    }

    function startIt() {
        ShazdehUtils.fadeMC(this, 100, 1);
    }

    function endIt() {
        ShazdehUtils.fadeMC(this, 0, 1);
    }

    function setText(a_text:String) {
        Label_tf.SetText(a_text, true);
    }
}