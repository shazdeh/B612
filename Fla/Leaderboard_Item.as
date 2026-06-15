import gfx.io.GameDelegate;

class Leaderboard_Item extends MovieClip {

    /* Stage */
    public var Name_tf:TextField;
    public var Dot_tf:TextField;
    public var Score_tf:TextField;
    private var Menu_mc:MovieClip; /* reference to TraitsMenu */

    public var index:Number;
    private var data:Object;

    /* layout */
    private var sidePadding:Number = 15;

    function onLoad() {
    }

    function str_repeat(str:String, count:Number) : String {
        var result:String = '';
        for (var i = 0; i < count; i++) {
            result += str;
        }
        return result;
    }

    function setData(a_data:Object) {
        data = a_data;
        Name_tf.autoSize = 'left';
        Score_tf.autoSize = 'right';
        Name_tf.SetText(a_data.name);
        Score_tf.SetText(a_data.score);

        Dot_tf._x = Name_tf._width + sidePadding;
        Dot_tf._width = (Score_tf._x - sidePadding) - Dot_tf._x;
        Dot_tf.SetText(str_repeat('.', 150));
    }
}