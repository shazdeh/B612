import gfx.io.GameDelegate;
import gfx.events.EventDispatcher;
import gfx.controls.Button;
import skse;
import Selection;
import Shared.GlobalFunc;
import ShazdehUtils;

class TextBox extends MovieClip {

    public static var instance;

    static var WIDTH_MARGIN: Number = 20;
    static var HEIGHT_MARGIN: Number = 30;
    static var MESSAGE_TO_BUTTON_SPACER: Number = 10;

    /* Stage Elements */
    var TextboxContainer_mc: MovieClip;
    var InputText_tf: TextField;
    var Background_mc: MovieClip;
    var Divider_mc: MovieClip;
    var CloseBtn_mc: TextButton;
    var VK_mc: MovieClip;

    private var bIsConsole:Boolean = false;

    function TextBox() {
        super();
        _visible = false;
        TextBox.instance = this;
        InputText_tf = TextboxContainer_mc.InputText_tf;
        InputText_tf.noTranslate = true;
        Selection["disableFocusKeys"] = true;
        Shared.GlobalFunc.MaintainTextFormat();
    }

    function onLoad() {
        CloseBtn_mc.addEventListener('press', ClickCallback);
        VK_mc.addEventListener('VirtualKeyboardClose', VKCloseCallback);
        InputText_tf.onSetFocus = onInputFocus;
    }
    
    function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void {
        bIsConsole = aiPlatform != 0;
    }

    function InitExtensions() {
    }

    function ClickCallback(aEvent: Object): Void {
        TextBox.instance.closeMenu();
    }

    function VKCloseCallback(aEvent: Object): Void {
        this.onEnterFrame = function() {
            TextBox.instance.TextboxContainer_mc.Background_mc._alpha = 30;
            Selection.setFocus(TextBox.instance.CloseBtn_mc);
            onEnterFrame = null;
        }
    }

    function onInputFocus(oldFocus:Object) {
        this = TextBox.instance;
        if ( bIsConsole && VK_mc._visible === false ) {
            VK_mc.attachToInput(InputText_tf);
            VK_mc.show();
            TextboxContainer_mc.Background_mc._alpha = 70;
        }
    }

    function closeMenu() {
        skse.AllowTextInput(false);
        skse.SendModEvent('b612_Textbox_Close', InputText_tf.text);
    }

    function adjustPositions() {
        InputText_tf._x = InputText_tf._width / -2;
        InputText_tf._y = InputText_tf._height / -2;
        TextboxContainer_mc.Background_mc._width = InputText_tf._width;
        TextboxContainer_mc.Background_mc._height = InputText_tf._height;
        Background_mc._width = InputText_tf._width + (TextBox.WIDTH_MARGIN * 2);
        Background_mc._height = InputText_tf._height + (TextBox.HEIGHT_MARGIN * 2) + CloseBtn_mc._height;
        Divider_mc._width = Background_mc._width - TextBox.WIDTH_MARGIN * 2;
        Divider_mc._y = TextboxContainer_mc._y + (TextboxContainer_mc._height / 2) + TextBox.MESSAGE_TO_BUTTON_SPACER;
        CloseBtn_mc._y = Divider_mc._y + (CloseBtn_mc._height / 2);
        CloseBtn_mc._x = Background_mc._x - (CloseBtn_mc.totalWidth / 2);
        VK_mc._x = InputText_tf._x;
        VK_mc._y = InputText_tf._y + InputText_tf._height;
    }

    function enableInput() {
        InputText_tf.type = 'input';
        InputText_tf.selectable = true;
        Selection.setFocus(InputText_tf);
        skse.AllowTextInput(true);
    }

    // @api
    function SetOptions(aDefaultText: String, aButtonLabel:String, aWidth:String, aHeight:String): Void {
        InputText_tf.SetText(aDefaultText);
        CloseBtn_mc.setData(aButtonLabel);

        InputText_tf._width = parseInt(aWidth);
        InputText_tf._height = parseInt(aHeight);
        adjustPositions();

        if (_global.skse) {
            ShazdehUtils.setScaleAndPosition(this);
        }

        enableInput();

        _visible = true;
    }
}