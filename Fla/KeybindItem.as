class KeybindItem extends MovieClip {

    /* ref */
    public var Hover_mc:MovieClip;
    public var Label_tf:TextField;
    public var KeyboardContainer_mc:MovieClip;
    public var GamepadContainer_mc:MovieClip;

    /*config */
    public var padding:Number = 3;

    function onLoad() {
        Hover_mc._visible = false;
    }

    function setData(a_label:String, a_keyboardKeys:String, a_gamepadKeys:String) {
        Label_tf.SetText(a_label);
        if ( a_keyboardKeys !== '' ) {
            var keyboardKeys:Array = a_keyboardKeys.split('+');
            var x = 0;
            for ( var i = 0; i < keyboardKeys.length; i++ ) {
                var mc:MovieClip = KeyboardContainer_mc.attachMovie('ButtonArt', 'btn_' + i, KeyboardContainer_mc.getNextHighestDepth());
                mc.gotoAndStop(parseInt(keyboardKeys[i]));
                mc._x = x;
                x += mc._width + padding;
            }
        }

        if ( a_gamepadKeys !== '' ) {
            var gamepadKeys:Array = a_gamepadKeys.split('+');
            x = 0;
            for ( var i = 0; i < gamepadKeys.length; i++ ) {
                var mc:MovieClip = GamepadContainer_mc.attachMovie('ButtonArt', 'btn_' + i, GamepadContainer_mc.getNextHighestDepth());
                mc.gotoAndStop(parseInt(gamepadKeys[i]));
                mc._x = x;
                x += mc._width + padding;
            }
        }
    }

    function onRollOver() {
        Hover_mc._visible = true;
    }

    function onRollOut() {
        Hover_mc._visible = false;
    }
}