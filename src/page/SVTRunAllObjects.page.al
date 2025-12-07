namespace ScriptumVita.RunAllObjects;
using System.Reflection;
using System.Apps;
page 85150 "SVT Run All Objects"
{
    caption = 'Run All Objects';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = AllObjWithCaption;
    Editable = false;
    ModifyAllowed = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = where("Object Type" = filter(Table | Page | Report | Codeunit | XMLport));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                }
                field("Object Caption"; Rec."Object Caption")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Object Subtype"; Rec."Object Subtype")
                {
                    ApplicationArea = All;
                }
                field("App Package ID"; Rec."App Package ID")
                {
                    ApplicationArea = All;
                }
                field("App Package Name"; GetNavAppName(Rec."App Package ID"))
                {
                    Caption = 'App Package Name';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Run Object")
            {
                Caption = 'Run Object';
                ApplicationArea = All;
                Image = ExecuteBatch;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Scope = "Repeater";
                ShortcutKey = 'Ctrl+F5';

                trigger OnAction();
                begin
                    RunObject();
                end;
            }
        }
    }

    local procedure GetNavAppName(inAppPackageID: Guid): Text
    var
        NavApp: Record "NAV App Installed App";
    begin
        NavApp.SetRange("Package ID", inAppPackageID);
        if NavApp.FindFirst() then
            exit(NavApp.Name);
    end;

    local procedure RunObject()
    begin
        case Rec."Object Type" of
            Rec."Object Type"::Page:
                PAGE.RUN(Rec."Object ID");
            Rec."Object Type"::Report:
                REPORT.RUN(Rec."Object ID");
            Rec."Object Type"::Codeunit:
                CODEUNIT.RUN(Rec."Object ID");
            Rec."Object Type"::XMLport:
                XMLPORT.RUN(Rec."Object ID");
            Rec."Object Type"::Table:
                Hyperlink(GetUrl(ClientType::Current, CompanyName, ObjectType::Table, Rec."Object ID"));
            else
                Message('Object type ' + Format(Rec."Object Type") + ' ' + Rec."Object Name" + ' cant be run');
        end;
    end;

}