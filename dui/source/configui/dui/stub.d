module configui.dui.stub;

import std.stdio;
import uniconfig.core;

/// Walk `flattenFormRows` — primary binder target for dui/dew (implementation TBD).
void describeForm(ConfigNode root)
{
    foreach (row; flattenFormRows(root))
    {
        import std.format : format;
        writeln(format("%s%s %s", "  ".repeat(row.depth), row.label,
                row.showIncludeToggle ? "[include?]" : ""));
    }
}

private string repeat(string s, int n)
{
    string acc;
    foreach (_; 0 .. n)
        acc ~= s;
    return acc;
}
