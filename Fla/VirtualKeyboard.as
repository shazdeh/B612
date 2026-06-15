import gfx.events.EventDispatcher;
import Shared.GlobalFunc;
import ShazdehUtils;
import Selection;
import skse;
import flash.geom.Rectangle;

class VirtualKeyboard extends MovieClip {

    public static var instance;

    /* ref */
    public var Carrot_mc:MovieClip;
    public var attachedInput:TextField;

    public var dispatchEvent: Function;

    private var keys:Array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 28, 30, 31, 32, 33, 34, 35, 36, 37, 38, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 57, 58, 200, 203, 205, 208];
    private var bIsCapsLockOn:Boolean = true;
    private var bFirstHit:Boolean = true;
    private var carrotIndex:Number;

    /* textbox stats */
    private var alignment:String;
    private var lineHeight:Number;

    function VirtualKeyboard() {
        super();
        _visible = false;
        EventDispatcher.initialize(this);
        Shared.GlobalFunc.MaintainTextFormat();
    }

    function onLoad() {
        updateLabels();
    }

    function attachToInput(tf:TextField) {
        if ( ! tf ) {
            return;
        }
        tf.noAutoSelection = true; /* autoSelection messes us up! */
        VirtualKeyboard.instance = this;
        attachedInput = tf;
        alignment = attachedInput.getTextFormat().align;

        var lineMetrics = attachedInput.getLineMetrics(0);
        Carrot_mc.gotoAndStop('visible');
        Carrot_mc._height = lineHeight = lineMetrics.height;
    }

    function show() {
        Selection["modalClip"] = this;
        _visible = true;
        setFocusTo(16); // q
        Key.addListener(this);
        carrotIndex = attachedInput.text.length;
        updateCarrotPosition();
    }

    function hide() {
        Selection["modalClip"] = null;
        _visible = false;
        Key.removeListener(this);
        Carrot_mc.gotoAndStop(1);
        Carrot_mc._visible = false;
    }

    function updateCarrotPosition() {
        var pos = getAbsolutePosition(attachedInput);
        var charBoundary:Rectangle = attachedInput.getExactCharBoundaries(carrotIndex === 0 ? 0 : carrotIndex - 1);
        if ( carrotIndex !== 0 ) {
            pos.x += charBoundary.x + charBoundary.width;
            pos.y += charBoundary.y;
        }

        /* getExactCharBoundaries() does not give correct x & y with centered or right-aligned text,
         * this is a hack and doesn't line up the carrot properly
         */
        if ( alignment === 'center' || alignment === 'right' ) {
            var offset = 0,
                lineIndex:Number = attachedInput.getLineIndexAtPoint(charBoundary.x, charBoundary.y),
                lineMetrics = attachedInput.getLineMetrics(lineIndex);
            if ( alignment === 'center' ) {
                offset = (attachedInput._width - lineMetrics.width) / 2;
            } else {
                offset = attachedInput._width - lineMetrics.width;
            }
            pos.x += offset;
        }

        globalToLocal(pos);

        Carrot_mc.play();
        Carrot_mc._x = pos.x;
        Carrot_mc._y = pos.y;
        Carrot_mc._visible = true;
    }

    function updateLabels() {
        var capslockPrefix:String = bIsCapsLockOn ? 'ON_' : '';
        for ( var i = 0; i < keys.length; i++ ) {
            var keycode = keys[i],
                label:String = '$B612_KEY_' + capslockPrefix + keycode;

            getClip(keys[i]).setData(keys[i], label);
        }
    }

    function getClip(index:Number) : MovieClip {
        return this['key_' + index];
    }

    function setFocusTo(index:Number) {
        Selection.setFocus(getClip(index));
    }

    function onKeyDown() {
        if ( Key.getCode() === 9 ) {
            setFocusTo(1); // close
        } else if ( Key.getCode() === 13 ) {
            var f:String = Selection.getFocus();
            if (f) {
                var targetKey:Object = eval(f);
                if (targetKey && typeof targetKey.onRelease == "function") {
                    targetKey.onRelease();
                }
            }
        }
    }

    function tapKey(keycode:Number) {
        if (
            keycode === 1 // close
            || (keycode === 28 && attachedInput.multiline === false) // for single-line inputs, Enter also closes
        ) {
            hide();
            dispatchEvent({type: "VirtualKeyboardClose"});
        } else if ( keycode === 14 ) {
            clearChar();
        } else if ( keycode === 57 ) {
            insertText(" ");
        } else if ( keycode === 28 ) {
            /* an extra space is added after line break, necessary to get proper line with getCharBoundaries() */
            insertText("\n ");
        } else if ( keycode === 203 ) { // left
            if ( carrotIndex > 0 ) {
                carrotIndex--;
                updateCarrotPosition();
            }
        } else if ( keycode === 205 ) { // right
            if ( carrotIndex < attachedInput.text.length ) {
                carrotIndex++;
                updateCarrotPosition();
            }
        } else if ( keycode === 200 || keycode === 208 ) { // up & down
            if ( attachedInput.multiline ) {
                var charBoundary:Rectangle = attachedInput.getCharBoundaries(carrotIndex - 1),
                    lineIndex:Number = attachedInput.getLineIndexAtPoint(charBoundary.x, charBoundary.y),
                    firstChar = attachedInput.getLineOffset(keycode === 208 ? lineIndex + 1 : lineIndex - 1);
                if ( firstChar !== -1 ) {
                    carrotIndex = firstChar + 1;
                    updateCarrotPosition();
                }
            }
        } else if ( keycode === 58 ) { // CAPSLOCK
            toggleCapsLock();
        } else {
            var char = eval(Selection.getFocus()).Label_tf.text;
            insertText(char);
            if ( bFirstHit ) {
                bFirstHit = false;
                toggleCapsLock();
            }
        }
    }

    function toggleCapsLock() {
        bIsCapsLockOn = ! bIsCapsLockOn;
        updateLabels();
    }

    function moveFocus(key:String) {
        var f:String = Selection.getFocus();
        if (f) {
            var targetKey:Object = eval(f);
            var mc = Selection.findFocus(key, this, true, targetKey);
            if (mc) {
                Selection.setFocus(mc);
            }
        }
    }

    function getAbsolutePosition(targetObject:Object) : Object {
        var points = {
            x : targetObject._x,
            y : targetObject._y
        };
        targetObject._parent.localToGlobal(points);

        return points;
    }

    function insertText(newText:String) {
        var text = attachedInput.text;
        text = text.substr(0, carrotIndex) + newText + text.substr(carrotIndex);
        attachedInput.SetText(text);
        carrotIndex += newText.length;
        updateCarrotPosition();
    }

    function clearChar() {
        var text = attachedInput.text;
        text = text.substr(0, carrotIndex - 1) + text.substr(carrotIndex);
        attachedInput.SetText(text);
        if ( carrotIndex > 0 ) {
            carrotIndex--;
        }
        updateCarrotPosition();
    }
}