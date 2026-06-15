import skse;
import gfx.managers.FocusHandler;
import gfx.io.GameDelegate;
import gfx.ui.NavigationCode;

class QuantitySlider extends MovieClip {

	/* stage elements */
    var ButtonRect: MovieClip;
	var QuantitySlider_mc: MovieClip;
	var QuantityText: TextField;
	var Heading_tf: TextField;

    /* state vars */
	var bDisableControls: Boolean;

	function QuantitySlider() {
		super();
		bDisableControls = false;
        _visible = false;
	}

	function InitExtensions(): Void {
        Mouse.addListener(this);
		FocusHandler.instance.setFocus(QuantitySlider_mc, 0);
		QuantitySlider_mc.addEventListener("change", this, "sliderChange");
		QuantitySlider_mc.scrollWheel = function () {
		};
		ButtonRect.AcceptMouseButton.addEventListener("click", this, "onOKPress");
		ButtonRect.CancelMouseButton.addEventListener("click", this, "onCancelPress");
		ButtonRect.AcceptMouseButton.SetPlatform(0, false);
		ButtonRect.CancelMouseButton.SetPlatform(0, false);
	}

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean {
		var handledInput: Boolean = false;
		if (!disableControls && pathToFocus != undefined && pathToFocus.length > 0) {
			handledInput = pathToFocus[0].handleInput(details, pathToFocus.slice(1));
		}
		if (!handledInput && Shared.GlobalFunc.IsKeyPressed(details)) {
			switch(details.navEquivalent) {
				case NavigationCode.TAB:
					onCancelPress();
					break;
				case NavigationCode.ENTER:
					onOKPress();
					break;
				case NavigationCode.PAGE_UP:
				case NavigationCode.GAMEPAD_R1:
					if (!disableControls) {
						modifySliderValue(4);
					}
					break;
				case NavigationCode.PAGE_DOWN:
				case NavigationCode.GAMEPAD_L1:
					if (!disableControls) {
						modifySliderValue(-4);
					}
					break;
			}
		}
		return true;
	}

	function get disableControls(): Boolean {
		return bDisableControls;
	}

	function set disableControls(abFlag: Boolean): Void {
		bDisableControls = abFlag;
		if (abFlag) {
			QuantitySlider_mc.thumb.disabled = true;
			QuantitySlider_mc.track.disabled = true;
			ButtonRect.AcceptMouseButton.disabled = true;
		}
	}

	function modifySliderValue(aiDelta: Number): Void {
		QuantitySlider_mc.value = QuantitySlider_mc.value + aiDelta;
		sliderChange();
	}

	function onMouseWheel(aiWheelVal: Number): Void {
		if (disableControls) {
			return;
		}
		QuantitySlider_mc.value = QuantitySlider_mc.value + aiWheelVal;
		sliderChange();
	}

	function getSliderValue(): Number {
		return Math.floor(QuantitySlider_mc.value);
	}

	function sliderChange(event: Object): Void {
		QuantityText.text = Math.floor(QuantitySlider_mc.value).toString();
	}

	function onOKPress(event: Object): Void {
		if (disableControls) {
			return;
		}
		disableControls = true;
		skse.SendModEvent( 'b612_QuantitySlider_Select', '', getSliderValue() );
	}

	function onCancelPress(event: Object): Void {
		skse.SendModEvent( 'b612_QuantitySlider_Select', '', -1 );
	}

	function SetPlatform(aiPlatformIndex: Number, abPS3Switch: Boolean): Void {
		ButtonRect.AcceptGamepadButton._visible = aiPlatformIndex != 0;
		ButtonRect.CancelGamepadButton._visible = aiPlatformIndex != 0;
		ButtonRect.AcceptMouseButton._visible = aiPlatformIndex == 0;
		ButtonRect.CancelMouseButton._visible = aiPlatformIndex == 0;
		if (aiPlatformIndex != 0) {
			ButtonRect.AcceptGamepadButton.SetPlatform(aiPlatformIndex, abPS3Switch);
			ButtonRect.CancelGamepadButton.SetPlatform(aiPlatformIndex, abPS3Switch);
		}
	}

    // @api
    function setTitle(title:String) {
        Heading_tf.SetText( title );
    }

    // @api
    function setConfirmText(text:String) {
        ButtonRect.AcceptMouseButton.labelID = text;
        ButtonRect.AcceptGamepadButton.labelID = text;
    }

    // @api
    function setCancelText(text:String) {
        ButtonRect.CancelMouseButton.labelID = text;
        ButtonRect.CancelGamepadButton.labelID = text;
    }

    // @api
    function setMinValue(value:Number) {
        QuantitySlider_mc.minimum = value;
    }

    // @api
    function setMaxValue(value:Number) {
        QuantitySlider_mc.maximum = value;
        QuantitySlider_mc.value = value;
        sliderChange();
        _visible = true;
    }
}
