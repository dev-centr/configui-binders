module configui.dui.form;

import dew;
import dui.forms;
import std.format : format;
import std.json : JSONType;
import uniconfig.core;

/// Schema-aware form as a dew widget tree (ScrollView root).
@trusted
Widget buildConfigForm(ConfigNode root, void delegate() onDirty)
{
    if (root is null)
        return Text("Open a config file.").fontSize(14);

    Widget[] kids;
    foreach (row; flattenFormRows(root))
    {
        if (row.kind == FormControlKind.sectionHeader)
        {
            kids ~= Text(row.label).fontSize(13).bold();
            if (row.node.description.length)
                kids ~= Text(row.node.description).fontSize(11);
            continue;
        }
        kids ~= buildFieldRow(row, onDirty);
    }
    return ScrollView(VStack(kids).spacing(6).padding(12).width(Length.percent(100)))
        .width(Length.percent(100))
        .height(Length.percent(100));
}

@trusted
private Widget buildFieldRow(FormRow row, void delegate() onDirty)
{
    ConfigNode n = row.node;
    Widget[] headerKids;
    if (row.showIncludeToggle)
    {
        headerKids ~= CheckBox("include", n.included)
            .touchFriendly()
            .onClick(asSafeClick({
                n.included = !n.included;
                onDirty();
            }));
    }
    headerKids ~= Text(row.label).fontSize(11).bold();

    Widget control;
    final switch (row.kind)
    {
    case FormControlKind.boolean_:
        control = CheckBox("", displayValue(n) == "true")
            .touchFriendly()
            .onClick(asSafeClick({
                n.included = true;
                n.fromFile = true;
                setDisplayValue(n, displayValue(n) == "true" ? "false" : "true");
                onDirty();
            }));
        break;
    case FormControlKind.choice:
        control = Button(choiceLabel(n))
            .touchFriendly()
            .width(Length.percent(100))
            .onClick(asSafeClick({
                cycleEnum(n);
                onDirty();
            }));
        break;
    case FormControlKind.text:
        control = boundTextFieldForNode(n, onDirty);
        break;
    case FormControlKind.sectionHeader:
        control = Text("");
        break;
    }

    Widget[] colKids = [HStack(headerKids).spacing(6).width(Length.percent(100)), control];
    if (n.description.length)
        colKids ~= Text(n.description).fontSize(10);
    return VStack(colKids).spacing(4).width(Length.percent(100));
}

@trusted
private Widget boundTextFieldForNode(ConfigNode n, void delegate() onDirty)
{
    return TextField(displayValue(n))
        .placeholder("value")
        .width(Length.percent(100))
        .height(36)
        .focusable()
        .onKey(asSafeKey((KeyEvent ev) {
            if (ev.phase != KeyPhase.Down)
                return;
            if (ev.key == "Backspace")
            {
                auto cur = displayValue(n);
                if (cur.length)
                {
                    n.included = true;
                    n.fromFile = true;
                    setDisplayValue(n, cur[0 .. $ - 1]);
                    onDirty();
                }
                return;
            }
            if (ev.key.length == 1 && !ev.ctrl && !ev.alt && !ev.meta)
            {
                n.included = true;
                n.fromFile = true;
                setDisplayValue(n, displayValue(n) ~ ev.key);
                onDirty();
            }
        }));
}

private string choiceLabel(ConfigNode n)
{
    auto cur = displayValue(n);
    if (n.enumValues.length)
        return format("▸ %s", cur.length ? cur : n.enumValues[0]);
    return cur;
}

@trusted
private void cycleEnum(ConfigNode n)
{
    if (n.enumValues.length == 0)
        return;
    auto cur = displayValue(n);
    size_t idx;
    foreach (i, e; n.enumValues)
        if (e == cur)
            idx = i;
    idx = (idx + 1) % n.enumValues.length;
    n.included = true;
    n.fromFile = true;
    setDisplayValue(n, n.enumValues[idx]);
}

private void delegate() @safe asSafeClick(void delegate() @system fn) @trusted
{
    return cast(void delegate() @safe) fn;
}

private void delegate(KeyEvent) @safe asSafeKey(void delegate(KeyEvent) @system fn) @trusted
{
    return cast(void delegate(KeyEvent) @safe) fn;
}
