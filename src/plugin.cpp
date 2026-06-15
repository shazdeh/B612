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

bool SetOwnerOfIndex(StaticFunctionTag*, int index, TESForm* owner) {
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

TESForm* GetOwnerOfIndex(StaticFunctionTag*, int index) {
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

int GetItemCountAtIndex(StaticFunctionTag*, int index) {
    if (auto menu = UI::GetSingleton()->GetMenu<InventoryMenu>().get()) {
        auto items = menu->GetRuntimeData().itemList->items;
        if (index < items.size() && index >= 0) {
            return items[index]->data.GetCount();
        }
    }
    return 1;
}

int CountStolenAtIndex(StaticFunctionTag*, int index) {
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

TESForm* GetFormAtIndex(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return entryData->GetObject();
    }
    return {};
}

std::string GetFormEditorIDAtIndex(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return clib_util::editorID::get_editorID(entryData->GetObject());
    }
    return "";
}

std::string GetItemNameAtIndex(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return entryData->GetDisplayName();
    }
    return "";
}

EnchantmentItem* GetItemEnchantmentAtIndex(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        return entryData->GetEnchantment();
    }
    return {};
}

int GetItemChargeAtIndex(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        auto charge = entryData->GetEnchantmentCharge();
        if (charge.has_value()) return charge.value();
    }
    return 0;
}

AlchemyItem* GetAppliedPoisonOnItemAtIndex(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        if (auto poisonData = GetExtraDataByType<ExtraPoison>(entryData); poisonData) {
            return poisonData->poison;
        }
    }
    return {};
}

int GetAppliedPoisonCountOnItemAtIndex(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        if (auto poisonData = GetExtraDataByType<ExtraPoison>(entryData); poisonData) {
            return poisonData->count;
        }
    }
    return 0;
}

float GetItemHealthAtIndex(StaticFunctionTag*, int index) {
    if (auto entryData = GetEntryDataAtIndex(index); entryData) {
        if (auto healthData = GetExtraDataByType<ExtraHealth>(entryData); healthData) {
            return healthData->health;
        }
    }
    return 1.0f;
}

void UpdateInventoryMenu(StaticFunctionTag*) {
    RE::SendUIMessage::SendInventoryUpdateMessage(PlayerCharacter::GetSingleton(), nullptr);
}

bool PapyrusBinder(BSScript::IVirtualMachine* vm) {
    std::string_view scriptName = "B612_Utils"sv;

    vm->RegisterFunction("OpenMenu", scriptName, OpenMenu);
    vm->RegisterFunction("CloseMenu", scriptName, CloseMenu);
    vm->RegisterFunction("GetSpellByIndex", scriptName, GetSpellByIndex);
    vm->RegisterFunction("GetFormAtIndex", scriptName, GetFormAtIndex);
    vm->RegisterFunction("SetOwnerOfIndex", scriptName, SetOwnerOfIndex);
    vm->RegisterFunction("GetOwnerOfIndex", scriptName, GetOwnerOfIndex);
    vm->RegisterFunction("CountStolenAtIndex", scriptName, CountStolenAtIndex);
    vm->RegisterFunction("GetItemCountAtIndex", scriptName, GetItemCountAtIndex);
    vm->RegisterFunction("GetFormEditorIDAtIndex", scriptName, GetFormEditorIDAtIndex);
    vm->RegisterFunction("GetItemNameAtIndex", scriptName, GetItemNameAtIndex);
    vm->RegisterFunction("GetItemEnchantmentAtIndex", scriptName, GetItemEnchantmentAtIndex);
    vm->RegisterFunction("GetItemChargeAtIndex", scriptName, GetItemChargeAtIndex);
    vm->RegisterFunction("GetAppliedPoisonOnItemAtIndex", scriptName, GetAppliedPoisonOnItemAtIndex);
    vm->RegisterFunction("GetAppliedPoisonCountOnItemAtIndex", scriptName, GetAppliedPoisonCountOnItemAtIndex);
    vm->RegisterFunction("GetItemHealthAtIndex", scriptName, GetItemHealthAtIndex);
    vm->RegisterFunction("UpdateInventoryMenu", scriptName, UpdateInventoryMenu);

    return false;
}

SKSEPluginLoad(const SKSE::LoadInterface* skse) {
    SetupLog();
    SKSE::Init(skse);
    SKSE::GetPapyrusInterface()->Register(PapyrusBinder);
    return true;
}
