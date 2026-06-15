import skse;
import gfx.io.GameDelegate;
import Components.CrossPlatformButtons;
import Components.Meter;
import Shared.GlobalFunc;

class TrainingMenu extends MovieClip {

    /* stage */
    public var SkillName_tf:TextField;
    public var TrainerSkill_tf:TextField;
    public var TimesTrainedLabel_tf:TextField;
    public var TimesTrained_tf:TextField;
    public var TrainCost_tf:TextField;
    public var CurrentGold_tf:TextField;
    public var SkillMeter_mc:MovieClip;
    public var SkillMeter:Meter;
    public var AcceptButton:CrossPlatformButtons;
    public var ExitButton:CrossPlatformButtons;

    function TrainingMenu() {
        super();
        _visible = false;
        SkillMeter = new Meter(SkillMeter_mc);
        SkillMeter.SetPercent(0);
        SkillMeter.SetFillSpeed(4);
        SkillMeter.SetEmptySpeed(100);
        Key.addListener(this);
        Shared.GlobalFunc.MaintainTextFormat();
    }

    function onLoad(): Void {
        AcceptButton.label = "$B612_TRAIN";
        AcceptButton.SetArt({PCArt: "E", XBoxArt: "360_A", PS3Art: "PS3_A"});
        ExitButton.label = "$B612_EXIT";
        ExitButton.SetArt({PCArt: "Tab", XBoxArt: "360_B", PS3Art: "PS3_B"});
        AcceptButton.addEventListener("click", this, "OnAcceptClick");
        ExitButton.addEventListener("click", this, "OnExitClick");
    }

    function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void {
        AcceptButton.SetPlatform(aiPlatform, abPS3Switch);
        ExitButton.SetPlatform(aiPlatform, abPS3Switch);
    }

    function InitExtensions() {
        skse.SendModEvent( 'b612_TrainingMenu_Ready' );
    }

    function onKeyDown() {
        if ( Key.getCode() === 9 ) {
            OnExitClick();
        } else if ( Key.getCode() === 13 ) {
            OnAcceptClick();
        }
    }

    function OnAcceptClick(aEvent: Object): Void {
        skse.SendModEvent( 'b612_TrainingMenu_Train' );
    }

    function OnExitClick(aEvent: Object): Void {
        skse.SendModEvent( 'b612_TrainingMenu_Close' );
    }

    // @papyrus
    function setSkillName(text:String) {
        // SkillName_tf.SetText( text );
        SkillName_tf.text = text;
    }

    // @papyrus
    function setTrainerSkill(text:String) {
        TrainerSkill_tf.SetText( text );
    }

    // @papyrus
    function setTimesTrained(text:String) {
        TimesTrained_tf.SetText( text );
    }

    // @papyrus
    function setTimesTrainedLabel(text:String) {
        TimesTrainedLabel_tf.SetText( text );
    }

    // @papyrus
    function setTrainCost(text:String) {
        TrainCost_tf.SetText( text );
    }

    // @papyrus
    function setCurrentGold(text:String) {
        CurrentGold_tf.SetText( text );
    }

    // @papyrus
    function setSkillMeterPercent(n:Number) {
        SkillMeter.SetPercent(n);
    }

    // @papyrus
    function render() {
        _visible = true;
    }
}