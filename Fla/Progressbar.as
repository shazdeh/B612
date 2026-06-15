import skse;

class Progressbar extends MovieClip {

	/* stage elements */
    var Background_mc: MovieClip;
    var Track_mc: MovieClip;
	var Heading_tf: TextField;
    var CloseBtn_mc: MovieClip;

    /* config */
	var bCanClose: Boolean = false;

    /* state */
    var currentPercent:Number = 0;

	function Progressbar() {
		super();
        Key.addListener(this);
	}

	function InitExtensions(): Void {
	}

	function SetPlatform(aiPlatformIndex: Number, abPS3Switch: Boolean): Void {
	}

    function onKeyDown() {
        if ( Key.getCode() === 9 ) {
            if ( bCanClose ) {
                closeMenu();
            }
        }
    }

    function closeMenu() {
        skse.CloseMenu("CustomMenu");
    }

    // @api
    function setCanClose(a_canClose:Boolean) {
        bCanClose = a_canClose;
        CloseBtn_mc._visible = bCanClose;
    }

    // @api
    function setCloseButtonData(a_text:String, a_keycode:Number) {
        CloseBtn_mc.bEnableSelectionIndicator = false;
        CloseBtn_mc.setData(a_text, a_keycode);
        CloseBtn_mc._x = Background_mc._x - (CloseBtn_mc.totalWidth / 2);
    }

    function update(a_percent:Number, a_headingText:String) {
        currentPercent = a_percent;
        if ( currentPercent < 0 ) {
            currentPercent = 0;
        } else if ( currentPercent > 100 ) {
            currentPercent = 100;
        }
        Track_mc.gotoAndStop(currentPercent + 1);
        Heading_tf.SetText(a_headingText);
        Track_mc.Counter_mc.Counter_tf.SetText(currentPercent + '%', false);
    }
}
