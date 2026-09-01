module configui.dui.banner;

import dew;
import std.format : format;
import std.path : baseName, dirName;
import std.process : browse;
import uniconfig.core;

/// Format chrome above the config form.
Widget buildDocumentBanner(const OpenedDocument doc)
{
    Widget[] kids;
    auto title = doc.profile.title.length ? doc.profile.title : baseName(doc.path);
    kids ~= Text(title).fontSize(16).bold();
    kids ~= Text(format("%s  ·  %s", formatName(doc.format),
            doc.profile.id.length ? doc.profile.id : "on-the-fly")).fontSize(11);

    Widget[] links;
    auto spec = formatSpecUrl(doc.format);
    if (spec.length)
        links ~= linkBtn("Format spec", spec);
    links ~= linkBtn("Codec source", "https://github.com/dev-centr/uniconfig-core");
    links ~= Button("Open file folder").touchFriendly().onClick(() { browse(dirName(doc.path)); });
    if (doc.profile.repositoryClosedSource)
        links ~= Text("Repository: closed source").fontSize(10);
    else if (doc.profile.repositoryUrl.length)
        links ~= linkBtn("Publisher repository", doc.profile.repositoryUrl);
    kids ~= HStack(links).spacing(8);
    return VStack(kids).spacing(6).padding(8).width(Length.percent(100));
}

private Widget linkBtn(string label, string url)
{
    return Button(label).touchFriendly().onClick(() { browse(url); });
}
