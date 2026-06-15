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

InventoryEntryData* GetEntryDataAtIndex(int index) {
    if (auto menu = UI::GetSingleton()->GetMenu<InventoryMenu>().get()) {
        auto items = menu->GetRuntimeData().itemList->items;
        if (index < items.size() && index >= 0) {
            return items[index]->data.objDesc;
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
    vm->RegisterFunction("UpdateInventoryMenu", scriptName, UpdateInventoryMenu);

    return false;
}

SKSEPluginLoad(const SKSE::LoadInterface* skse) {
    SetupLog();
    SKSE::Init(skse);
    SKSE::GetPapyrusInterface()->Register(PapyrusBinder);
    return true;
}
