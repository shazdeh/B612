class VirtualKeyboard_Key extends MovieClip {

    public var Label_tf:TextField;

    public var keycode:Number;

    function VirtualKeyboard_Key() {
        super();
    }

    function setData(a_keycode:Number, a_label:String) {
        keycode = a_keycode;
        Label_tf.SetText(a_label);
    }

    function onLoad() {
    }

    function onRollOver() {
        Selection.setFocus(this);
    }

    function onSetFocus() {
        gotoAndStop(2);
    }

    function onKillFocus() {
        gotoAndStop(1);
    }

    function onRelease() {
        VirtualKeyboard.instance.tapKey(keycode);
    }
}