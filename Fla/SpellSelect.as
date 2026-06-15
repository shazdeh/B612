import skse;
import ShazdehUtils;

class SpellSelect extends MovieClip {

    public static var instance;

    public var Menu_mc:MovieClip;
    public var inventoryLists:MovieClip;
    public var itemList:MovieClip;

    /* filters */
    private var includeKeywords:Array = [];
    private var excludeKeywords:Array = [];
    private var CastingType:Array = [];
    private var DeliveryType:Array = [];
    private var Archetype:Array = [];
    private var ActorValue:Array = [];
    private var Magnitude:Number = -1;
    private var MagnitudeCompare:String = '<';
    private var Cost:Number = -1;
    private var CostCompare:String = '<';
    private var SkillLevel:Number = -1;
    private var SkillLevelCompare:String = '<';
    private var Area:Number = -1;
    private var AreaCompare:String = '<';
    private var School:Array = [];

    private var mustCheckKeywords:Boolean;

    function SpellSelect() {
        SpellSelect.instance = this;
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
            this = SpellSelect.instance;
            onItemSelect();
            return false;
        }
        Menu_mc.AttemptEquip = function( a_slot: Number, a_bCheckOverList: Boolean ) {
            return false;
        }

        itemList.B612__InvalidateData = itemList.InvalidateData;
        itemList.InvalidateData = function() {
            this = SpellSelect.instance;
            RemoveUnwantedItems();
            itemList.B612__InvalidateData();
        }
    }

    function onItemSelect() : Void {
        skse.SendModEvent('b612_SelectSpell', itemList.selectedEntry.spellName, itemList.selectedEntry.itemIndex);
    }

    function RemoveUnwantedItems() {
        for ( var i in itemList._entryList ) {
            if (
                (mustCheckKeywords && checkKeywords(itemList._entryList[i].effectKeywords))
                || (School.length && checkSchool(itemList._entryList[i].school))
                || (CastingType.length && checkCastingType(itemList._entryList[i].castType))
                || (DeliveryType.length && checkDeliveryType(itemList._entryList[i].deliveryType))
                || (Archetype.length && checkArchetype(itemList._entryList[i].archetype))
                || (ActorValue.length && checkActorValue(itemList._entryList[i].actorValue))
                || (Magnitude !== -1 && checkMagnitude(itemList._entryList[i].magnitude))
                || (Cost !== -1 && checkCost(itemList._entryList[i].infoSpellCost)) // effective spell cost
                || (SkillLevel !== -1 && checkSkillLevel(itemList._entryList[i].skillLevel))
                || (Area !== -1 && checkArea(itemList._entryList[i].area))
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

    function checkSchool(a_school:Number) : Boolean {
        return ShazdehUtils.array_search(a_school, School) === -1;
    }

    function checkDeliveryType(a_type:Number) : Boolean {
        return ShazdehUtils.array_search(a_type, DeliveryType) === -1;
    }

    function checkCastingType(a_type:Number) : Boolean {
        return ShazdehUtils.array_search(a_type, CastingType) === -1;
    }

    function checkArchetype(a_type:Number) : Boolean {
        return ShazdehUtils.array_search(a_type, Archetype) === -1;
    }

    function checkActorValue(a_type:Number) : Boolean {
        return ShazdehUtils.array_search(a_type, ActorValue) === -1;
    }

    function checkMagnitude(a_Mag:Number) : Boolean {
        return !compare(a_Mag, Magnitude, MagnitudeCompare);
    }

    function checkCost(a_Cost:Number) : Boolean {
        return !compare(a_Cost, Cost, CostCompare);
    }

    function checkSkillLevel(a_Level:Number) : Boolean {
        return !compare(a_Level, SkillLevel, SkillLevelCompare);
    }

    function checkArea(a_Area:Number) : Boolean {
        return !compare(a_Area, Area, AreaCompare);
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
    function setCastingType() {
        CastingType = arguments;
    }

    // @api
    function setDeliveryType() {
        DeliveryType = arguments;
    }

    // @api
    function setArchetype() {
        Archetype = arguments;
    }

    // @api
    function setActorValue() {
        ActorValue = arguments;
    }

    // @api
    function setSchool() {
        School = arguments;
    }

    // @api
    function setMagnitude(a_Mag:Number) {
        Magnitude = a_Mag;
    }

    // @api
    function setMagnitudeCompare(a_Compare:String) {
        MagnitudeCompare = a_Compare;
    }

    // @api
    function setCost(a_Cost:Number) {
        Cost = a_Cost;
    }

    // @api
    function setCostCompare(a_Compare:String) {
        CostCompare = a_Compare;
    }

    // @api
    function setSkillLevel(a_Level:Number) {
        SkillLevel = a_Level;
    }

    // @api
    function setSkillLevelCompare(a_Compare:String) {
        SkillLevelCompare = a_Compare;
    }

    // @api
    function setArea(a_Area:Number) {
        Area = a_Area;
    }

    // @api
    function setAreaCompare(a_Compare:String) {
        AreaCompare = a_Compare;
    }

    // @api
    function render() {
        itemList.InvalidateData();

        inventoryLists._visible = true;
    }
}
