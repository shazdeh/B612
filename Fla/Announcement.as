import skse;
import Shared.GlobalFunc;
import skyui.util.Tween;

class Announcement extends MovieClip {

    public var ImageWrap_mc:MovieClip;
    public var Image_mc:MovieClip;
    public var Text_mc:MovieClip;
    public var Text_tf:TextField;
    public var Knotwork_mc:MovieClip;

    public var animationDuration = 1;
    public var knotworkDefaultWidth = 200;

    private var imageInitialY:Number;
    private var announcements:Array;
    private var interval;
    private var busy:Boolean;

    function Announcement() {
        super();
        announcements = new Array();
        Image_mc = ImageWrap_mc.Image_mc;
        Text_tf = Text_mc.Text_tf;
        Text_tf.autoSize = 'center';
        _alpha = 0;
        imageInitialY = ImageWrap_mc._y;
        ImageWrap_mc._y -= 20;
    }

    function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean): Void {}

    function InitExtensions() {}

    function announce( text:String, imagePath:String, delay:Number, knot:String ) {
        delay = delay || 2;
        announcements.push( {
            text : text, image : imagePath, delay : delay, knot : knot
        } );
        showNextAnnouncement();
    }

    function showNextAnnouncement() {
        if ( busy ) {
            return;
        }
        clearInterval(interval);

        if ( announcements.length > 0 ) {
            busy = true;
            var item = announcements.shift();
            Text_tf.SetText( item.text, true );
            if ( item.knot ) {
                Knotwork_mc.gotoAndStop(item.knot);
                Knotwork_mc.Knot_mc._width = Text_tf._width + knotworkDefaultWidth;
            } else {
                Knotwork_mc.gotoAndStop(0);
            }
            if ( item.image ) {
                Image_mc._visible = true;
                Image_mc.loadMovie( item.image );
            } else {
                Image_mc._visible = false;
            }
            Tween.LinearTween( ImageWrap_mc, '_y', imageInitialY - 20, imageInitialY, animationDuration );
            Tween.LinearTween( this, '_alpha', 0, 100, animationDuration );
            interval = setInterval( this, 'fadeOut', ( item.delay + animationDuration ) * 1000 );
        }
    }

    function fadeOut() {
        clearInterval(interval);
        busy = false;
        Tween.LinearTween( ImageWrap_mc, '_y', imageInitialY, imageInitialY - 20, animationDuration );
        Tween.LinearTween( this, '_alpha', 100, 0, animationDuration );
        interval = setInterval( this, 'showNextAnnouncement', animationDuration * 1000 );
    }
}