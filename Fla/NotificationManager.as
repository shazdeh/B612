import skse;
import Messages;
import ShazdehUtils;

class NotificationManager extends MovieClip {

    public var MessagesBlock:MovieClip;
    public var MessageArray:Array;

    public var searchItems:Array;

    function onLoad() {
        MessagesBlock = _parent._parent.HUDMovieBaseInstance.MessagesBlock;
        MessageArray = MessagesBlock.MessageArray;
        searchItems = new Array();

        /* duck punch! */
        var _this = this;
        MessagesBlock.__Update = MessagesBlock.Update;
        MessagesBlock.Update = function() {
            _this.update();
        }
    }

    function update() {
        if ( MessageArray.length > 0 ) {
            for ( var i = 0; i < MessageArray.length; i++ ) {
                if ( isMatch( MessageArray[i] ) ) {
                    // skse.Log('B612: filtering: ' + MessageArray[i] );
                    MessageArray[i] = '';
                }
            }

            if ( MessageArray[0] === '' ) {
                MessageArray.shift();
            }
        }

        MessagesBlock.__Update();
    }

    function isMatch(messageText:String) : Boolean {
        var foundIndex = -1;
        for ( var j = 0; j < searchItems.length; j++ ) {
            if ( searchItems[ j ].text !== undefined ) {
                if ( searchItems[ j ].text === messageText ) {
                    foundIndex = j;
                    break;
                }
            } else if ( searchItems[ j ].before !== undefined ) {
                if ( messageText.substr(0, searchItems[ j ].before.length) === searchItems[ j ].before && messageText.substr(messageText.length - searchItems[ j ].after.length) === searchItems[ j ].after ) {
                    foundIndex = j;
                    break;
                }
            }
        }

        if ( foundIndex !== -1 ) {
            if ( searchItems[ foundIndex ].callback !== '' ) {
                skse.SendModEvent( searchItems[ foundIndex ].callback, messageText );
            }
            return true;
        }

        return false;
    }

    // @papyrus
    public function addItem( messageText:String, callbackName:String, beforeText:String, afterText:String ) {
        var item = {
            callback : callbackName
        };
        if ( messageText !== undefined && messageText !== '' ) {
            item.text = messageText;
        } else {
            item.before = beforeText;
            item.after = afterText;
        }
        searchItems.push( item );
    }

    // @papyrus
    public function removeItem(messageText:String) {
        var foundIndex = -1;
        for ( var i = 0; i < searchItems.length; i++ ) {
            if ( searchItems[ i ].text === messageText ) {
                foundIndex = i;
                break;
            }
        }
        if ( foundIndex !== -1 ) {
            searchItems = ShazdehUtils.array_remove_index(searchItems, foundIndex);
        }
    }
}