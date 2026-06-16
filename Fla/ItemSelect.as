import skse;
import ShazdehUtils;

class ItemSelect extends MovieClip {

    public static var instance;

    public var Menu_mc:MovieClip;
    public var inventoryLists:MovieClip;
    public var itemList:MovieClip;

    /* filters */
    private var includeKeywords:Array = [];
    private var excludeKeywords:Array = [];
    private var FormTypes:Array = [];
    private var Count:Number = 0;
    private var CountCompare:String = '=';
    private var Damage:Number = 0;
    private var DamageCompare:String = '=';
    private var ArmorRating:Number = 0;
    private var ArmorRatingCompare:String = '=';
    private var EquipState:Number = -1;
    private var IsEnchanted:Boolean = undefined;
    private var IsStolen:Boolean = undefined;

    private var mustCheckKeywords:Boolean;

    function ItemSelect() {
        ItemSelect.instance = this;
    }

    function onLoad() {
        super();
        Menu_mc = _parent._parent.Menu_mc;
        inventoryLists = Menu_mc.inventoryLists;
        itemList = inventoryLists.itemList;
        Menu_mc.bottomBar._visible = inventoryLists._visible = false;

        duckPunch();
    }

    function duckPunch() {
        Menu_mc.AttemptChargeItem = function() {
            return false;
        }
        Menu_mc.DropItem = function() {
            return false;
        }
        Menu_mc.onItemSelect = function() {
            this = ItemSelect.instance;
            onItemSelect();
            return false;
        }
        Menu_mc.AttemptEquip = function( a_slot: Number, a_bCheckOverList: Boolean ) {
            return false;
        }

        itemList.B612__InvalidateData = itemList.InvalidateData;
        itemList.InvalidateData = function() {
            this = ItemSelect.instance;
            RemoveUnwantedItems();
            itemList.B612__InvalidateData();
        }
    }

    function onItemSelect() : Void {
        skse.SendModEvent('b612_SelectItem', itemList.selectedEntry.text, itemList.selectedEntry.itemIndex);
    }

    function RemoveUnwantedItems() {
        for ( var i in itemList._entryList ) {
            var item = itemList._entryList[i];
            if (
                (mustCheckKeywords && checkKeywords(item.keywords))
                || (FormTypes.length && checkFormTypes(item.formType))
                || (EquipState !== -1 && item.equipState === EquipState)
                || (IsEnchanted !== undefined && item.isEnchanted === IsEnchanted)
                || (Count !== 0 && checkCount(item.count))
                || (Damage !== 0 && checkDamage(item.damage))
                || (ArmorRating !== 0 && checkArmorRating(item.armor))
                || (IsStolen !== undefined && item.isStolen === IsStolen)
            ) {
                delete itemList._entryList[ i ];
            }
        }
    }

    /* Return true means hide the item, false means keep it */
    function checkKeywords(keywordsList:Object) : Boolean {
        if ( includeKeywords.length ) {
            if ( keywordsList !== undefined ) {
                for ( var i = 0; i < includeKeywords.length; i++ ) {
                    if ( keywordsList[ includeKeywords[ i ] ] ) {
                        return false;
                    }
                }
            }
            return true;
        }

        if ( excludeKeywords.length ) {
            if ( keywordsList !== undefined ) {
                for ( var i = 0; i < excludeKeywords.length; i++ ) {
                    if ( keywordsList[ excludeKeywords[ i ] ] ) {
                        return true;
                    }
                }
            }
            return false;
        }
    }

    function checkFormTypes(a_type:Number) : Boolean {
        return ShazdehUtils.array_search(a_type, FormTypes) === -1;
    }

    function checkDamage(a_Value:Number) : Boolean {
        return !compare(a_Value, Damage, DamageCompare);
    }

    function checkCount(a_Value:Number) : Boolean {
        return !compare(a_Value, Count, CountCompare);
    }

    function checkArmorRating(a_Value:Number) : Boolean {
        return !compare(a_Value, ArmorRating, ArmorRatingCompare);
    }

    function compare(a:Number, b:Number, op:String) {
        if (op == "=" || op == "==") return a == b;
        if (op == "<") return a < b;
        if (op == "<=") return a <= b;
        if (op == ">") return a > b;
        if (op == ">=") return a >= b;
        if (op == "!=") return a != b;
        return false;
    }

    // @api
    function setIncludeKeywords() {
        includeKeywords = arguments;
        mustCheckKeywords = true;
    }

    // @api
    function setExcludeKeywords() {
        excludeKeywords = arguments;
        mustCheckKeywords = true;
    }

    // @api
    function setFormTypes() {
        FormTypes = arguments;
    }

    // @api
    function setCount(a_value:Number) {
        Count = a_value;
    }

    // @api
    function setCountCompare(a_Op:String) {
        CountCompare = a_Op;
    }

    // @api
    function setDamage(a_value:Number) {
        Damage = a_value;
    }

    // @api
    function setDamageCompare(a_Op:String) {
        DamageCompare = a_Op;
    }

    // @api
    function setArmorRating(a_value:Number) {
        ArmorRating = a_value;
    }

    // @api
    function setArmorRatingCompare(a_Op:String) {
        ArmorRatingCompare = a_Op;
    }

    // @api
    function setEquipState(a_value:Number) {
        EquipState = a_value;
    }

    // @api
    function setIsEnchanted(a_value:Number) {
        IsEnchanted = !a_value;
    }

    // @api
    function setIsStolen(a_value:Number) {
        IsStolen = !a_value;
    }

    // @api
    function render() {
        itemList.InvalidateData();

        inventoryLists._visible = true;
    }
}
