#include "logger.h"
#include "ClibUtil/editorID.hpp"

void OpenMenu(StaticFunctionTag*, std::string a_menuName) {
    if (const auto UIMsgQueue = RE::UIMessageQueue::GetSingleton(); UIMsgQueue) {
        UIMsgQueue->AddMessage(a_menuName, RE::UI_MESSAGE_TYPE::kShow, nullptr);
    }
}

void CloseMenu(StaticFunctionTag*, std::string a_menuName) {
    if (const auto UIMsgQueue = RE::UIMessageQueue::GetSingleton(); UIMsgQueue) {
        UIMsgQueue->AddMessage(a_menuName, RE::UI_MESSAGE_TYPE::kHide, nullptr);
    }
}

InventoryEntryData* GetEntryDataAtIndex(int index) {
    if (auto menu = UI::GetSingleton()->GetMenu<InventoryMenu>().get()) {
        auto items = menu->GetRuntimeData().itemList->items;
        if (index < items.size() && index >= 0) {
            return items[index]->data.objDesc;
        }
    }
    return nullptr;
}

template <typename T>
T* GetExtraDataByType(InventoryEntryData* entryData) {
    auto extraLists = entryData->extraLists;
    if (extraLists) {
        for (const auto& xList : *extraLists) {
            if (!xList) continue;
            if (auto extraData = xList->GetByType<T>(); extraData) {
                return extraData;
            }
        }
    }
    return nullptr;
}

SpellItem* GetSpellByIndex(StaticFunctionTag*, int a_index) {
    if (const auto ui = UI::GetSingleton(); ui) {
        if (const auto menu = ui->GetMenu<MagicMenu>(); menu) {
            if (menu->GetRuntimeData().itemList->items.size() > a_index) {
                auto* item = menu->GetRuntimeData().itemList->items[a_index];
                if (item && item->data.baseForm && item->data.baseForm->GetFormType() == FormType::Spell) {
                    return item->data.baseForm->As<SpellItem>();
                }
            }
        }
    }
    return nullptr;
}

bool SetEntryOwner(StaticFunctionTag*, int index, TESForm* owner) {
    if (!owner) return false;
    auto entryData = GetEntryDataAtIndex(index);
    if (!entryData) return false;
    auto extraLists = entryData->extraLists;
    if (extraLists) {
        for (auto& xList : *extraLists) {
            xList->SetOwner(owner);
        }
    }

    return true;
}

TESForm* GetEntryOwner(StaticFunctionTag*, int index) {
    auto entryData = GetEntryDataAtIndex(index);
    if (!entryData) return {};
    auto extraLists = entryData->extraLists;
    if (extraLists) {
        for (auto& xList : *extraLists) {
            auto owner = xList ? xList->GetOwner() : nullptr;
            if (owner) {
                return owner;
            }
        }
    }
    return {};
}

int GetEntryCount(StaticFunctionTag*, int index) {
    if (auto menu = UI::GetSingleton()->GetMenu<InventoryMenu>().get()) {
        auto items = menu->GetRuntimeData().itemList->items;
        if (index < items.size() && index >= 0) {
            return items[index]->data.GetCount();
        }
    }
    return 1;
}

int GetEntryStolenCount(StaticFunctionTag*, int index) {
    auto entryData = GetEntryDataAtIndex(index);
    if (!entryData) return 0;
    int total = 0;
    auto extraLists = entryData->extraLists;
    if (extraLists) {
        TESForm* player = TESForm::LookupByID(0x7);
        for (auto& xList : *extraLists) {
            auto owner = xList ? xList->GetOwner() : nullptr;
            if (owner && owner != player) {
                total++;
            }
        }
    }
    return total;
}

#undef GetObject

TESForm* GetEntryForm(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return entryData->GetObject();
    }
    return {};
}

std::string GetEntryEditorID(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return clib_util::editorID::get_editorID(entryData->GetObject());
    }
    return "";
}

std::string GetEntryName(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return entryData->GetDisplayName();
    }
    return "";
}

EnchantmentItem* GetEntryEnchantment(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return entryData->GetEnchantment();
    }
    return {};
}

// this returns a percentage value
int GetEntryCharge(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        if (!entryData->GetObject()->Is(FormType::Weapon)) return 0;
        auto charge = entryData->GetEnchantmentCharge();
        if (charge.has_value()) return charge.value();
    }
    return 0;
}

float GetEntryMaxCharge(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        auto* object = entryData->GetObject();
        if (!object->Is(FormType::Weapon)) return 0.0f;
        auto weapon = object->As<TESObjectWEAP>();
        if (!weapon) return 0.0f;
        if (weapon->formEnchanting) {
            return weapon->amountofEnchantment;
        } else if (ExtraEnchantment* extraEnchant = GetExtraDataByType<ExtraEnchantment>(entryData); extraEnchant) {
            return extraEnchant->charge;
        }
    }
    return 0.0f;
}

float GetEntryCurrentCharge(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        if (!entryData->GetObject()->Is(FormType::Weapon)) return 0.0f;
        ExtraCharge* xCharge = GetExtraDataByType<ExtraCharge>(entryData);
        return xCharge ? xCharge->charge : GetEntryMaxCharge(nullptr, index); // When charge value is not present on an enchanted weapon, maximum charge is assumed
    }
    return 0.0f;
}

// @todo: this fails before item is used by player
void ModEntryCharge(StaticFunctionTag*, int index, float a_mod) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        if (!entryData->GetObject()->Is(FormType::Weapon)) return;
        ExtraCharge* xCharge = GetExtraDataByType<ExtraCharge>(entryData);
        if (xCharge) xCharge->charge += a_mod;
    }
}

AlchemyItem* GetEntryAppliedPoison(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        if (auto poisonData = GetExtraDataByType<ExtraPoison>(entryData); poisonData) {
            return poisonData->poison;
        }
    }
    return {};
}

int GetEntryPoisonCount(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        if (auto poisonData = GetExtraDataByType<ExtraPoison>(entryData); poisonData) {
            return poisonData->count;
        }
    }
    return 0;
}

float GetEntryHealth(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        if (!entryData->GetObject()->Is(FormType::Weapon) && !entryData->GetObject()->Is(FormType::Armor)) return 0.0f;
        if (auto healthData = GetExtraDataByType<ExtraHealth>(entryData); healthData) {
            return healthData->health;
        }
    }
    return 1.0f;
}

void SetEntryHealth(StaticFunctionTag*, int index, float value) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        if (!entryData->GetObject()->Is(FormType::Weapon) && !entryData->GetObject()->Is(FormType::Armor)) return;

        if (auto healthData = GetExtraDataByType<ExtraHealth>(entryData); healthData) {
            healthData->health = value;
        } else {
            // ?
        }
    }
}

bool IsEntryEquipped(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return entryData->IsWorn();
    }
    return false;
}

bool IsEntryFavorited(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return entryData->IsFavorited();
    }
    return false;
}

bool IsEntryQuestObject(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return entryData->IsQuestObject();
    }
    return false;
}

void UpdateInventoryMenu(StaticFunctionTag*) {
    RE::SendUIMessage::SendInventoryUpdateMessage(PlayerCharacter::GetSingleton(), nullptr);
}

bool PapyrusBinder(BSScript::IVirtualMachine* vm) {
    std::string_view scriptName = "B612_Utils"sv;

    vm->RegisterFunction("OpenMenu", scriptName, OpenMenu);
    vm->RegisterFunction("CloseMenu", scriptName, CloseMenu);
    vm->RegisterFunction("GetSpellByIndex", scriptName, GetSpellByIndex);
    vm->RegisterFunction("GetEntryForm", scriptName, GetEntryForm);
    vm->RegisterFunction("SetEntryOwner", scriptName, SetEntryOwner);
    vm->RegisterFunction("GetEntryOwner", scriptName, GetEntryOwner);
    vm->RegisterFunction("GetEntryStolenCount", scriptName, GetEntryStolenCount);
    vm->RegisterFunction("GetEntryCount", scriptName, GetEntryCount);
    vm->RegisterFunction("GetEntryEditorID", scriptName, GetEntryEditorID);
    vm->RegisterFunction("GetEntryName", scriptName, GetEntryName);
    vm->RegisterFunction("GetEntryEnchantment", scriptName, GetEntryEnchantment);
    vm->RegisterFunction("GetEntryCharge", scriptName, GetEntryCharge);
    vm->RegisterFunction("GetEntryMaxCharge", scriptName, GetEntryMaxCharge);
    vm->RegisterFunction("GetEntryCurrentCharge", scriptName, GetEntryCurrentCharge);
    vm->RegisterFunction("ModEntryCharge", scriptName, ModEntryCharge);
    vm->RegisterFunction("GetEntryAppliedPoison", scriptName, GetEntryAppliedPoison);
    vm->RegisterFunction("GetEntryPoisonCount", scriptName, GetEntryPoisonCount);
    vm->RegisterFunction("GetEntryHealth", scriptName, GetEntryHealth);
    // vm->RegisterFunction("SetItemHealthAtIndex", scriptName, SetItemHealthAtIndex);
    vm->RegisterFunction("IsEntryEquipped", scriptName, IsEntryEquipped);
    vm->RegisterFunction("IsEntryFavorited", scriptName, IsEntryFavorited);
    vm->RegisterFunction("IsEntryQuestObject", scriptName, IsEntryQuestObject);
    vm->RegisterFunction("_UpdateInventoryMenu", scriptName, UpdateInventoryMenu);

    return false;
}

SKSEPluginLoad(const SKSE::LoadInterface* skse) {
    SetupLog();
    SKSE::Init(skse);
    SKSE::GetPapyrusInterface()->Register(PapyrusBinder);
    return true;
}
