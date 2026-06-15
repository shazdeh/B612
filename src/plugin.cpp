#include "logger.h"

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

TESForm* GetItemByIndex(StaticFunctionTag*, int a_index) {
    if (const auto ui = UI::GetSingleton(); ui) {
        if (const auto menu = ui->GetMenu<InventoryMenu>(); menu) {
            if (menu->GetRuntimeData().itemList->items.size() > a_index) {
                auto* item = menu->GetRuntimeData().itemList->items[a_index];
                if (item && item->data.objDesc->object) {
                    return item->data.objDesc->object;
                }
            }
        }
    }
    return nullptr;
}

bool PapyrusBinder(BSScript::IVirtualMachine* vm) {
    std::string_view scriptName = "B612_Utils"sv;

    vm->RegisterFunction("OpenMenu", scriptName, OpenMenu);
    vm->RegisterFunction("CloseMenu", scriptName, CloseMenu);
    vm->RegisterFunction("GetSpellByIndex", scriptName, GetSpellByIndex);
    vm->RegisterFunction("GetItemByIndex", scriptName, GetItemByIndex);

    return false;
}

SKSEPluginLoad(const SKSE::LoadInterface* skse) {
    SetupLog();
    SKSE::Init(skse);
    SKSE::GetPapyrusInterface()->Register(PapyrusBinder);
    return true;
}
